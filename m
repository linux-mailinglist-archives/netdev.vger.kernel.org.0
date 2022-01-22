Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1453E496A70
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 07:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233499AbiAVGpx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jan 2022 01:45:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232277AbiAVGpw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jan 2022 01:45:52 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21C4DC06173B;
        Fri, 21 Jan 2022 22:45:52 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id n10so30898086edv.2;
        Fri, 21 Jan 2022 22:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QwuaQPQKdwpntLOw3U/dmEKgtZuaEKWLD4sSokt9D4M=;
        b=Q6E3I7OGISdYO6P+7aODtKtC48H7rcdxw/7YJnsADwNgrk0TQvDVxyDnec9rXF+2t8
         wwjo2ZRb456KLnEIGe+IbK8+V/UfrgTnj6DfZHYuyqpI7GlGP/5mn8tScuNjeOs84ytR
         qc5dC5HkB4GWceh+jE0tgicIUJ8oFKQD2eg0xc/fZEIFoLstczsbLFkRDRFxULBoMoL4
         E6WlSZOF3tsio/ItvTROVry0oPUuejT3h2pB81p4kVl8rvuObAtC8kkfJdz8Wq0wtDX5
         J0JafO+HcXozBDOm1vseOnmgJ+vDXdVEBI8W5C3PJzcF25I4jz3DCe2aXQwVQKK8kWbR
         JNoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QwuaQPQKdwpntLOw3U/dmEKgtZuaEKWLD4sSokt9D4M=;
        b=o78kqE3Q8v4zAE+maSUOfCA5mlG/fdWKxBf3CYGkzU4gwX0K8Fg3KXEjZxRxTL1K3+
         C7GVR4SYZF9adsCX3yOpmZLghU/Ipntvta3sjTZKQP8dWmcgqez7AM64ol9keGwN/3TO
         puTjRE1yQBXSuoqJ3NXEG1HGilexKEL+ltJvmk5v3Fzz4K0UmXQfTGc+pIi9TuHwth0n
         OHh6NkruFQSySzP8es1TLopgxwuufYhg7YTxFJGbL0tRbtOnEbrn4ej87BgCFc9yjWO6
         Mg+jlrqK/AMwicQA4lwoiN7WD8KfYhoo1RQTHBFQtwYVHod1GXNXo/OGESTfGXjVafWP
         augA==
X-Gm-Message-State: AOAM531V2SMXh1EOYC7QsYWow2BNreNkICkWb93DDnIyHvhMVbePbd7T
        GlrITRej+Jvlt1med0/SjqfTErTBuhBHNu4vNWo=
X-Google-Smtp-Source: ABdhPJx/n61gyq121bC6LdWTNMtp4/dzy7Ks9PKYshu71QF8P21ULrFYsp9U/8/W5ySUS9hTuhkQ2CSWUP5MeYUrBzg=
X-Received: by 2002:a05:6402:1604:: with SMTP id f4mr7172406edv.352.1642833950508;
 Fri, 21 Jan 2022 22:45:50 -0800 (PST)
MIME-Version: 1.0
References: <20220120130605.55741-1-dzm91@hust.edu.cn> <b5cb1132-2f6b-e2da-78c7-1828b3617bc3@gmail.com>
 <CAD-N9QWvfoo_HtQ+KT-7JNFumQMaq8YqMkHGR2t7pDKsDW0hkQ@mail.gmail.com>
 <CAD-N9QUfiTNqs7uOH3C99oMNdqFXh+MKLQ94BkQou_T7-yU_mg@mail.gmail.com>
 <CAD-N9QUZ95zqboe=58gybue6ssSO-M-raijd3XnGXkXnp3wiqQ@mail.gmail.com> <8d4b0822-4e94-d124-e191-bec3effaf97c@gmail.com>
In-Reply-To: <8d4b0822-4e94-d124-e191-bec3effaf97c@gmail.com>
From:   Dongliang Mu <mudongliangabcd@gmail.com>
Date:   Sat, 22 Jan 2022 14:45:24 +0800
Message-ID: <CAD-N9QUATFcaOO2reg=Y0jum83UJGOzMhcX3ukCY+cY-XCJaPA@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: remove a dangling pointer in peak_usb_create_dev
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     Dongliang Mu <dzm91@hust.edu.cn>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephane Grosjean <s.grosjean@peak-system.com>,
        =?UTF-8?Q?Stefan_M=C3=A4tje?= <stefan.maetje@esd.eu>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        linux-can@vger.kernel.org,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 22, 2022 at 3:36 AM Pavel Skripkin <paskripkin@gmail.com> wrote:
>
> Hi Dongliang,
>
> On 1/21/22 08:58, Dongliang Mu wrote:
> [...]>> BTW, as you mentioned, dev->next_siblings is used in struct
> >> peak_usb_adapter::dev_free() (i.e., pcan_usb_fd_free or
> >> pcan_usb_pro_free), how about the following path?
> >>
> >> peak_usb_probe
> >> -> peak_usb_create_dev (goto adap_dev_free;)
> >>    -> dev->adapter->dev_free()
> >>       -> pcan_usb_fd_free or pcan_usb_pro_free (This function uses
> >> next_siblings as condition elements)
> >>
> >> static void pcan_usb_fd_free(struct peak_usb_device *dev)
> >> {
> >>         /* last device: can free shared objects now */
> >>         if (!dev->prev_siblings && !dev->next_siblings) {
> >>                 struct pcan_usb_fd_device *pdev =
> >>                         container_of(dev, struct pcan_usb_fd_device, dev);
> >>
> >>                 /* free commands buffer */
> >>                 kfree(pdev->cmd_buffer_addr);
> >>
> >>                 /* free usb interface object */
> >>                 kfree(pdev->usb_if);
> >>         }
> >> }
> >>
> >> If next_siblings is not NULL, will it lead to the missing free of
> >> cmd_buffer_addr and usb_if?
> >
> > The answer is No. Forget my silly thought.
> >
>
> Yeah, it seems like (at least based on code), that this dangling pointer
> is not dangerous, since nothing accesses it. And next_siblings
> _guaranteed_ to be NULL, since dev->next_siblings is set NULL in
> disconnect()

Yes, you're right. As a security researcher, I am sensitive to such
dangling pointers.

As its nullifying site is across functions, I suggest developers
remove this dangling pointer in case that any newly added code in this
function or before the nullifying location would touch next_siblings.

If Pavel and others think it's fine, then it's time to close this patch.

>
>
>
>
> With regards,
> Pavel Skripkin
