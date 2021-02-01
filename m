Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26171309FCB
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 01:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhBAAzf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 Jan 2021 19:55:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbhBAAz3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 Jan 2021 19:55:29 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99259C061573;
        Sun, 31 Jan 2021 16:54:48 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bl23so21670067ejb.5;
        Sun, 31 Jan 2021 16:54:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=0Qt7K1be/pWyGz8lypO3Yl2lEzCHcC4qocBdLobCd90=;
        b=ZRQgkyU3N+LexQXjkMXM0Jxmn7UUZPpKgrDquJvlJt6SasBHcMeuyAMhzvyyJJryno
         LxF9z9xY0UJ7Zn9TRrOa5pdrxS4pGHRsVO+n/FdevGbpCbXixK99+6C28djr2XVkJQNH
         sdQ8L0YCfiee2qqIoN/OzJhynOSIRYHtSpTLntmNFw66IqvhcRngzITbbx+vGuca+HiG
         pUKAta8tC/jRNdBZ+m6naxXZQJVj0eu1jR2HwLAWFn7H2W3cYQvshNCBJvki5z5GYAm6
         vLesQTIRMA1i1LLHAkgPZhbHNVGSs5ZiIgXdsBw8RD0oywwbrGTOQDniLwZzrm49fhi2
         obYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=0Qt7K1be/pWyGz8lypO3Yl2lEzCHcC4qocBdLobCd90=;
        b=YAlcoB4Ikk6gZHbw2QEUZta7b0gzmvOmLzSDxDlML5FonumxC6eam48adrC/lF4W41
         acigx+Fa4eaJwqlQ1f7+WAql1dpcG5roUznK6PI++PIv2EYz3OJcgcD0RiDPPYel8ZDr
         UisYojg6QWXT6bTIWue4VnVHjM1pSyeK+5cGUKGvbLJo5xz+zHqYB7+IbYssziI11PR5
         S1iRAzD89t8F+V6p8WOLFA+MkLa6h241RVxIFHG39Ds9H8tt7hGnzwu9JUpkWME0aTeq
         6kxukvD67Qp5Wk68Hvvt0kDqQn5AIXzfRLDZ2ys5fhl5HTNWx3BJ6SbToM6yvuXjDCWo
         Eu4A==
X-Gm-Message-State: AOAM531HE6iCXp1i9EZjXChaRTb2S4K2o4Q9dpbMzQ5WAlViqPlO7ALl
        DdhoaiUjn+9yBeGG0X/jRb52dJytc0Mj6gT0ua4=
X-Google-Smtp-Source: ABdhPJzMOS6/1VfR3usroosWSePXe3lz9DIn6alRKa8GoK8lrW+ZN8gUcgy3gaNxUGQE6BkX7HzYa4nqQGJ2FMV8kC4=
X-Received: by 2002:a17:906:494c:: with SMTP id f12mr15444364ejt.56.1612140887144;
 Sun, 31 Jan 2021 16:54:47 -0800 (PST)
MIME-Version: 1.0
References: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
In-Reply-To: <1612098665-187767-1-git-send-email-hkelam@marvell.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Sun, 31 Jan 2021 19:54:10 -0500
Message-ID: <CAF=yD-Jd1=6Jbp6DfYOSMddhCscy56w+2wsJYJ=X8cr+cJ_wDQ@mail.gmail.com>
Subject: Re: [Patch v3 net-next 0/7] ethtool support for fec and link configuration
To:     Hariprasad Kelam <hkelam@marvell.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sunil Kovvuri Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geethasowjanya Akula <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        Subbaraya Sundeep Bhatta <sbhatta@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 31, 2021 at 8:11 AM Hariprasad Kelam <hkelam@marvell.com> wrote:
>
> This series of patches add support for forward error correction(fec) and
> physical link configuration. Patches 1&2 adds necessary mbox handlers for fec
> mode configuration request and to fetch stats. Patch 3 registers driver
> callbacks for fec mode configuration and display. Patch 4&5 adds support of mbox
> handlers for configuring link parameters like speed/duplex and autoneg etc.
> Patche 6&7 registers driver callbacks for physical link configuration.
>
> Change-log:
> v2:
>         - Fixed review comments
>         - Corrected indentation issues
>         - Return -ENOMEM incase of mbox allocation failure
>         - added validation for input fecparams bitmask values
>         - added more comments
>
> V3:
>         - Removed inline functions
>         - Make use of ethtool helpers APIs to display supported
>           advertised modes
>         - corrected indentation issues
>         - code changes such that return early in case of failure
>           to aid branch prediction

This addresses my comments to the previous patch series, thanks.

It seems that patchwork only picked up only patch 6/7 unfortunately:
https://patchwork.kernel.org/project/netdevbpf/list/?series=424969

>
> Christina Jacob (6):
>   octeontx2-af: forward error correction configuration
>   octeontx2-pf: ethtool fec mode support
>   octeontx2-af: Physical link configuration support
>   octeontx2-af: advertised link modes support on cgx
>   octeontx2-pf: ethtool physical link status
>   octeontx2-pf: ethtool physical link configuration
>
> Felix Manlunas (1):
>   octeontx2-af: Add new CGX_CMD to get PHY FEC statistics
>
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.c    | 258 ++++++++++++-
>  drivers/net/ethernet/marvell/octeontx2/af/cgx.h    |  10 +
>  .../net/ethernet/marvell/octeontx2/af/cgx_fw_if.h  |  70 +++-
>  drivers/net/ethernet/marvell/octeontx2/af/mbox.h   |  87 ++++-
>  drivers/net/ethernet/marvell/octeontx2/af/rvu.h    |   4 +
>  .../net/ethernet/marvell/octeontx2/af/rvu_cgx.c    |  80 +++++
>  .../ethernet/marvell/octeontx2/nic/otx2_common.c   |  20 ++
>  .../ethernet/marvell/octeontx2/nic/otx2_common.h   |   6 +
>  .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  | 399 ++++++++++++++++++++-
>  .../net/ethernet/marvell/octeontx2/nic/otx2_pf.c   |   3 +
>  10 files changed, 930 insertions(+), 7 deletions(-)
>
> --
> 2.7.4
