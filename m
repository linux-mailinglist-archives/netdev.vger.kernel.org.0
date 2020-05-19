Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC6F41D8EC1
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 06:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbgESEbm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 00:31:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726272AbgESEbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 00:31:41 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 311B7C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 21:31:41 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c21so10012327lfb.3
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 21:31:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Uuc3CL6qTjLE8oGRMBQTCUTHl6mtKFPqiyl7ok2kcz0=;
        b=SR6tGuX9L0i/MhY6skqsh8SpLc/ODymK+XP7Z0ZvB1n+nwf07+FkSTRSOe2lT5ZJUG
         rCp+2dfAtoWDFh2RdV4qu3jLnAuVSpC906EXvCLfUqJRmICiUHhBkKj7Cco2gFfcPQtM
         8kq6FnSxIRUQX1TEIJoM9GrrcIQBYd93vgUDM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Uuc3CL6qTjLE8oGRMBQTCUTHl6mtKFPqiyl7ok2kcz0=;
        b=ijN4DZ+dAEiUuQ7M1LfFHWtEGVB3rsXuPPqT5j0YlYfwNdQ06mfs/3TV6t4jnD5jhB
         +Roga/EmiKed1qXGjtLP0b5GGupKoQ25AWMgzMbQEyOh8x1ZLRzXitAO7OMBSL9eyIIS
         /Df1MslGndhO5w2YY45/C9pV2+j+rc+qxizg3JqODZ24AhvUK1pvrmqjdjN4uSx9HwbK
         x3wdEMgNTtosIZmGvMVyZtkZiOrqQJYPQGZoRPxnhzAq8JE6GXWtnFeOGiuKHM0teoaX
         XMZzDg50LWbocavRqe7AEDgC4w/7YiXZtaDzCi9mW+oouIThFOgfJXDYUnu0xgcRJfSe
         wv/g==
X-Gm-Message-State: AOAM530a7Aqvf6u8o5vaKv+0X6dm3CmpqArnR/klB7capcf/jsc5JMBJ
        kQfC3RDuUj3tzFz2zrZL5d8SCV4K/piLtOGPyQZtelV8rbo=
X-Google-Smtp-Source: ABdhPJx3IAkfdsTzbufRYHD414PI2kAsfEZuBRqADn3uaT1Sik9it0/o2JzXgBhsRr3pt7ykwAgDuU0wR4GiPWCcpAk=
X-Received: by 2002:a19:7e15:: with SMTP id z21mr13848915lfc.103.1589862699307;
 Mon, 18 May 2020 21:31:39 -0700 (PDT)
MIME-Version: 1.0
References: <1589790439-10487-1-git-send-email-vasundhara-v.volam@broadcom.com>
 <20200518110152.GB2193@nanopsycho>
In-Reply-To: <20200518110152.GB2193@nanopsycho>
From:   Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date:   Tue, 19 May 2020 10:01:27 +0530
Message-ID: <CAACQVJpFB9OBLFThgjeC4L0MTiQ88FGQX0pp+33rwS9_SOiX7w@mail.gmail.com>
Subject: Re: [PATCH net-next 0/4] bnxt_en: Add new "enable_hot_fw_reset"
 generic devlink parameter
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 4:31 PM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Mon, May 18, 2020 at 10:27:15AM CEST, vasundhara-v.volam@broadcom.com wrote:
> >This patchset adds support for a "enable_hot_fw_reset" generic devlink
> >parameter and use it in bnxt_en driver.
> >
> >Also, firmware spec. is updated to 1.10.1.40.
>
> Hi.
>
> We've been discussing this internally for some time.
> I don't like to use params for this purpose.
> We already have "devlink dev flash" and "devlink dev reload" commands.
> Combination of these two with appropriate attributes should provide what
> you want. The "param" you are introducing is related to either "flash"
> or "reload", so I don't think it is good to have separate param, when we
> can extend the command attributes.
>
> How does flash&reload work for mlxsw now:
>
> # devlink flash
> Now new version is pending, old FW is running
> # devlink reload
> Driver resets the device, new FW is loaded
>
> I propose to extend reload like this:
>
>  devlink dev reload DEV [ level { driver-default | fw-reset | driver-only | fw-live-patch } ]
>    driver-default - means one of following to, according to what is
>                     default for the driver
>    fw-reset - does FW reset and driver entities re-instantiation
>    driver-only - does driver entities re-instantiation only
>    fw-live-patch - does only FW live patching - no effect on kernel
>
> Could be an enum or bitfield. Does not matter. The point is to use
> reload with attribute to achieve what user wants. In your usecase, user
> would do:
>
> # devlink flash
> # devlink reload level fw-live-patch

Jiri,

I am adding this param to control the fw hot reset capability of the device.
Permanent configuration mode will toggle the NVM config space which is
very similar to enable_roce/enable_sriov param and runtime configuration
mode will toggle the driver level knob to avoid/allow fw-live-reset.

From above. I see that you are suggesting how to trigger the fw hot reset.
This is good to have, but does not serve the purpose of enabling or disabling
of the feature. Our driver is currently using "ethtool --reset" for
triggering fw-reset
or fw-live-patch.

Thanks,
Vasundhara
