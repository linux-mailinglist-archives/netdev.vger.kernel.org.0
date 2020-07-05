Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0149214F85
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728436AbgGEUpM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728207AbgGEUpL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:45:11 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2147C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:45:11 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id mn17so2595206pjb.4
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=htbMY740vqIV847HHrjA+YxILYYnlgQbv/xGCZmn5A4=;
        b=ICDqIFQS4fbkn9r/gJNPLatELSzq5xWCN7hGA+gYFhk4Q34efJOc2UqvvjSLSPOApa
         MW+9ktmqHtmsbLnprGarTYe5kewMq+DFBVgOEit70QBmr2ddmfpUR0PaHUQV+aBNXK+o
         o5k9KomfOgX99iEWwEXZtjXYqvUjcoV/SOFlN3Vk0iTq22PRuujhcIPHMJq94kQgIxK4
         RzYXJgN4a4vZP+CEg6CDQCzuAJx6uqY48pyuB+Nj645VWelrHBEHxCz0urIVlQzKVA6V
         Bn9m5ow3MPgVB45DlVR3ZJOHBti4bfW6meR95mjslyzhmIecVxttjga9XXfj2JqLjE8L
         aYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=htbMY740vqIV847HHrjA+YxILYYnlgQbv/xGCZmn5A4=;
        b=n6AQYErY+lC+Y/z6tZRg6LDd79gutX68We7kHCXWl5ElyLPnJFi98tXcEnPbKok9zh
         QE/g4godkY1wK3RbMGcsd75XGZsh3ziQ53Og5DOzd69kjsP5kqKiGBViDICbI76KphPA
         STM0utjR2iAM1qIea/s1gTVU9e7PBeMEl4afIx72xs0y9ut6lc93EKVyXGwCUpzHD4ZX
         D78aqXT/1THn1H++Ys4qxWFdmjYMcVYEC8DKAAoJtBMypcLSrVdkThDj4xUx0Wf5VQHd
         n5Dh3Bfkg8gk9e7Ah+E4O5rKortv3udhAq28scRkLtTL5RG7JFwo7hVrww55t8e5QLo2
         jjMg==
X-Gm-Message-State: AOAM531vtm5HNuH1K8tQLmRwJI1X8Paotb9NTOB5qeImCsbevo9VQg1f
        S65UXlQ8TuqeX7Ilq5v5dVI=
X-Google-Smtp-Source: ABdhPJzX1UX9j4L+aK5YTWZApgz1fjsZtMbik+GAb9G3iGJhPneL8AlpTIRWN2WTghMwDi1V/RasKg==
X-Received: by 2002:a17:90a:8082:: with SMTP id c2mr31771971pjn.204.1593981911273;
        Sun, 05 Jul 2020 13:45:11 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id n11sm16596354pgm.1.2020.07.05.13.45.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:45:10 -0700 (PDT)
Subject: Re: [PATCH net-next 3/7] net: phy: Properly define genphy_c45_driver
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>
References: <20200705182921.887441-1-andrew@lunn.ch>
 <20200705182921.887441-4-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46726977-310d-e74e-00f0-f40c4f632a03@gmail.com>
Date:   Sun, 5 Jul 2020 13:45:07 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705182921.887441-4-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 11:29 AM, Andrew Lunn wrote:
> Avoid the W=1 warning that symbol 'genphy_c45_driver' was not
> declared. Should it be static?
> 
> Declare it on the phy header file.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
