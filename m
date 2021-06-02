Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1122399103
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230434AbhFBRAt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Jun 2021 13:00:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229831AbhFBRAt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Jun 2021 13:00:49 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC8FC061574
        for <netdev@vger.kernel.org>; Wed,  2 Jun 2021 09:58:49 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id jt22so4888073ejb.7
        for <netdev@vger.kernel.org>; Wed, 02 Jun 2021 09:58:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zWXcMXIXe43DdCrZwVU2gm3AEkb9sumOIKnJ91MhiyE=;
        b=JiXeB/Iy1jWKNdpMloH98tmAwZD74NrLiQ5MTLgZkzDDVb8UIwCWxiWXodkOAHSuUG
         hcM8Sye/pcZKp8X3tV+iIC6JStx8pJ1FmrwQuo7nkG3ZrrezuL3hPOeAhSb8ck4Ps+xy
         Hjc+GTe6C3XS4+PbV2XGBk2wY6t3DgStD40lKH9x7kKS2T6nuDKe6L84Su5xFlOC5FLp
         BSw+ZdLog6CjXNoHzKnOSblkk37VFpGNyoLNttuv1pPUK2JBcrT8E/CVLEbOrJu6EHwW
         Q5JP8yvFO3o7T2olG/LE9lqlJNVdZQ1CQGyFpzEXis6qaU5Xw9PcWqg1d3OyhIiGFVpE
         PVsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zWXcMXIXe43DdCrZwVU2gm3AEkb9sumOIKnJ91MhiyE=;
        b=OVY1BdR7eCUa388X4awK0Pq6UVZeVc396smaSdKkL1P+Qkzu82pP8ZlatQZqAQEY/B
         7PL+4f5NYSzxlfQuVHuFn6gC+v5uKg7AtxrivO+Zl46YKmAj+jHphvQzlYvFa75XtoUR
         UKBR/9RDk/cDoigahw+E+HG5rpnOkAyBIBuI++z2WF+Wa7rjhGMfvoTb8EmwvLbInhCR
         8C9wDzYxhYU2gpuvxSd+Hlcl+acdhxbKvKVdf/oZFYPk8xAs4xklrKqQHft4GZGRAQUy
         vsaw0pNkSH9Kl3LjASGmb4a/6goZT04+2ArZzkuYU5N7EJuUPaGGBV+frzdJFYOcUWUm
         PBuQ==
X-Gm-Message-State: AOAM533F/8trkBMtTv4e8Mu2JKWPfgdqt9CzY61nxzX6VhlbzL8nsqiz
        QypbS3eWAVH61zoDLxBVwsrY8gng1G4VnoQWCGc=
X-Google-Smtp-Source: ABdhPJyzpEUyoSUxNR5hxxu6L4MBKcvAkWHM1TzbrC/z9ibGHM+lE9wTXpLUfPAKJjmb4LBOSXCts6y1RE4oAlG8+Lg=
X-Received: by 2002:a17:906:c247:: with SMTP id bl7mr36152569ejb.288.1622653128035;
 Wed, 02 Jun 2021 09:58:48 -0700 (PDT)
MIME-Version: 1.0
References: <20210531225222.16992-1-smalin@marvell.com>
In-Reply-To: <20210531225222.16992-1-smalin@marvell.com>
From:   Shai Malin <malin1024@gmail.com>
Date:   Wed, 2 Jun 2021 19:58:36 +0300
Message-ID: <CAKKgK4z7o1f-PJ7Ta_fGAhxMie_ftB2UV9Phy2KjrEh5WFx9mA@mail.gmail.com>
Subject: Re: [RFC PATCH v7 00/27] NVMeTCP Offload ULP and QEDN Device Driver
To:     Shai Malin <smalin@marvell.com>
Cc:     netdev@vger.kernel.org, linux-nvme@lists.infradead.org,
        davem@davemloft.net, kuba@kernel.org,
        Sagi Grimberg <sagi@grimberg.me>, hch@lst.de, axboe@fb.com,
        kbusch@kernel.org, Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/1/21 1:53 AM, Shai Malin wrote:
> With the goal of enabling a generic infrastructure that allows NVMe/TCP
> offload devices like NICs to seamlessly plug into the NVMe-oF stack, this
> patch series introduces the nvme-tcp-offload ULP host layer, which will
> be a new transport type called "tcp-offload" and will serve as an
> abstraction layer to work with vendor specific nvme-tcp offload drivers.

If there are no additional comments on RFC v7, I will split the RFC series
between the following non-RFC sub-series:

- Part 1 (RFC patch 1-8): NVMeTCP Offload ULP
  The nvme-tcp-offload patches will be sent to
  'linux-nvme@lists.infradead.org'.

- Part 2 (RFC patches 9-15): QED NVMeTCP Offload
  The qed infrastructure will be sent to 'netdev@vger.kernel.org'.

Once part 1 and 2 are accepted:

- Part 3 (RFC patches 16-27): QEDN NVMeTCP Offload
  The qedn patches will be sent to 'linux-nvme@lists.infradead.org'.
