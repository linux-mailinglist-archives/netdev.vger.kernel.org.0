Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10D3C636563
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 17:08:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238738AbiKWQIZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 23 Nov 2022 11:08:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238769AbiKWQIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 11:08:24 -0500
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7830861502;
        Wed, 23 Nov 2022 08:08:22 -0800 (PST)
Received: by mail-pf1-f171.google.com with SMTP id y203so17750598pfb.4;
        Wed, 23 Nov 2022 08:08:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=L325t3YvvvAeZhfgX4h7aT45SzL274T54HnFgAiMX3w=;
        b=htQozKQfZwEfOaKMLWmkgW0Q0Vwy5ykkrjtbwvu34TBRyGgitNBGq4z5eEwX5n69mt
         wfd6f2i5z3B7PnvytJunWtn0UM0Lbo9OwBccwthhWcaWpRFlmqutEpPeTWRggywViNtJ
         6kpz/sUSZHPC2U4o7Nvi5UM3tPt0cR2mAuLVRXclCo3HcztEeW3F0VzDoWR0MQMlLHMH
         M80S6iTIjP0mnc+HpAAwNYtSPDFyYzk45v8iQ+kYy6ZYTme4mVMedO53AotPhOZizvcS
         wBBoHBTQEgaqY7V07VAgDWHezoXcgdBD7ZDKnqqbPSK0piY8ciAJ/ZOoebaBgsjuwtbk
         06lg==
X-Gm-Message-State: ANoB5pnWoFufPiMlzbEVAGVWy+s+bQeL0i6E+ir5KlijPFS/DFXKvugB
        TVt9jzyJCtiFPGE204QnM0HEtPL+DguXKhOxza8=
X-Google-Smtp-Source: AA0mqf6ZEuznSk/KaxGsXwIgwEKyqHz25lZLP+qo7PcJjdEcEzUDVZfBRopWYKsU/sgXtMq5crvBWI7alTJkKm5NkN8=
X-Received: by 2002:a63:1955:0:b0:477:50ed:6415 with SMTP id
 21-20020a631955000000b0047750ed6415mr16575050pgz.535.1669219701852; Wed, 23
 Nov 2022 08:08:21 -0800 (PST)
MIME-Version: 1.0
References: <20221122154934.13937-1-mailhol.vincent@wanadoo.fr>
 <Y33sD/atEWBTPinG@nanopsycho> <CAMZ6Rq+jG=iAHCfFED7SE3jP8EnSSCWc2LLFv+YDKAf0ABe0YA@mail.gmail.com>
 <Y34NsilOe8BICA9Q@nanopsycho>
In-Reply-To: <Y34NsilOe8BICA9Q@nanopsycho>
From:   Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Date:   Thu, 24 Nov 2022 01:08:10 +0900
Message-ID: <CAMZ6RqKdDoDHB2TiTR9wkpWQ=p_bZC2NFQLFV43Us20OS0qq_Q@mail.gmail.com>
Subject: Re: [RFC PATCH] net: devlink: devlink_nl_info_fill: populate default information
To:     Jiri Pirko <jiri@nvidia.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed. 23 Nov. 2022 at 21:10, Jiri Pirko <jiri@nvidia.com> wrote:
> Wed, Nov 23, 2022 at 12:00:44PM CET, mailhol.vincent@wanadoo.fr wrote:
> >On Wed. 23 nov. 2022 à 18:46, Jiri Pirko <jiri@nvidia.com> wrote:
> >> Tue, Nov 22, 2022 at 04:49:34PM CET, mailhol.vincent@wanadoo.fr wrote:
> >> >Some piece of information are common to the vast majority of the
> >> >devices. Examples are:
> >> >
> >> >  * the driver name.
> >> >  * the serial number of a USB device.
> >> >
> >> >Modify devlink_nl_info_fill() to retrieve those information so that
> >> >the drivers do not have to. Rationale: factorize code.
> >> >
> >> >Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
> >> >---
> >> >I am sending this as an RFC because I just started to study devlink.
> >> >
> >> >I can see a parallel with ethtool for which the core will fill
> >> >whatever it can. c.f.:
> >> >commit f20a0a0519f3 ("ethtool: doc: clarify what drivers can implement in their get_drvinfo()")
> >> >Link: https://git.kernel.org/netdev/net-next/c/f20a0a0519f3
> >> >
> >> >I think that devlink should do the same.
> >> >
> >> >Right now, I identified two fields. If this RFC receive positive
> >> >feedback, I will iron it up and try to see if there is more that can
> >> >be filled by default.
> >> >
> >> >Thank you for your comments.
> >> >---
> >> > net/core/devlink.c | 36 ++++++++++++++++++++++++++++++++++++
> >> > 1 file changed, 36 insertions(+)
> >> >
> >> >diff --git a/net/core/devlink.c b/net/core/devlink.c
> >> >index 7f789bbcbbd7..1908b360caf7 100644
> >> >--- a/net/core/devlink.c
> >> >+++ b/net/core/devlink.c
> >> >@@ -18,6 +18,7 @@
> >> > #include <linux/netdevice.h>
> >> > #include <linux/spinlock.h>
> >> > #include <linux/refcount.h>
> >> >+#include <linux/usb.h>
> >> > #include <linux/workqueue.h>
> >> > #include <linux/u64_stats_sync.h>
> >> > #include <linux/timekeeping.h>
> >> >@@ -6685,12 +6686,37 @@ int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> >> > }
> >> > EXPORT_SYMBOL_GPL(devlink_info_version_running_put_ext);
> >> >
> >> >+static int devlink_nl_driver_info_get(struct device_driver *drv,
> >> >+                                    struct devlink_info_req *req)
> >> >+{
> >> >+      if (!drv)
> >> >+              return 0;
> >> >+
> >> >+      if (drv->name[0])
> >> >+              return devlink_info_driver_name_put(req, drv->name);
> >>
> >> Make sure that this provides the same value for all existing drivers
> >> using devlink.
> >
> >There are 21 drivers so far which reports the driver name through devlink. c.f.:
> >  $ git grep "devlink_info_driver_name_put(" drivers | wc -l
> >
> >Out of those 21, there is only one: the mlxsw which seems to report
> >something different than device_driver::name. Instead it reports some
> >bus_info:
> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.c#L1462
> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/core.h#L504
> >
> >I am not sure what the bus_info is here, but it looks like a misuse of
> >the field here.
>
> When you are not sure, look into the code to find out :) I see no misue.
> What exactly do you mean by that?

I mean that device_kind, it does not sound like a field that would
hold the driver name.

Looking deeper in the code, I got the confirmation.
bus_info::device_kind is initialized here (among other):
https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/net/ethernet/mellanox/mlxsw/i2c.c#L714

and it uses ic2_client::name which indicate the type of the device
(e.g. chip name):
https://elixir.bootlin.com/linux/v6.1-rc1/source/include/linux/i2c.h#L317

So I confirm that this is a misuse. This driver does not report the
driver's name.

> >> >+
> >> >+      return 0;
> >> >+}
> >> >+
> >> >+static int devlink_nl_usb_info_get(struct usb_device *udev,
> >> >+                                 struct devlink_info_req *req)
> >> >+{
> >> >+      if (!udev)
> >> >+              return 0;
> >> >+
> >> >+      if (udev->serial[0])
> >> >+              return devlink_info_serial_number_put(req, udev->serial);
> >> >+
> >> >+      return 0;
> >> >+}
> >> >+
> >> > static int
> >> > devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> >> >                    enum devlink_command cmd, u32 portid,
> >> >                    u32 seq, int flags, struct netlink_ext_ack *extack)
> >> > {
> >> >       struct devlink_info_req req = {};
> >> >+      struct device *dev = devlink_to_dev(devlink);
> >> >       void *hdr;
> >> >       int err;
> >> >
> >> >@@ -6707,6 +6733,16 @@ devlink_nl_info_fill(struct sk_buff *msg, struct devlink *devlink,
> >> >       if (err)
> >> >               goto err_cancel_msg;
> >> >
> >> >+      err = devlink_nl_driver_info_get(dev->driver, &req);
> >> >+      if (err)
> >> >+              goto err_cancel_msg;
> >> >+
> >> >+      if (!strcmp(dev->parent->type->name, "usb_device")) {
> >>
> >> Comparing to string does not seem correct here.
> >
> >There is a is_usb_device() which does the check:
> >  https://elixir.bootlin.com/linux/v6.1-rc1/source/drivers/usb/core/usb.h#L152
> >
> >but this macro is not exposed outside of the usb core. The string
> >comparison was the only solution I found.
>
> Find a different one. String check here is wrong.
> >
> >Do you have any other ideas? If not and if this goes further than the
> >RFC stage, I will ask the USB folks if there is a better way.
> >
> >>
> >> >+              err = devlink_nl_usb_info_get(to_usb_device(dev->parent), &req);
> >>
> >> As Jakub pointed out, you have to make sure that driver does not put the
> >> same attrs again. You have to introduce this functionality with removing
> >> the fill-ups in drivers atomically, in a single patch.
> >
> >Either this, either track if the attribute is already set. I would
> >prefer to remove all drivers fill-ups but this is not feasible for the
> >serial number. c.f. my reply to Jacub in this thread:
> >  https://lore.kernel.org/netdev/CAMZ6RqJ8_=h1SS7WmBeEB=75wsvVUZrb-8ELCDtpZb0gSs=2+A@mail.gmail.com/
>
> Sure, but for the driver name it is. Let's start there.

I will do a first patch only for the driver name and think again of
the USB serial later on.


Yours sincerely,
Vincent Mailhol
