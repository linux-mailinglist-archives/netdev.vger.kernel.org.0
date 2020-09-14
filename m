Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE68A2688D5
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 11:55:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbgINJzK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 05:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgINJzJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 05:55:09 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 211E9C061788
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:55:08 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id r24so18116451ljm.3
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 02:55:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OLbK0D4QGcViPP4+fN4RDTHX6B/bM2Mu6LGn5qvcRcU=;
        b=dFYAdsIC4Zsz2A30EabNTdmDmZ0MQFme03K1MycqGkC8UDobD4zXjIhTFQTopq2GXM
         lu5Ywa+lMnB9EXT0YOeJky3UM8Tx6vZZsw0q+mpB1qx2+DUSlnF63s2PRFAIqLJds5qU
         64++J9P1bEJhSAAc+7nAEghmjJ1AgQDRMighc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OLbK0D4QGcViPP4+fN4RDTHX6B/bM2Mu6LGn5qvcRcU=;
        b=tLNICxih3xxj1hJfOtmcrCp06ilAAl4apS7YbauEUYrZ+ZBXNP5X5XZ+QQtyUxadDI
         vkudkLzFMn9geTdnFob0gqybl7XLBsoV7kTYqgRSEVHApuB3zr+CwdRlsYKAI7LxYu4N
         G1W1wAVqeRlfnOtS6KGUAfCUgVTTsNLTLOST3CyQetq+VsrmJik+peTdF6avj7FF8jhE
         tFom4CkImJ/u9jHjsnwAxbp+wABBFcLexJz/gD022VLclmQhLf2GTH3aWh+ziOehi10J
         knOcMy25di+R6EqNhfqu5R/TfvNPrqTrhOI1ja/STVMy2dkDcjK1V5fLncIZqQ8cQnXB
         5njg==
X-Gm-Message-State: AOAM532z9haLGPAWYUjTzHd/61fyH/I5rKCLx6Ilt5BXIzH22U4DtVOG
        bHWibgmNJzbOIFmqhndQmrGPf9US6lIpa+OyxrP6Mg==
X-Google-Smtp-Source: ABdhPJxijVWu6QGRzm95Tj+coX94ot2Ku9MxwL0bMEWXkL7YH76uFcZ7ZkkG1w3K4UjtI3A8T7ShC4vROqSAWsAYOYI=
X-Received: by 2002:a2e:874e:: with SMTP id q14mr4415207ljj.320.1600077306404;
 Mon, 14 Sep 2020 02:55:06 -0700 (PDT)
MIME-Version: 1.0
References: <1600063682-17313-1-git-send-email-moshe@mellanox.com>
 <1600063682-17313-2-git-send-email-moshe@mellanox.com> <CAACQVJochmfmUgKSvSTe4McFvG6=ffBbkfXsrOJjiCDwQVvaRw@mail.gmail.com>
 <20200914093234.GB2236@nanopsycho.orion>
In-Reply-To: <20200914093234.GB2236@nanopsycho.orion>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Mon, 14 Sep 2020 15:24:55 +0530
Message-ID: <CAACQVJqVV_YLfV002wxU2s1WJUa3_AvqwMMVr8KLAtTa0d9iOw@mail.gmail.com>
Subject: Re: [PATCH net-next RFC v4 01/15] devlink: Add reload action option
 to devlink reload command
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Michael Chan <michael.chan@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 14, 2020 at 3:02 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, Sep 14, 2020 at 09:08:58AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >On Mon, Sep 14, 2020 at 11:39 AM Moshe Shemesh <moshe@mellanox.com> wrote:
>
> [...]
>
>
> >> @@ -1126,15 +1126,24 @@ mlxsw_devlink_core_bus_device_reload_down(struct devlink *devlink,
> >>  }
> >>
> >>  static int
> >> -mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink,
> >> -                                       struct netlink_ext_ack *extack)
> >> +mlxsw_devlink_core_bus_device_reload_up(struct devlink *devlink, enum devlink_reload_action action,
> >> +                                       struct netlink_ext_ack *extack,
> >> +                                       unsigned long *actions_performed)
> >Sorry for repeating again, for fw_activate action on our device, all
> >the driver entities undergo reset asynchronously once user initiates
> >"devlink dev reload action fw_activate" and reload_up does not have
> >much to do except reporting actions that will be/being performed.
> >
> >Once reset is complete, the health reporter will be notified using
>
> Hmm, how is the fw reset related to health reporter recovery? Recovery
> happens after some error event. I don't believe it is wise to mix it.
Our device has a fw_reset health reporter, which is updated on reset
events and firmware activation is one among them. All non-fatal
firmware reset events are reported on fw_reset health reporter.

>
> Instead, why don't you block in reload_up() until the reset is complete?

Though user initiate "devlink dev reload" event on a single interface,
all driver entities undergo reset and all entities recover
independently. I don't think we can block the reload_up() on the
interface(that user initiated the command), until whole reset is
complete.
>
>
> >devlink_health_reporter_recovery_done(). Returning from reload_up does
> >not guarantee successful activation of firmware. Status of reset will
> >be notified to the health reporter via
> >devlink_health_reporter_state_update().
> >
> >I am just repeating this, so I want to know if I am on the same page.
> >
> >Thanks.
>
> [...]
