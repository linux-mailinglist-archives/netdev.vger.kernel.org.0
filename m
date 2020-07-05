Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2911A214F67
	for <lists+netdev@lfdr.de>; Sun,  5 Jul 2020 22:38:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgGEUiR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jul 2020 16:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728113AbgGEUiR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jul 2020 16:38:17 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 616F0C061794
        for <netdev@vger.kernel.org>; Sun,  5 Jul 2020 13:38:17 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id k71so12401391pje.0
        for <netdev@vger.kernel.org>; Sun, 05 Jul 2020 13:38:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=sqX8K/Y97L8YWcKkT6kxxjDCTk6R4usWakIWqBe4BaE=;
        b=RsTL7vB4upy7LKVLfJKgJ3+tORfcu0LhzpwdgKFRd7s+Xo0kx/eHTbh/ngUM0HUJdl
         S16BQg1ArX5uOkJ1tAl6mqPGXfDmD8dn8MoGLulhxMTcBY98bxUoTnYnt/sA6hF5w5cJ
         xffRjA5A7pAW/i9eY1SK3/ci4xlhK87GBvp1J2val7qIAueyandMEU/co04Va+rTuIbq
         rPdHbMppaBFIiwoL1cyvp6mmAZSMt0sKJFHfpm/UhLBGnSsMmvLdAPXJxEJ7eYVi41sF
         rNl1n76ZEqCHtl201TVkEOO7PX07XcnjL2xqHC36SPgi//crJWCDHFahpAq2lHvg91tf
         Qjmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=sqX8K/Y97L8YWcKkT6kxxjDCTk6R4usWakIWqBe4BaE=;
        b=X2m0n0yXp2NrGGopLLN8R9d+ChQMsuaufu1xEybV68d3hjRhyu4YWoe79cJp5JNgws
         +f4SfaYp7GaVncW0E4dFy+Zn38jgx2ENtyJnPJzPo5ioKe/OFXBxwx722pcArGlScibo
         Cl4hWI3USGSlE3FKzNPUm9Z5GWRCnN0CzvwPu9sMzM1YLxVWS2K49U+cgQTNkDTkAz4t
         uwdme0MzwOURjD8vrvqPrn6ja7prBBqP3JCTlyf8kiV+OqHvmmutDbIIjrf55Sk5fW41
         ZdnB3pejBCRzICA0qPPqfiUnNfIQx+lCOVI4GXSMAlYlxew2qSurbRTkh5iez/4JsYma
         cxuA==
X-Gm-Message-State: AOAM531OYff1etOnqufb0/Gr/ph0BRC+AYFkZ90e+s9ffX0JComRLKzu
        t37LvGndQgCvqDdTbDt+3bq0KoT1
X-Google-Smtp-Source: ABdhPJzoywaAWRdeA0s6eaFeI15EyuXuZbksnOTLk/87DnWSbKEPuAURGeZ2zvHpl0tESWavJlmHmA==
X-Received: by 2002:a17:902:b413:: with SMTP id x19mr17658683plr.286.1593981496514;
        Sun, 05 Jul 2020 13:38:16 -0700 (PDT)
Received: from ?IPv6:2001:470:67:5b9:5dec:e971:4cde:a128? ([2001:470:67:5b9:5dec:e971:4cde:a128])
        by smtp.gmail.com with ESMTPSA id n12sm17137882pgr.88.2020.07.05.13.38.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 05 Jul 2020 13:38:15 -0700 (PDT)
Subject: Re: [PATCH net-next 2/3] dsa: bcm_sf2: Initialize __be16 with a
 __be16 value
To:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200705203625.891900-1-andrew@lunn.ch>
 <20200705203625.891900-3-andrew@lunn.ch>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <34eb76ec-2c0c-64d8-fb9c-100000eb4edf@gmail.com>
Date:   Sun, 5 Jul 2020 13:38:12 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200705203625.891900-3-andrew@lunn.ch>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/5/2020 1:36 PM, Andrew Lunn wrote:
> A __be16 variable should be initialised with a __be16 value.  So add a
> htons(). In this case it is pointless, given the value being assigned
> is 0xffff, but it stops sparse from warnings.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

The subject should be:

net: dsa: bcm_sf2: Initialize __be16 with a __be16 value

to be consistent with other commits done to the same file, with that:

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
