Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4A458CF90
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 23:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243789AbiHHVSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 17:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238106AbiHHVSb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 17:18:31 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A84D18B1C
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 14:18:31 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id u133so9126566pfc.10
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 14:18:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=aiU3knaJe/5mq9tQWMQcztgnEvFZa6TXWO4FCkyBl2g=;
        b=Il5GG1ZHoNLmwNQ+x1mDxXsbZlCjA0vPDav/8L4R3GuMtqxekTJTRSoyVOTSO7ZOQa
         HEWqQTOzLflUNSIx6jSOx11/WsTCS5PFUWfxv52NUSIxTmzUOpVDL0riWS61jHFJaeli
         e5W5ZbTP/q8aKDKjai3GTaNZkaVrlK/2fJ85+apd3DMGTyUmEGhPUrSagkm42mGn6ovo
         SC9Pm1+ZM8KWzIcM05l2j23g53P6ZpDzBDEypIDaALqIpryHGlilwK+eKiH4LVNwPKbF
         4kkTX3jTGy7HU/58qdNyJKen5TOFquJXlrQzcnnY3bGHYML4Yv29z/4+R1NwaU5dSMoZ
         jr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=aiU3knaJe/5mq9tQWMQcztgnEvFZa6TXWO4FCkyBl2g=;
        b=uLpTgnj/Ow+ocoOJERApPSHtmV7voqHxa/5CdEzG3xziT4xbEot+VqGvKle0mmgyq2
         rJlavH/GvLjYomXx4fHdd+3HONlaZaXTiXnw++4ldQav6btwUVCj7PZGZg1f2rvBkyYa
         ILgagi6w2RSdN1+TAaHPeesxFVB6orCDTIxNDrHcv9/s6cTnYtTwJK5sl3oiXeJ2u6HX
         u6QAkvbJ7da7/QJAtaoT1/ZsuiT3H0OWPzca7C4jvyjpg+PUEM350hJAvtnSzp6M4BoU
         huqf2Mh/0BwSQFm+gxM8p5JM3b3YNYLdxaY3YlwjHilBHPit/6mdy7+9KkrgbQyelFK9
         tJLA==
X-Gm-Message-State: ACgBeo3KXRwbQjQahN0SUF2p+jfsQvtUWMhry1jhzoZgFS4Al5FZ3BTm
        ZM9E5WbqIKpv9rKdzZJ6ahLfrFYcKRXjRw0sy4ZNUUFT4kQ=
X-Google-Smtp-Source: AA6agR61Nc+esj8//GcCCO8bAmwgAIWkx8DFTG3Ngs/UdGDEcuHG7wKKkL5LpFl8+w3GvuGPLTdh5+gPEVJ7z8QN6Ww=
X-Received: by 2002:a63:fd0b:0:b0:415:f76b:a2cd with SMTP id
 d11-20020a63fd0b000000b00415f76ba2cdmr16736503pgh.440.1659993510425; Mon, 08
 Aug 2022 14:18:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
 <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
In-Reply-To: <5914cae0-e87b-fb94-85dd-33311fc84c52@seco.com>
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 8 Aug 2022 14:18:18 -0700
Message-ID: <CAJ+vNU2HOtMOA7JC08AKperVNzbpcavoc8uKmC5YL6B+GH7dJA@mail.gmail.com>
Subject: Re: ethernet<n> dt aliases implications in U-Boot and Linux
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 8, 2022 at 12:58 PM Sean Anderson <sean.anderson@seco.com> wrote:
>
> Hi Tim,
>
> On 8/8/22 3:18 PM, Tim Harvey wrote:
> > Greetings,
> >
> > I'm trying to understand if there is any implication of 'ethernet<n>'
> > aliases in Linux such as:
> >         aliases {
> >                 ethernet0 = &eqos;
> >                 ethernet1 = &fec;
> >                 ethernet2 = &lan1;
> >                 ethernet3 = &lan2;
> >                 ethernet4 = &lan3;
> >                 ethernet5 = &lan4;
> >                 ethernet6 = &lan5;
> >         };
> >
> > I know U-Boot boards that use device-tree will use these aliases to
> > name the devices in U-Boot such that the device with alias 'ethernet0'
> > becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
> > appears that the naming of network devices that are embedded (ie SoC)
> > vs enumerated (ie pci/usb) are always based on device registration
> > order which for static drivers depends on Makefile linking order and
> > has nothing to do with device-tree.
> >
> > Is there currently any way to control network device naming in Linux
> > other than udev?
>
> You can also use systemd-networkd et al. (but that is the same kind of mechanism)
>
> > Does Linux use the ethernet<n> aliases for anything at all?
>
> No :l
>

Sean,

Ok - thanks for the confirmation!

Best Regards,

Tim
