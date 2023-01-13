Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE1F166A6F4
	for <lists+netdev@lfdr.de>; Sat, 14 Jan 2023 00:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231294AbjAMXUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 18:20:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjAMXUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 18:20:18 -0500
Received: from mail-oa1-x35.google.com (mail-oa1-x35.google.com [IPv6:2001:4860:4864:20::35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64A9D8CBE3
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:20:12 -0800 (PST)
Received: by mail-oa1-x35.google.com with SMTP id 586e51a60fabf-15027746720so23893068fac.13
        for <netdev@vger.kernel.org>; Fri, 13 Jan 2023 15:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=landley-net.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TQ9PrP3iNHpghVpkywhiMHcSFTwXN8kLEUSP7zNfGWk=;
        b=HEeiDnUeOlaMmzrHg6LtTWNe2KIF6Q5d6PASMOjvpBnFNwlXnpxtBoyLsjdUSiFic5
         Zy4GrupmECG1CN3m99XRInimzLkAyFlnAC1yFwr9ZV5WqZ8Mxia0axE41+SyDlpGZHOF
         b9/hPmk9ZzrDZTerjRuPw9aOBuwmuFZgGCgGCyi5DNv5BOgrp6hpzWbx8PiSSS3PCS6S
         UoJjpLq7r0mXx6nv8CL2PCVxH6W+Fc0fSdqCoguiOJxRwovXLajxMhMVOFQITRvWQd2L
         +x8hdq/wHJdMhQD25h3cEnBEwX4srdIbxyBywCRXQlXO+4KVbgaam+X20emmeoxJCckb
         5wPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TQ9PrP3iNHpghVpkywhiMHcSFTwXN8kLEUSP7zNfGWk=;
        b=UMwicjZAIXF2mrtzvKPZBpbgnxwyl8b0luNPF/zrb9V2dyBRw91WVn6hUM7d0mrPLN
         uhvdgRKMluO5BbLBP5HcmGj0EurNxmXu8bzjCfzEi8e3cJEm8MftEqF6ZZ1h8WDPLBia
         mH+JdUIDT9/SooM2lpsA+ieLYa5l6DoPjaqal0rFXJSZlccviMeNKC0DPpzioxcu4gUf
         4SGrS/3ki/LNkQIKX+0Yf8K7+DuRmTJ/qbfyl1Kyw0UOV0ZgAomMy756lMy9f3ZcVz8H
         WUjThivmCwqfjILSMbu63bHyGMYQQ2guir0VAOsMSrvgEi0XeWyNN6UvF/Ac37s8S9ss
         5YzA==
X-Gm-Message-State: AFqh2krk5zKkRA3mVpXuSgRe98CvAIJ6sdulCzPQfdGMjsVyFvOEBCyf
        ty2/TqJaftiW4DajCFXd9Gzt3w==
X-Google-Smtp-Source: AMrXdXu9HHEo/oiUtz2RMFCVU9bzsQZjZJ6cJq7QQE+EgrBS53y1RWYqF/4GpGuzhXIiUysKwMTRjQ==
X-Received: by 2002:a05:6871:4090:b0:155:cb39:7325 with SMTP id kz16-20020a056871409000b00155cb397325mr16579350oab.6.1673652012126;
        Fri, 13 Jan 2023 15:20:12 -0800 (PST)
Received: from [192.168.86.224] ([136.62.38.22])
        by smtp.gmail.com with ESMTPSA id z13-20020a056870738d00b0013ae39d0575sm11411907oam.15.2023.01.13.15.20.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 15:20:11 -0800 (PST)
Message-ID: <38200b53-c743-4396-6603-7274f4a29c86@landley.net>
Date:   Fri, 13 Jan 2023 17:32:20 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: remove arch/sh
Content-Language: en-US
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Cc:     Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
References: <20230113062339.1909087-1-hch@lst.de>
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <CAMuHMdUcnP6a9Ch5=_CMPq-io-YWK5pshkOT2nZmP1hvNcwBAg@mail.gmail.com>
 <142532fb-5997-bdc1-0811-a80ae33f4ba4@physik.fu-berlin.de>
 <6891afb6-4190-6a52-0319-745b3f138d97@landley.net>
 <fe09d811-e290-821d-ec8b-75936b6583c2@physik.fu-berlin.de>
From:   Rob Landley <rob@landley.net>
In-Reply-To: <fe09d811-e290-821d-ec8b-75936b6583c2@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/13/23 13:05, John Paul Adrian Glaubitz wrote:
> Hi Rob!
> 
> On 1/13/23 20:11, Rob Landley wrote:
>> There is definitely interest in this architecture. I'm aware Rich hasn't been
>> the most responsive maintainer. (I'm told he's on vacation with his family at
>> the moment, according to the text I got about this issue from the J-core
>> hardware guys in Japan.)
> 
> Well, maybe we can just give it a try together ...

Jeff Dionne said he'd make himself available to answer hardware questions. (He
said he maintained some Linux ports 20 years ago, but isn't current with Linux
plumbing. Last month he was digging through the guts of vxworks, and the project
before that was some sort of BSD I think?)

I _do_ maintain Linux patches, I just generally don't bother to repost them
endlessly. Here's my "on top of 6.1" stack for example, each of which links to
at least one time it was posted to linux-kernel:

https://landley.net/toybox/downloads/binaries/mkroot/0.8.9/linux-patches/

>> The main reason we haven't converted everything to device tree is we only have
>> access to test hardware for a subset of the boards. Pruning the list of
>> supported boards and converting the rest to device tree might make sense. We can
>> always add/convert boards back later...
> 
> There is a patch by Yoshinori Sato which adds device tree support to SH. Maybe we
> can revive it.

The turtle board is device tree and has been since it was merged. The
infrastructure is there, the question is converting over boards and testing
them, or deciding to prune them. Did Sato-san convert many boards? (I'm not
finding his patch via google...)

> Adrian

Rob
