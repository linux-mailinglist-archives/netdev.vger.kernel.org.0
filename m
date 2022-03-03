Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 429454CB42A
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 02:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbiCCAl4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 19:41:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230456AbiCCAlz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 19:41:55 -0500
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0D7621A2
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 16:41:06 -0800 (PST)
Received: by mail-ej1-x62d.google.com with SMTP id qt6so7238177ejb.11
        for <netdev@vger.kernel.org>; Wed, 02 Mar 2022 16:41:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dyhdH8yVwujpH7jVlSFrGTvhiGeWm/V/9QVZ0+HaToU=;
        b=dTk+s5TFp5OLCjyLX2vL0N4O9wc+A5qhpYoNrYjjZdbmPFlKCexKp8MDm2shuv4LJN
         VOmSqo7PyM/0uWJIcBqxuv6+/9aBbImx6o/ouDhWwFz8bruh2EJqRC4ze+ZQKMwvAvlE
         Nfff0Id73NvQJ2tU6YthfE5AzDFnmh9lenQXaHGp0dExveTNtQhtUyjzpO4bv7T8tJ8O
         B+c/uf1rVLTut4yT+z8us9qRaN7yWDS0lz+NbLw2KP1Xi7+gv/3WtglxOgHUnksGVPv7
         /s0Z9nxXUH8YAh2V0zQ26iQCU1oOTeGmFqBuJ23iakFxpOQ7k2iEbUNW7S24ynj/o4tu
         n1/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dyhdH8yVwujpH7jVlSFrGTvhiGeWm/V/9QVZ0+HaToU=;
        b=aBq4VSn46o3DuSsiA51jyZW+yyryUWAMdxTiA7dqSizh4THcST/tFI8MvriZGYwP01
         AxC91EYUqq+jRjaRZ8M343C66a8jxGurEV7ap1Bq/c/bX/qzeFnrQxUbiDE5YyalWeHT
         aW+uCShb+cBSuojrxmbF76z+aTupdEWoxlhtRfXmDRKorrFejEDZShzPt10s46+Pwuz7
         fVcOTRtlyIqQYza8Obec/uKwn6R38Mlxpxw+9cPbV++GGSlWYYpbnsq1WlVqp+7ShVlC
         UV5/0jwIHd5SdwbAEEW2ZP1SFjm7FrVrnS19uRE42zSia+ROjAnAl0ahheZOqk7u/rqh
         11eA==
X-Gm-Message-State: AOAM532+NxCMVcW+6qNX0+NT6QpsdQBXvUvNaJyfcOCtr9VtPzKgm6N/
        zaJJFYlxyuBp0MjF9mhPS/VYwljTtwogTV1jzp0=
X-Google-Smtp-Source: ABdhPJzhFMNGRwnx90PS1NXQEEnzaCJkg5Y4HiLA42uOg59ynYVqcN1uLlZkjTHo8cKGkBNS0eSoJeEc/EiuuO4IIdM=
X-Received: by 2002:a17:906:2646:b0:6d5:d889:c92b with SMTP id
 i6-20020a170906264600b006d5d889c92bmr25807144ejc.696.1646268065213; Wed, 02
 Mar 2022 16:41:05 -0800 (PST)
MIME-Version: 1.0
References: <CAOMZO5ALfFDQjtbQwRiZjAhQnihBNFpmKfLh2t97tJBRQOLbNQ@mail.gmail.com>
 <Yh/r5hkui6MrV4W6@lunn.ch> <CAOMZO5D1X2Vy1aCoLsa=ga94y74Az2RrbwcZgUfmx=Eyi4LcWw@mail.gmail.com>
 <YiACuNTd9lzN6Wym@lunn.ch>
In-Reply-To: <YiACuNTd9lzN6Wym@lunn.ch>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Wed, 2 Mar 2022 21:40:54 -0300
Message-ID: <CAOMZO5ChowWZgryE14DoQG5ORNnKrLQAdQwt6Qsotsacneww3Q@mail.gmail.com>
Subject: Re: smsc95xx warning after a 'reboot' command
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 2, 2022 at 8:50 PM Andrew Lunn <andrew@lunn.ch> wrote:

> If i'm reading this correctly, this is way to late, the device has
> already gone. The PHY needs to be stopped while the device is still
> connected to the USB bus.
>
> I could understand a trace like this with a hot unplug, but not with a
> reboot. I would expect things to be shut down starting from the leaves
> of the USB tree, so the smsc95xx should have a chance to perform a
> controlled shutdown before the device is removed.
>
> This code got reworked recently. smsc95xx_disconnect_phy() has been
> removed, and the phy is now disconnected in smsc95xx_unbind(). Do you
> get the same stack trace with 5.17-rc? Or is it a different stack
> trace?

Just tested 5.17-rc6 and I get no stack strace at all after a 'reboot' command:

[   21.953945] ci_hdrc ci_hdrc.1: remove, state 1
[   21.958418] usb usb2: USB disconnect, device number 1
[   21.963493] usb 2-1: USB disconnect, device number 2
[   21.964227] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   21.968469] usb 2-1.1: USB disconnect, device number 3
[   21.970808] smsc95xx 2-1.1:1.0 eth1: unregister 'smsc95xx'
usb-ci_hdrc.1-1.1, smsc95xx USB 2.0 Ethernet
[   21.975619] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   21.975625] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.002479] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   22.009630] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   22.015392] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.021939] smsc95xx 2-1.1:1.0 eth1: Failed to read reg index 0x00000114: -19
[   22.029087] smsc95xx 2-1.1:1.0 eth1: Error reading MII_ACCESS
[   22.034845] smsc95xx 2-1.1:1.0 eth1: __smsc95xx_mdio_read: MII is busy
[   22.041743] smsc95xx 2-1.1:1.0 eth1: hardware isn't capable of remote wakeup
[   22.068706] usb 2-1.4: USB disconnect, device number 4
[   22.077327] ci_hdrc ci_hdrc.1: USB bus 2 deregistered
[   22.085222] ci_hdrc ci_hdrc.0: remove, state 4
[   22.089685] usb usb1: USB disconnect, device number 1
[   22.095284] ci_hdrc ci_hdrc.0: USB bus 1 deregistered
[   22.122356] imx2-wdt 30280000.watchdog: Device shutdown: Expect reboot!
[   22.129073] reboot: Restarting system

I applied a049a30fc 27c ("net: usb: Correct PHY handling of smsc95xx")
into 5.10.102, but it did not help.

Thanks
