Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BEB664262D
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 10:55:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231464AbiLEJza (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 04:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231265AbiLEJz2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 04:55:28 -0500
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F231742E
        for <netdev@vger.kernel.org>; Mon,  5 Dec 2022 01:55:26 -0800 (PST)
Received: by mail-ed1-x52b.google.com with SMTP id e13so14945694edj.7
        for <netdev@vger.kernel.org>; Mon, 05 Dec 2022 01:55:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5t8Zxcrb+H4S05AQ/AraVBApneGFb/IHc/5E++wpWSU=;
        b=WiqRSkcWL+Sj7ba2AZFBTP5DcCJeqY9WedM96JIxUrFKuF5kiFaV7lxTwhppkhGO6k
         6KPbo3SwEoDafrCAIwTuN9DNuznXsDnp3NmJMVWiXKDZOYYABg5xY7sP5AHBAy1LpSvO
         vYXMnlrKcqDFBcKJ+TiaTEib0whUIy0Odr5FBXuOFEQCtZyzOzPEid34L1SF6P3NDxHJ
         xK/LaJqP6BaYski375Xfb/D1gV3wIy/Fje+sVfa/XawH+j9dGuaKSWXHHzUzNgLTopm/
         sJHn52sRE5ULE7Yn3ED8M6IVkv4iNeGGZPE8zaQyMnDzTJuqfk1Axaq18Ww8u6NVcdp1
         pkeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5t8Zxcrb+H4S05AQ/AraVBApneGFb/IHc/5E++wpWSU=;
        b=CY5eCkvccpPItfaO0fTC9cbmpYfNMFKSjx9YdFOYAxOonAC58WHecfm/CiT2HxrFiV
         L50t4HqN+j27oh6/5kE9YEGfJach9SW7gECExKQd4bzhUfdNUfEo5fypbGQof63gzYwk
         N4WqWsPey3ko5fO+6TV9vYwVK4iGj/37XPXK6/Jvr+iOjEP/8i8Q9F/35pNbOZHZwriM
         4or0c9G9DLUS49SyauqPTrI4U1y5aNKcxT4FFfhzKnq6gUFOL21vgLolLX+I9TX45bIS
         D3uxJmXoKGXK8ldY9MKZtKoJYzmT8Faowprv/6eK9mI1uCuVbZFLjuoEW6O3r6y09hke
         AJhg==
X-Gm-Message-State: ANoB5pnpMPPNqAoUNGsZKJs7ua41KRvAk0GjGo8lt5T8T3sBanhSdBTz
        pbL0QPwYhQ4pdAeFBefqAXi8dQ==
X-Google-Smtp-Source: AA0mqf4+Vr8oNX+baEGQRy7Gf9y/wATbL4bIBvFJ4WJaG+PANkrG5kyQRbVd/BXSJpsV5lR6P9oyyQ==
X-Received: by 2002:aa7:c042:0:b0:462:2f5a:8618 with SMTP id k2-20020aa7c042000000b004622f5a8618mr73787160edo.42.1670234124657;
        Mon, 05 Dec 2022 01:55:24 -0800 (PST)
Received: from blmsp ([185.238.219.8])
        by smtp.gmail.com with ESMTPSA id c7-20020a056402120700b0046b94e67b4bsm6050822edw.86.2022.12.05.01.55.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 01:55:24 -0800 (PST)
Date:   Mon, 5 Dec 2022 10:55:23 +0100
From:   Markus Schneider-Pargmann <msp@baylibre.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/15] can: tcan4x5x: Fix register range of first block
Message-ID: <20221205095523.sy3piugsrvik2zz3@blmsp>
References: <20221116205308.2996556-1-msp@baylibre.com>
 <20221116205308.2996556-15-msp@baylibre.com>
 <20221202142810.kmd5m26fnm6lw2jh@pengutronix.de>
 <20221205093013.kpsqyb3fhd5njubm@blmsp>
 <20221205094458.xkvlvp7fnygf23fq@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221205094458.xkvlvp7fnygf23fq@pengutronix.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 10:44:58AM +0100, Marc Kleine-Budde wrote:
> On 05.12.2022 10:30:13, Markus Schneider-Pargmann wrote:
> > Hi Marc,
> > 
> > On Fri, Dec 02, 2022 at 03:28:10PM +0100, Marc Kleine-Budde wrote:
> > > On 16.11.2022 21:53:07, Markus Schneider-Pargmann wrote:
> > > > According to the datasheet 0x1c is the last register in the first block,
> > > > not register 0x2c.
> > > 
> > > The datasheet "SLLSF91A – DECEMBER 2018 – REVISED JANUARY 2020" says:
> > > 
> > > | 8.6.1 Device ID and Interrupt/Diagnostic Flag Registers: 16'h0000 to
> > > | 16'h002F
> > > 
> > > While the last described register is at 0xc.
> > 
> > Sorry, not sure what I looked up here. The last described register is
> > 0x10 SPI Error status mask in my datasheet:
> > 'SLLSEZ5D – JANUARY 2018 – REVISED JUNE 2022'
> 
> The TCAN4550-Q1 variant has the 0x10 register documented, while the
> TCAN4550 (w/o -Q1) doesn't have.

Ah haven't noticed, thank you.

> 
> > I would prefer using the actual registers if that is ok with you, so
> > 0x10 here because I assume the remaining registers have internal use or
> > maybe don't exist at all?! If there is an undocumented register that
> > needs to be used at some point we can still modify the ranges.
> 
> I'm fine with using 0x10 as the last register.
> 
> > Also it seems the existing ranges are following the same logic and don't
> > list the whole range, just the documented registers.
> > 
> > The second range is wrong as well. The last register is 0x830, will
> > fix.
> 
> IIRC I used the register ranges from the section titles ("8.6.1 Device
> ID and Interrupt/Diagnostic Flag Registers: 16'h0000 to 16'h002F") when
> I added the {wr,rd}_table.

The second range in the driver was specified as 0x800-0x83c in the
driver. The last documented register is 0x830 in both normal and Q1
versions while the range in the title is 0x800-0x8ff. That's why I
thought it was using the last register, just because it is closer.

Anyways not really important.

I can put in whatever you feel comfortable with or keep as it is.

Thanks,
Markus
