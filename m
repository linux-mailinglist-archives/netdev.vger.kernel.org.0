Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB4314264
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:56:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236895AbhBHV4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:56:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235136AbhBHV4V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 16:56:21 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41CBCC061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 13:55:41 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id i71so16123946ybg.7
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 13:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIZt7uaPzOwnyShy9Yq2SGdo2gUnS1DQAuHpR8zS/iM=;
        b=dQiSB46QJubR5kk9ScAnKHVq4ykXoWnCjjLJVbvhKuwVihgAi+e13zJPqvnha7VOO4
         6vyYbKsGxkZoZnyCiAh2liZwf/+R0OayA179gw7cA5NCIV/CM7qRSA5S2JoVs3MKvUGP
         SWtvkkk/gXt8Gnjd9jVKM0jzYuGETn6XqMiviCHqgdC+2kEyKII5pRT/KcXep2C4SFUX
         pPLG7SspxBf07UkH5TK9B/whjJ1YaGmXLUarSkb4IEqSUtZhh0/YV2h3s0qJuebvuwQZ
         ijy7kI5jcczfAlueO5Mfw0fhErO6p5A+wwfdn4o4lNJbRED6k/il7T6NYXKeEMC6EAWa
         FAjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIZt7uaPzOwnyShy9Yq2SGdo2gUnS1DQAuHpR8zS/iM=;
        b=kOww1NvNyCCkVJJ9wSojnSqfbh+GvfDrmdYgeo2XAcYzzs4QTaIuti4sax5pt9TB8N
         ldflcqUQ9Q4/umuD+F46viLzHrYJlZK2VK2QzoTRE+C4PGb7ellAPhq6pV3S1YbRpyyT
         raGBIMRUs+rtcCaJ7GM2A6MrPMpYhr2Zu6wGQRqg91gSxPmkzpI/k7ZGh5K5BOsGrFBZ
         0ZAKibaghjHCnKIRcqaA+wzJaDPeorDVSx87RaGUEGz7uPRN3k3HJpnWbhLkcnJVJhkB
         9xU0qxfvzRWDBvwOHy6e00ePcBdMx1L9D56zDGN6t5+97K71hRNLjPRpa4dLxxc3QZuY
         zjjQ==
X-Gm-Message-State: AOAM53188UHFhPxKKh1/iGpuH6GpQ46RkYX7F6WMO8OxdHNyEYj7/bXw
        6Uh4QwXgC9oq04pnRDbC51aqQFi2KMe91yDsh+A=
X-Google-Smtp-Source: ABdhPJy3NJBt5vSD5wvCf+EbmuQHUV/8bgosAXHQCKwC7Gn2KqpSrOIdAB3pAPf9vgHe6G+P/R3iwEqmW9Nur5Uf/kg=
X-Received: by 2002:a5b:5c1:: with SMTP id w1mr27683898ybp.177.1612821340590;
 Mon, 08 Feb 2021 13:55:40 -0800 (PST)
MIME-Version: 1.0
References: <20210206050240.48410-1-saeed@kernel.org>
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Mon, 8 Feb 2021 23:55:28 +0200
Message-ID: <CAJ3xEMi9ZTXz8X4k8fvTQF8iPDEn7LbK-pq+7hZdsjbvnuQE-w@mail.gmail.com>
Subject: Re: [pull request][net-next V2 00/17] mlx5 updates 2021-02-04
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 7:10 AM Saeed Mahameed <saeed@kernel.org> wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>

> This series adds the support for VF tunneling.

> Vlad Buslov says:
> =================
> Implement support for VF tunneling


> Abstract
> Currently, mlx5 only supports configuration with tunnel endpoint IP address on
> uplink representor. Remove implicit and explicit assumptions of tunnel always
> being terminated on uplink and implement necessary infrastructure for
> configuring tunnels on VF representors and updating rules on such tunnels
> according to routing changes.
>
> SW TC model

maybe before SW TC model, you can explain the SW model (TC is a vehicle
to implement the SW model).


SW model for VST and "classic" v-switch tunnel setup:

For example, in VST model, each virtio/vf/sf vport has a vlan such that
the v-switch tags packets going out "south" of the vport towards the
uplink, untags
packets going "north" from the uplink into the vport (and does nothing
for east-west traffic).

In a similar manner, in "classic" v-switch tunnel setup, each
virtio/vf/sf vport is somehow
associated with VNI/s marking the tenant/s it belongs to. Same tenant
east-west traffic
on the host doesn't go through any encap/decap. The v-switch adds the
relevant tunnel
MD to packets/skbs sent "southward" by the end-point and forwards it
to the VTEP which applies
encap and sends the packets to the wire. On RX, the VTEP decaps the
tunnel info from the packet,
adds it as MD to the skb and forwards the packet up into the stack
where the vsw hooks it, matches
on the MD + inner tuple and then forwards it to the relevant endpoint.

HW offloads for VST and "classic" v-switch tunnel setup:

more or less straight forward based on the above

> From TC perspective VF tunnel configuration requires two rules in both
> directions:
>
> TX rules
>
> 1. Rule that redirects packets from UL to VF rep that has the tunnel
> endpoint IP address:

> 2. Rule that decapsulates the tunneled flow and redirects to destination VF
> representor:

> RX rules
>
> 1. Rule that encapsulates the tunneled flow and redirects packets from
> source VF rep to tunnel device:

> 2. Rule that redirects from tunnel device to UL rep:

Sorry, I am not managing to follow and catch up a SW model from TC rules..

I think we need these two to begin with:

[1] Motivation for enhanced v-switch tunnel setup:

[2] SW model for enhanced v-switch tunnel setup:

> HW offloads model

a clear SW model before HW offloads model..
