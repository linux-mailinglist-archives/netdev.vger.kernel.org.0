Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C44F63AAEB
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 15:29:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbiK1O3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 09:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232502AbiK1O30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 09:29:26 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C393A1F63A;
        Mon, 28 Nov 2022 06:29:24 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id t17so9635280pjo.3;
        Mon, 28 Nov 2022 06:29:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shIIJU9mUgqVvo7u+uZBJemwke0hUUcMwXAy+fLCBZg=;
        b=clea3xd9sSvB/Y917+W1DUpsu9JjgVpy74IadlgPmJ0L7feaeCpnaAumZyWPQUCDRi
         vZ+o962LTHEkI1v65HsiVehDuYRpJDwsMOMASMxKAnRtHpWTnOESc76JbMYSlnMuk6O1
         zr3evS7eVU3s8pBkWorauXy2/qIiIupIaVbAXkKpS7kCH2E/s0c1nkZr/TkWMrnJpoQK
         nKNhAkkvT94Jqgalagt63BMEeBjed4M0IammBsCOREMAEMkSe5uPv5MPUo1FJhGnperN
         GKY6KBw/+/uDjAQYQ3cSl1CAPa+6o/L/gzHEstZOW4qjY5pPE6LZLnL/99XU1aSeK/NA
         ZlGg==
X-Gm-Message-State: ANoB5plN00SkYar7LGIWYgyybhhzTzAAxq2Nxc+yczHwRKPKsvvAV5H/
        49JLZH1BHuC50Tl6xXrfzfrmIyThMfURVsndoYY=
X-Google-Smtp-Source: AA0mqf62r3HiorKL8UciX0wkuqNuN1kQtduso5//lD7W9O9LDyvNYuzbBuZDf4H4qWMJ/+nYMt1mvnM06PCZFcZjotU=
X-Received: by 2002:a17:902:b608:b0:189:7a8b:537d with SMTP id
 b8-20020a170902b60800b001897a8b537dmr10252626pls.95.1669645763894; Mon, 28
 Nov 2022 06:29:23 -0800 (PST)
MIME-Version: 1.0
References: <20221104073659.414147-1-mailhol.vincent@wanadoo.fr>
 <20221126162211.93322-1-mailhol.vincent@wanadoo.fr> <20221126162211.93322-3-mailhol.vincent@wanadoo.fr>
 <Y4JEGYMtIWX9clxo@lunn.ch> <CAMZ6RqK6AQVsRufw5Jr5aKpPQcy+05jq3TjrKqbaqk7NVgK+_Q@mail.gmail.com>
 <Y4OD70GD4KnoRk0k@rowland.harvard.edu> <CAMZ6Rq+Gi+rcLqSj2-kug7c1G_nNuj6peh5nH1DNoo8B3aSxzw@mail.gmail.com>
 <Y4S6wnM33Vs56vr5@lunn.ch>
In-Reply-To: <Y4S6wnM33Vs56vr5@lunn.ch>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Mon, 28 Nov 2022 23:29:12 +0900
Message-ID: <CAMZ6RqLnfg=UG_Pisa9M0zYkWEvScZmGbytWmAQPVXLeacRffw@mail.gmail.com>
Subject: Re: [PATCH v4 2/6] can: etas_es58x: add devlink support
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Alan Stern <stern@rowland.harvard.edu>, linux-can@vger.kernel.org,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Saeed Mahameed <saeed@kernel.org>,
        Jiri Pirko <jiri@nvidia.com>,
        Lukas Magel <lukas.magel@posteo.net>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon. 28 Nov. 2022 at 22:45, Andrew Lunn <andrew@lunn.ch> wrote:
> > > But if a driver does make the call, it should be careful to ensure that
> > > the call happens _after_ the driver is finished using the interface-data
> > > pointer.  For example, after all outstanding URBs have completed, if the
> > > completion handlers will need to call usb_get_intfdata().
> >
> > ACK. I understand that it should be called *after* the completion of
> > any ongoing task.
>
> What sometimes gets people is /sys, /proc. etc. A process can have
> such a file open when the device is unplugged. If the read needs to
> make use of your private data structure, you need to guarantee it
> still exists.  Ideally the core needs to wait and not call the
> disconnect until all such files are closed. Probably the USB core
> does, it is such an obvious issue, but i have no knowledge of USB.

For USB drivers, the parallel of what you are describing are the URBs
(USB request Buffers). The URB are sent asynchronously to the device.
Each URB has a completion handler:
  https://elixir.bootlin.com/linux/v6.0/source/include/linux/usb.h#L1443
It is important to wait for all outstanding URB to complete before
releasing your resources. But once you are able to guarantee that any
ongoing actions were completed, the order in which you kfree() or
usb_set_intfdata() to NULL matters less.

Of course, the USB drivers could also have some /sys/ or /proc/ files
opened, but this is not the case of the etas_es58x. By the way, the
handling of outstanding URBs is done by es58x_free_urbs():
  https://elixir.bootlin.com/linux/v6.0/source/drivers/net/can/usb/etas_es58x/es58x_core.c#L1745
which is called just before the devlink_free() and the usb_set_intfdata().
