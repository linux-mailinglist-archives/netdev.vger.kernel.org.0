Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4A9263A0C5
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 06:32:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbiK1Fcj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 00:32:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiK1Fci (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 00:32:38 -0500
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B899BEA;
        Sun, 27 Nov 2022 21:32:35 -0800 (PST)
Received: by mail-pf1-f179.google.com with SMTP id w79so9429023pfc.2;
        Sun, 27 Nov 2022 21:32:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Aa6IZglYvctadBEzqWZe9EXgU7WiR6HNZzFHtL5DNo=;
        b=n3LbE2po45L7UEA/e4z8Dn0mvYkvs0+qS7CNVLew7hNwlobQvNu60t2fH8EEsjnxnK
         Mxu4DhwaYd9+T6tHBoC7O2B5Fd25zBO3HsaXd6ssdjpW8j6QFkPf8NYeEwof6vk713W9
         V9SrwoixJzFpiOAxl9DRFErzIycIatZR5H9aQNfAVKJz2IwVjzZf+rjKDw7fVCZyGe3n
         /TUe23dZ42envD/Gvb7kQpySEMyQLOf4/SMBR5MjC4pBLChOeWb7XekNeljNUe4EUS9n
         eCEjQyq+VXTLiHS11mL7a6pz3lzRVWY0VQKD49Qk/QYIE6U9sjYIxvCB1pjwsAGt8PrW
         vjIA==
X-Gm-Message-State: ANoB5pl6fr2M/gUTETuhxrZqQigxE+WgGHCJouz9ilnk2Tm8NTIEL//N
        hNvs1yT+Rmg4NJAqiwRNqchLR7wC0ekj2ZHVyEs=
X-Google-Smtp-Source: AA0mqf4DsMKAlgvZVcNPpcG6bvgBwfljvVj8E/qqpGfmBCUsqDrL33BR5G5S4PYVxNZ8B7TexHAsaA0JeMi81NOV8sY=
X-Received: by 2002:a63:1803:0:b0:477:6e5d:4e25 with SMTP id
 y3-20020a631803000000b004776e5d4e25mr31802247pgl.70.1669613554816; Sun, 27
 Nov 2022 21:32:34 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch> <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
 <Y4OD70GD4KnoRk0k@rowland.harvard.edu> <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
In-Reply-To: <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 14:32:23 +0900
Message-ID: <CAMZ6RqKS0sUFZWQfmRU6q2ivWEUFD06uiQekDr=u94L3uij3yQ@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Andrew Lunn <andrew@lunn.ch>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 10:34, Vincent MAILHOL
<mailhol.vincent@wanadoo.fr> wrote:
> On Mon. 28 Nov. 2022 at 00:41, Alan Stern <stern@rowland.harvard.edu> wrote:
> > On Sun, Nov 27, 2022 at 02:10:32PM +0900, Vincent MAILHOL wrote:
> > > > Should devlink_free() be after usb_set_inftdata()?
> > >
> > > A look at
> > >   $ git grep -W "usb_set_intfdata(.*NULL)"
> > >
> > > shows that the two patterns (freeing before or after
> > > usb_set_intfdata()) coexist.
> > >
> > > You are raising an important question here. usb_set_intfdata() does
> > > not have documentation that freeing before it is risky. And the
> > > documentation of usb_driver::disconnect says that:
> > >   "@disconnect: Called when the interface is no longer accessible,
> > >    usually because its device has been (or is being) disconnected
> > >    or the driver module is being unloaded."
> > >   Ref: https://elixir.bootlin.com/linux/v6.1-rc6/source/include/linux/usb.h#L1130
> > >
> > > So the interface no longer being accessible makes me assume that the
> > > order does not matter. If it indeed matters, then this is a foot gun
> > > and there is some clean-up work waiting for us on many drivers.
> > >
> > > @Greg, any thoughts on whether or not the order of usb_set_intfdata()
> > > and resource freeing matters or not?
> >
> > In fact, drivers don't have to call usb_set_intfdata(NULL) at all; the
> > USB core does it for them after the ->disconnect() callback returns.
>
> Interesting. This fact is widely unknown, cf:
>   $ git grep "usb_set_intfdata(.*NULL)" | wc -l
>   215
>
> I will do some clean-up later on, at least for the CAN USB drivers.
>
> > But if a driver does make the call, it should be careful to ensure that
> > the call happens _after_ the driver is finished using the interface-data
> > pointer.  For example, after all outstanding URBs have completed, if the
> > completion handlers will need to call usb_get_intfdata().
>
> ACK. I understand that it should be called *after* the completion of
> any ongoing task.
>
> My question was more on:
>
>         devlink_free(priv_to_devlink(es58x_dev));
>         usb_set_intfdata(intf, NULL);
>
> VS.
>
>         usb_set_intfdata(intf, NULL);
>         devlink_free(priv_to_devlink(es58x_dev));
>
> From your comments, I understand that both are fine.

Do we agree that the usb-skeleton is doing it wrong?
  https://elixir.bootlin.com/linux/latest/source/drivers/usb/usb-skeleton.c#L567
usb_set_intfdata(interface, NULL) is called before deregistering the
interface and terminating the outstanding URBs!

> > Remember, the interface-data pointer is owned by the driver.  Nothing
> > else in the kernel uses it.  So the driver merely has to be careful not
> > to clear the pointer while it is still using it.
>
> Thanks for your comments!
>
>
> Yours sincerely,
> Vincent Mailhol
