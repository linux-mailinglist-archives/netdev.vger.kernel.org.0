Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E44E4B8FB2
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 18:52:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237174AbiBPRwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 12:52:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:46296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiBPRwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 12:52:42 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93127EEA7E
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:52:29 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id u5so2580866ple.3
        for <netdev@vger.kernel.org>; Wed, 16 Feb 2022 09:52:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=dAudc4FDt1ctUyfjFY0Z5v9inbg9AJkDcJN3i0TREJo=;
        b=cxgjiTfu6SChwvZC5tV+rDB7PQBaIa8gw86sOz4LFUz+M/bnz8A4nYv9kNtmtbGT+3
         Xo+252YmSd5bvnLDLNKZU29kh4uyUHzsQRle5Cyl+bQM9WzwfkwPTKjcOigBZA8wc17G
         Kj4r1rGBIu6uyBXjNWbIJEoS/XXqp3JFlVcjy3FQIA/96baCQQMMAxvlQRiaghplsjLJ
         eXHB/zp6ioWFYN+jkn6+mUwjG9fWxJLah5jFoQMptEkoJt61fKq83EtscExDoJvhCxfL
         Ple3KLreaIh7CxTj9qIPX//Loggzr5+lL0vynuAF6KH/sjSjtNvChGv9U/diFwekt9X4
         0/1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=dAudc4FDt1ctUyfjFY0Z5v9inbg9AJkDcJN3i0TREJo=;
        b=NVALd/S11ciMnCAdIzF3Cs7a5k9EXbqQxLVt3QCm3KW2aRaUKexDZXcqwEab8ZLCYh
         MhodFpD69XOSPnH/W0gm8jIT3EnBv4TdAqcz7OqbUGHJED91/o+MmpXSQm7w0OP2SemS
         EVv92OqwYeU2h2nl4kHIw+2F5Yw38UgoDShU1631dro2TfA6zmxAA4JOQQkcmtEuFLsk
         x1rX8e4z9ol2oI4gNxk24K/nFNc1D+lAyhyVnbYCY+px7n1qDFpyZ/wx/5UhsSH3CwGH
         NN6XNur2QoVPTVL5qP3DEslOSwLWyKJPo4/r7h5sN2Wrp6V6W6Qz0Zd3da8VZPrbhTt+
         0knA==
X-Gm-Message-State: AOAM532vzdw4LidXJ0mccwbZsHRWE5+p8VnzmlBH2e2L+DNOd85nruz5
        sZmwyZZPwI/9vY+9NSS6XyP8qI4mbcA=
X-Google-Smtp-Source: ABdhPJwDKQ8f/b5TADIanYvdcqCCkhMCvJH4JsI8ELDR/IICMDWl1yBD/QCmFO3p8qxTfuzhvohPHg==
X-Received: by 2002:a17:90a:b304:b0:1b8:b322:aa4d with SMTP id d4-20020a17090ab30400b001b8b322aa4dmr3092734pjr.12.1645033948743;
        Wed, 16 Feb 2022 09:52:28 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id m20sm45730043pfk.215.2022.02.16.09.52.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Feb 2022 09:52:28 -0800 (PST)
Subject: Re: [PATCH RFC net-next 1/5] net: dsa: b53: clean up if() condition
 to be more readable
To:     "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <YfvrIf/FDddglaKE@shell.armlinux.org.uk>
 <E1nFdPI-006Wh0-HW@rmk-PC.armlinux.org.uk>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <7eed88b8-d0d1-c1b7-322f-a7b82544077c@gmail.com>
Date:   Wed, 16 Feb 2022 09:52:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <E1nFdPI-006Wh0-HW@rmk-PC.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2/3/22 6:48 AM, Russell King (Oracle) wrote:
> I've stared at this if() statement for a while trying to work out if
> it really does correspond with the comment above, and it does seem to.
> However, let's make it more readable and phrase it in the same way as
> the comment.
> 
> Also add a FIXME into the comment - we appear to deny Gigabit modes for
> 802.3z interface modes, but 802.3z interface modes only operate at
> gigabit and above.
> 
> Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Did I mention that I always struggled and still do with double negations
and not just while programming?
-- 
Florian
