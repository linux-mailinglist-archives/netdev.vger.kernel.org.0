Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0729C314A90
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 09:43:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbhBIInP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 03:43:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229690AbhBIInB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 03:43:01 -0500
Received: from mail-yb1-xb2d.google.com (mail-yb1-xb2d.google.com [IPv6:2607:f8b0:4864:20::b2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4B0CC06178B
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 00:42:13 -0800 (PST)
Received: by mail-yb1-xb2d.google.com with SMTP id r2so17366814ybk.11
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 00:42:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ry/aW8pM4+OFmgM9J1BvMlzktMEn61WP1dLbo7LFb/M=;
        b=lPc+gbS1oeVsa25Eet1RIHnU8hSqRQyBkNghjNzRY2wrkrgXwdaS+hEF6tnHA9cEed
         uMt+M9F4Gy9FD4cY+X33oCcsWl09BEnWDORqFPzfpZu9sDwLaXGYCLGyPVvChPsmUBKu
         QAZB71yW1FbSUIoWeYZE6rbHk7uPmQ5SxsIwBHU7sxMkcPs9UdauZgyDIgFJDf0gEZhB
         571fuai/Fxk+J7WQg+kwozaNhaPgNOt0xCG/KQNoF7SAgqru22C3PF21epb8pJcaWLYM
         HcqgmGHIPNwHdm/IZIQ0/E8nBNpbte+DRVdenkVuYm6OVuZoUHGWfFP0bQuIJE3edJnS
         SrhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ry/aW8pM4+OFmgM9J1BvMlzktMEn61WP1dLbo7LFb/M=;
        b=JZY59G0QEvKvx7CXxn27hdrBtAnx8MISFC2LsoMSHOp0XVk7rS77i0bZZlmz/T8zLo
         PGgCjFAmFYVaBipp5P4OH4+kX877H9SNjmeVq0oVMQpcz+kgwe0QRj1JVojVSOfoPxc1
         D14RaCqRcKqqZKuWOeUshPbEEVlspPsKNnUO8squYBp6WzDDy2lkWUEL++o03Av46atQ
         kEGdQlJ9XI96ZYzIj7dlZmKrW6wHcs3pN1hjpcyDVoMBnIVw92fXehLzZM05lilLFlZQ
         udZTf3fxQIyVNjF4D7uGFab4kexQPcd0zwNZrS1oJES4+XGy/YuodplMdm+JvUoQwrCC
         peNQ==
X-Gm-Message-State: AOAM530hCmqxJOx5lC3NedqdUxWwvrjrep+NhLEteQ2a1SCzIt0ZE0vG
        yae6qBi1R8TflrVUCJLJTbxrkSYJKIYFZjrlxE4CDy5WnuEDCQ==
X-Google-Smtp-Source: ABdhPJykv5KnyrJV71TbtGDB0hdEeSbJnwLfif8W+M0nz7NxvbrdgCijLYQQCDpMyuW3/CVvwuN8+gS9LXzYMN7nsdw=
X-Received: by 2002:a25:1646:: with SMTP id 67mr32358350ybw.97.1612860133207;
 Tue, 09 Feb 2021 00:42:13 -0800 (PST)
MIME-Version: 1.0
References: <20210206050240.48410-1-saeed@kernel.org>
In-Reply-To: <20210206050240.48410-1-saeed@kernel.org>
From:   Or Gerlitz <gerlitz.or@gmail.com>
Date:   Tue, 9 Feb 2021 10:42:02 +0200
Message-ID: <CAJ3xEMhPU=hr-wNN+g8Yq4rMqFQQGybQnn86mmbXrTTN6Xb8xw@mail.gmail.com>
Subject: Re: [pull request][net-next V2 00/17] mlx5 updates 2021-02-04
To:     Saeed Mahameed <saeed@kernel.org>,
        Vlad Buslov <vladbu@mellanox.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 6, 2021 at 7:10 AM Saeed Mahameed <saeed@kernel.org> wrote:

> Vlad Buslov says:

> Implement support for VF tunneling

> Currently, mlx5 only supports configuration with tunnel endpoint IP address on
> uplink representor. Remove implicit and explicit assumptions of tunnel always
> being terminated on uplink and implement necessary infrastructure for
> configuring tunnels on VF representors and updating rules on such tunnels
> according to routing changes.

> SW TC model

maybe before SW TC model, you can explain the vswitch SW model (TC is
a vehicle to implement the SW model).

SW model for VST and "classic" v-switch tunnel setup:

For example, in VST model, each virtio/vf/sf vport has a vlan
such that the v-switch tags packets going out "south" of the
vport towards the uplink, untags packets going "north" from
the uplink, matches on the vport tag and forwards them to
the vport (and does nothing for east-west traffic).

In a similar manner, in "classic" v-switch tunnel setup, each
virtio/vf/sf vport is somehow associated with VNI/s marking the
tenant/s it belongs to. Same tenant east-west traffic on the
host doesn't go through any encap/decap. The v-switch adds the
relevant tunnel MD to packets/skbs sent "southward" by the end-point
and forwards it to the VTEP which applies encap based on the MD (LWT
scheme) and sends the packets to the wire. On RX, the VTEP decaps
the tunnel info from the packet, adds it as MD to the skb and
forwards the packet up into the stack where the vsw hooks it, matches
on the MD + inner tuple and then forwards it to the relevant endpoint.

HW offloads for VST and "classic" v-switch tunnel setup:

more or less straight forward based on the above

> From TC perspective VF tunnel configuration requires two rules in both
> directions:

> TX rules
> 1. Rule that redirects packets from UL to VF rep that has the tunnel
> endpoint IP address:
> 2. Rule that decapsulates the tunneled flow and redirects to destination VF
> representor:

> RX rules
> 1. Rule that encapsulates the tunneled flow and redirects packets from
> source VF rep to tunnel device:
> 2. Rule that redirects from tunnel device to UL rep:

mmm it's kinda hard managing to follow and catch up a SW model from TC rules..

I think we need these two to begin with (in whatever order that works
better for you)

[1] Motivation for enhanced v-switch tunnel setup:

[2] SW model for enhanced v-switch tunnel setup:

> HW offloads model

a clear SW model before HW offloads model..

>  25 files changed, 3812 insertions(+), 1057 deletions(-)

for adding almost 4K LOCs
