Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9E722046B0
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 03:25:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731794AbgFWBZE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 21:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731690AbgFWBZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 21:25:03 -0400
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464B2C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 18:25:03 -0700 (PDT)
Received: by mail-ed1-x529.google.com with SMTP id t21so15087641edr.12
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 18:25:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZF8K9LUK/G0HC22aqhOG62+/TT1vxROQU/qxdC2+roM=;
        b=Gv9n+G8dLcNNml/Y0P9DAi5ChB6xVyITS+oarhCaAm9mITsIdSosKFWRk4sGDHJ22u
         1wRTXT3JXZ3PEd5D460Y/RPZWp7ygUSVVSCR/A0LJPgIuU/WBC+wH4roby+pQj8BrksO
         lZOufJSPx3Xn5HowbXK+Ka1tRtHawKSntaCC3lgL8tHrrf6UtxgMDX4JidnSZE/LSWiP
         qDL3UKO0QKGqEoA9z5TJwknh0MAnFicfffOLVE+s/vLf9RrdQ+OvEuLColFB/svnQeb2
         UTecGyTyNO6OH3v6N5XJWMrLo8xhRb4j3k1jO86h00z2w/t9ME41j+WgOLOrGabyginI
         QxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZF8K9LUK/G0HC22aqhOG62+/TT1vxROQU/qxdC2+roM=;
        b=LpObkLbNxl5hAaFKgowDZkGI9GWjisN+NiEEx2B+zJmaVI73GQjhD6IiLxvEOxa4st
         FAIE7dO92KL1Q0eZotpO+oLUP69hQf3w2xDYw0H83hEWjJCSFsDfuuLqzx++8vqXJoOE
         h6+8Nmrugaj4WeEKIkNWFkx9jcX112Cg8uxz9XN4wNVZTKSVSReG6pgtvjXRZrdSqbTk
         uVYJIR0KH1QMGbjemao6MhwNB2G9QpDrcswphGMh6NZEHYU6rvMYEXYsVF4wTRs5StuW
         up2VRSgAjbfBzWthggOMq2wS86cIwwo9J1v01eDtZ6eXPRWK4K6F1778RXjoxxVpBTN1
         ftwA==
X-Gm-Message-State: AOAM532NkcIpRZhoxaM+02d0Nv/W/aOhfYdb3OlE7/3UPDc19AXVBLuX
        SUEwAM+akYg+PSlmJeiVG5uPN4vqXXxQA7aSeW+BgD0fC3I=
X-Google-Smtp-Source: ABdhPJwqty5rD4zS4vsoK980V6zv2kiC3YEc2thytt4ZgruSsXOxfzVjUMvweRr22lUWK/bO1lHH1PxS+5Gd20jG92M=
X-Received: by 2002:a05:6402:1244:: with SMTP id l4mr13192421edw.71.1592875502005;
 Mon, 22 Jun 2020 18:25:02 -0700 (PDT)
MIME-Version: 1.0
References: <CAMDZJNXW-SsgYiw8j1b5Rv8PhfGt=TxZZKjCPzsQWiADjy6zew@mail.gmail.com>
 <20200620183558.GA194992@mtl-vdi-166.wap.labs.mlnx>
In-Reply-To: <20200620183558.GA194992@mtl-vdi-166.wap.labs.mlnx>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 23 Jun 2020 09:24:25 +0800
Message-ID: <CAMDZJNXgiRzLxnLg1ymTL0xSEh8wOgL4RWxTbcU=Y3vU-s=_Ng@mail.gmail.com>
Subject: Re: mlx5e uplink hairpin forwarding
To:     Eli Cohen <eli@mellanox.com>
Cc:     ozsh@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 21, 2020 at 2:36 AM Eli Cohen <eli@mellanox.com> wrote:
>
> On Sat, Jun 20, 2020 at 08:02:19PM +0800, Tonghao Zhang wrote:
> > Hi Eli
> >
> > I review your patches and try to test it.
> > $ tc filter add dev enp130s0f0  protocol ip prio 1 root flower dst_ip
> > 11.12.13.14 skip_sw action mirred egress redirect dev enp130s0f1
> > or
> > $ tc filter add dev enp130s0f0  protocol ip prio 1 parent ffff: flower
> > dst_ip 11.12.13.14 skip_sw action mirred egress redirect dev
> > enp130s0f1
> >
> > TC can't install the rules above. The error message:
> > mlx5_core: devices are both uplink, can't offload forwarding.
> >
> > So how can I install hairpin rules between uplink and uplink forwarding=
 ?
> >
> > The test environment
> > kernel 5.8.0-rc1+, the last commit id:69119673bd50b176ded34032fadd41530=
fb5af21
> > NIC MCX512A-ACA_Ax
> > FW 16.27.2008
> > enp130s0f0=E3=80=81enp130s0f1 are uplink rep.
> >
>
> Hi Tonghao,
> please note that hairpin is supported on the same uplink representor.
> You cannot hairpin from one uplink to another.
Hi Eli
Still not work

$ tc filter add dev enp130s0f0 protocol ip prio 1 root flower skip_sw
dst_ip 11.12.13.14 action mirred egress redirect dev enp130s0f0
Error: mlx5_core: devices are both uplink, can't offload forwarding.

$ tc filter add dev enp130s0f0 protocol ip prio 1 parent ffff: flower
skip_sw dst_ip 11.12.13.14 action mirred egress redirect dev
enp130s0f0
Error: mlx5_core: devices are both uplink, can't offload forwarding.

The firmware used doesn't support that feature?
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next.git/commit/=
?id=3D613f53fe09a27f928a7d05132e1a74b5136e8f04

--=20
Best regards, Tonghao
