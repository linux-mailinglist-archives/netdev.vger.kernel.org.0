Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19C20129007
	for <lists+netdev@lfdr.de>; Sun, 22 Dec 2019 22:27:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbfLVV1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Dec 2019 16:27:12 -0500
Received: from mail-yb1-f196.google.com ([209.85.219.196]:35419 "EHLO
        mail-yb1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbfLVV1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 Dec 2019 16:27:12 -0500
Received: by mail-yb1-f196.google.com with SMTP id a124so6386803ybg.2
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 13:27:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=B6iTfBwIOocSQscx9agqTNPyz85x9mLHvrN8kB0ogB4=;
        b=W1uR8/lw1mE7FvBL+WBWeU4jh1Rv8mKvnZBi9CF85pzM3TzEBVfL3EpR3gAc4QK4d+
         lb72I98JxCmaMddGte5/cVW6pQQnEli6keVZUZGR4KL13MYE+b8XOfefouZiG5dR8TXW
         jFpQXVJWoCH2NdY9/ln2s8DJ7cnSOOSZaCNKz70H4buvuhsv6n164XPlAdbVJDl7jch5
         Zh9pgjXdcE5zFJKeRmKJn2xnFbP2ZYmXhUOZrdbwuVoLJxSTbjg0uaTmwK2YnrK/3kJY
         YzrtFJTIz5o6fRQvDUZWLldgd+IYL6zz+W+TunzoSyHwOs4pkqUkVfzPQ6XKGJDk+d3r
         8KGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=B6iTfBwIOocSQscx9agqTNPyz85x9mLHvrN8kB0ogB4=;
        b=ozPCg/7g4eBIM4QfsyqkYbVet7ZQxNUwpFP+B6Jsr1YP9X3Ui84BGrL34b2j8dJIwi
         OcIb+oren7CpU8GJi+OeqaZWt1UmGkFpHo/Bnk8Rhl9AYhTkX0UbEySgCijo9OshUbbf
         1Q25X6EE6yrLFPDYp7vUQBBGLhCwgcptEALJsX/073MWHYy0HqCz62JpwZEfMjX1hzrk
         ZhGsP6BoSo7rXAIoyfAn49WDyXKONoQbCdBZiXXa2tGOHdezUZlA8hyYhczaQaWlJQ74
         9faUJXzUPh6QasNVNrE4LhlaHaoRNbaMDA8DUaLqU7uuAXhRm0YsCSGN2ifoiT4NX+WD
         2vuA==
X-Gm-Message-State: APjAAAViLjAcPDiAt8yfDr972qmSYhpLlwdxmsCKSDU4lnk5Jn5xB8ba
        eRZgCt3cQa05sfEjPRP70oTNR/yP
X-Google-Smtp-Source: APXvYqyhYCEjLW58wxKvVQWQn9A3WU+UsXfuxWIf+yA0E+uolIMx9dQ/DYwH6BZtxkuOsOVRNyC1IA==
X-Received: by 2002:a25:dcc3:: with SMTP id y186mr12254716ybe.351.1577050031021;
        Sun, 22 Dec 2019 13:27:11 -0800 (PST)
Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com. [209.85.219.169])
        by smtp.gmail.com with ESMTPSA id d13sm6922100ywj.91.2019.12.22.13.27.09
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Dec 2019 13:27:09 -0800 (PST)
Received: by mail-yb1-f169.google.com with SMTP id v15so6365057ybp.13
        for <netdev@vger.kernel.org>; Sun, 22 Dec 2019 13:27:09 -0800 (PST)
X-Received: by 2002:a5b:b4b:: with SMTP id b11mr2770184ybr.337.1577050029134;
 Sun, 22 Dec 2019 13:27:09 -0800 (PST)
MIME-Version: 1.0
References: <20191219205410.5961-1-cforno12@linux.vnet.ibm.com> <20191219205410.5961-3-cforno12@linux.vnet.ibm.com>
In-Reply-To: <20191219205410.5961-3-cforno12@linux.vnet.ibm.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 22 Dec 2019 16:26:32 -0500
X-Gmail-Original-Message-ID: <CA+FuTSfbZVBDGrXXnRoJAbdZc=tpV9AZmY7TfGr0G_L9RnRm6w@mail.gmail.com>
Message-ID: <CA+FuTSfbZVBDGrXXnRoJAbdZc=tpV9AZmY7TfGr0G_L9RnRm6w@mail.gmail.com>
Subject: Re: [PATCH, net-next, v3, 2/2] net: Enable virtual network devices to
 use ethtool's set/get link settings functions
To:     Cris Forno <cforno12@linux.vnet.ibm.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>, haiyangz@microsoft.com,
        sthemmin@microsoft.com, sashal@kernel.org, tlfalcon@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 3:54 PM Cris Forno <cforno12@linux.vnet.ibm.com> wrote:
>
> With get/set link settings functions in core/ethtool.c, ibmveth,
> netvsc, and virtio now use the core's helper function.
>
> Signed-off-by: Cris Forno <cforno12@linux.vnet.ibm.com>
> ---
>  drivers/net/ethernet/ibm/ibmveth.c | 60 +++++++++++++++++++++-----------------
>  drivers/net/ethernet/ibm/ibmveth.h |  3 ++

There appears to be more going on here than simply replacing the local
version of functions with equivalent shared helpers.

Please briefly document in the commit message anything that is not a
just a noop.

> diff --git a/drivers/net/virtio_net.c b/drivers/net/virtio_net.c
> index 5a635f0..5cbcb16 100644
> --- a/drivers/net/virtio_net.c
> +++ b/drivers/net/virtio_net.c
> @@ -2166,48 +2166,15 @@ static void virtnet_get_channels(struct net_device *dev,
>         channels->other_count = 0;
>  }
>
> -/* Check if the user is trying to change anything besides speed/duplex */
> -static bool
> -virtnet_validate_ethtool_cmd(const struct ethtool_link_ksettings *cmd)
> -{
> -       struct ethtool_link_ksettings diff1 = *cmd;
> -       struct ethtool_link_ksettings diff2 = {};
> -
> -       /* cmd is always set so we need to clear it, validate the port type
> -        * and also without autonegotiation we can ignore advertising
> -        */
> -       diff1.base.speed = 0;
> -       diff2.base.port = PORT_OTHER;
> -       ethtool_link_ksettings_zero_link_mode(&diff1, advertising);
> -       diff1.base.duplex = 0;
> -       diff1.base.cmd = 0;
> -       diff1.base.link_mode_masks_nwords = 0;
> -
> -       return !memcmp(&diff1.base, &diff2.base, sizeof(diff1.base)) &&
> -               bitmap_empty(diff1.link_modes.supported,
> -                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> -               bitmap_empty(diff1.link_modes.advertising,
> -                            __ETHTOOL_LINK_MODE_MASK_NBITS) &&
> -               bitmap_empty(diff1.link_modes.lp_advertising,
> -                            __ETHTOOL_LINK_MODE_MASK_NBITS);
>  }

Stray parenthesis: build failure.
