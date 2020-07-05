Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E93E214F7D
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:44:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgGEUot (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:44:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgGEUot (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:44:49 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F62C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:44:49 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id m9so5861027pfh.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:44:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=R8wg9nqFJfjnIUNp00G7QyzrIJG84iMxxXWTNAcOUiM=;
        b=NCCuZ2m4f8yJ7PDLNVQhHsuhSYy/7AN+9iKnGyRNHlNAX1RfKTCBnc9och1660c/1R
         Syaq1rjXBEKyPlVKspGAbTGFmiLa2Q+c1yReK2YlobixDzO/qkKM28ihlYhytG5oRJrM
         87caHcaMJbjMk203SN5XF2CH1NlriOVadMK8wTfq/XKqGYudaOp43Ac5/NUq32VlR+eA
         TRZClQtLOWFI1ohZltNpi0PlQgT6vfbjWJTZ4UGUSVcaP80+34JHydpJuiANIAZyhafu
         Yprh0WUK7PBhBziw3TkEyIpxNSWoZvuOlyiurRSC4oZdr3Zglr8Ld2OqTrae7DGjFcS4
         3q5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=R8wg9nqFJfjnIUNp00G7QyzrIJG84iMxxXWTNAcOUiM=;
        b=Wt/wotb3i1ZBtlnFOBDZ/oBxfp4J+aFu8iJ07kyks35W4awT/NVAGZX+VLht0A922Y
         wPdryu4cqfx/2Si0etE5mmR84M/SvovC1hCYw2Y9iu9LO5wxe6+8pL4wFbED2OUuSsv1
         y+8OoRGrjdGJJmHWdPYtxy56qk5ldioya4Wf8dDHfPQ2sPgdjcHSkDL2wKZ/UtML3eJx
         ChqTa+mVR+D0aokJxekmtODEGo3xQRDIHjgxOMnEyPeBihQ7P4yxhW8ewid+TdWZEtPa
         0fbE9qIhmyBPjPNRsnrjDDdj30RDwvORoYVGAyNL6NFqkzsxyem+yhiNBliRE8aznedG
         Q7VA==
X-Gm-Message-State: AOAM531hVV2VnenY34oKTX70+6RMri+AKlxNc6Z/O/M35Iwgxh3N+Bt/
        Tu4aaXO6lrTy+QH5lDZTzsw=
X-Google-Smtp-Source: ABdhPJzvhGZHAUz/m5n1woDOVpSyEIXfp1IkDLltw2JqsftURBxtDb5t8bR4qPCzJLXltUiOdCkr9w==
X-Received: by 2002:a63:c34e:: with SMTP id e14mr36295545pgd.55.1593981889013;
        Sun, 05 Jul 2020 13:44:49 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id 200sm17371542pfy.57.2020.07.05.13.44.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:44:48 -0700 (PDT)
Subject: Re: [PATCH net-next 2/7] net: phy: Fixup parameters in kerneldoc
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Alexandru Ardelean <alexaundru.ardelean@analog.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c3f41261-0b98-46ec-21a8-1c460dcce58a@gmail.com>
Date:   Sun, 5 Jul 2020 13:44:46 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> Correct the kerneldoc for a few structure and function calls,
> as reported by C=1 W=1.
> 
> Cc: Alexandru Ardelean <alexaundru.ardelean@analog.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
