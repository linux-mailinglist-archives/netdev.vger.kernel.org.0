Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C401214F8B
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:45:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728398AbgGEUpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:45:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgGEUpx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:45:53 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAC2BC061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:45:53 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id t11so11260321pfq.11
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WMbGbT9QdSuj0RATy9iNK9e2qO8pBLeIKSsqGeRa/ao=;
        b=RXSdWz8H27grYYmQ104mv3CUDd7aKmJjsFo9xiZ8Ym7cTZZYUjRzSWqz61J4hkdESS
         aXwmAGZTnytICb9SK5hw79pTlz2kX4EtLI45P612Y3/c2MgKPryvT4MpT2Hykmqn7fgy
         5F7yVHA7+ytd5+BmBnJ9kHv0ZyKGrvkNpUIIWDAGvo0KlxUVsfEO8Rz2mBtjdr9O35w9
         5PFKucQFFlhkvzKBd6V8FTZhMJ0kziOYq6hFq9Dc+Rq0vFdAiXOif7e3d/Nqg7ZytV/r
         2gWbk2qLAqaOTMtmC4rcHDXd42S2UYIRxY2JgPZFOhY9PYkVGNPlNP8P+TukED2TsYhM
         wzIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WMbGbT9QdSuj0RATy9iNK9e2qO8pBLeIKSsqGeRa/ao=;
        b=HgAemRuW6+N89jEm7NdbtvA6IFXQDrKFFjFNHz0Py+lkw5JJdxqjS4qeksKLcNkL4l
         IcNK0nwLVjaNOlK3brWkGPRFxqg/0Jl8k0DGdYOYm8KoiTGkwi7CWuPY5d23ycxKX5es
         UoN4mreCOPoJZTrmBm1sm2nQU2QcO3hphe9XHCftmL+d/k/i3attMuNzds06a95h3ccx
         6bY6bIX1t0bV0Egdl8CxIilVjmZdci+SWHLYMrgNfWn2MFuyFSamIWAH8aNdbdfK7Jae
         vLehF0fGN2r97m+wfnLjrJ3NbVlGhsUfYluemNlh6hNFHyDguiKNnF5CDsvFylRK3cp7
         qryw==
X-Gm-Message-State: AOAM531lBHJJmZ3POCtzFsjUSttNKD0XtxTjDZJtf3HsZRYkpIOs3kNP
        oWtrBWpYKAcRa4M4hOt7bwQ=
X-Google-Smtp-Source: ABdhPJw4V6VrJ6bnBMvDC3FPNYEQ/awfNx7cxbbNUNA2sMbpvq9aPXzgviGXTT2EXy+Cp7rbs44i+w==
X-Received: by 2002:aa7:84ce:: with SMTP id x14mr37610810pfn.220.1593981953446;
        Sun, 05 Jul 2020 13:45:53 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id bg6sm16351147pjb.51.2020.07.05.13.45.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:45:52 -0700 (PDT)
Subject: Re: [PATCH net-next 5/7] net: phy: dp83640: Fixup cast to restricted
 __be16 warning
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-6-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <9d433028-1c46-d24b-f700-63f12c45f3af@gmail.com>
Date:   Sun, 5 Jul 2020 13:45:50 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-6-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> ntohs() expects to be passed a __be16. Correct the type of the
> variable holding the sequence ID.
> 
> Cc: Richard Cochran <richardcochran@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
