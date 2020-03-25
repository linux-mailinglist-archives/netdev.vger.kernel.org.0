Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9369E1931DE
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:25:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727505AbgCYUZX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:25:23 -0400
Received: from mail-qt1-f181.google.com ([209.85.160.181]:45118 "EHLO
        mail-qt1-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgCYUZW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:25:22 -0400
Received: by mail-qt1-f181.google.com with SMTP id t17so3372929qtn.12
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8jot2/4j8wh/e8/lhIVoPNOiDmledSzIkZnnl4SH9/o=;
        b=nKzxgCTgw18a/0JipA8rFM3/D8JhEbW4cujvb9KOZLJXTDH64Tr7y7SFsRlAUxof0Z
         tL0wkN6BZ454AatEB63wQ6+IiyNitGhp5VC2nehP+ovvHcsfyEqAQizESCOld03qPcu1
         emvsoZRm9qBFXkTktVj04Wlm8fYQOTCQFg0Hyp2mML+TbEQUMdnHV2/i4zts2E7w+YDz
         3Twn3/BkKyJ3SylbLn+CLJpcTeSMsU6JVZNoDKTLqsiGvMDBBAGUtZI/GtJhgyrKoKbo
         SBaS4ef81oleBtxz6yNiCFW24tBpLD8MMQHUWEkPYpnTVBY56igCWTYMvCav42o7uxwg
         dM/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=8jot2/4j8wh/e8/lhIVoPNOiDmledSzIkZnnl4SH9/o=;
        b=kIHRJTzjvbXoyr3VC598/LntBn2qJkFNCzM1o9/qbWal7VUxPGdJ2+1/vGvW8xa+jQ
         zQsXSL5sT+v9UKnj6i76vUKar7xCjWJQa0/s6MJdL6D7BgD9zT91l7caVkRmLQJnSaC/
         Ysfwdp1mvWMBumZSzXQ0myEsxDJh+ReeP65yJ5KrsowYfl/UEGw8wkzfnnGHogsh21Vp
         Wuk6JYFWG0dhFO3W+ADElxlKH1jn3oB0r0XY+Gs8QdJ7nNCXuD+ZQepEPEl+1al7P3Lp
         EwPu8+JgFk5F091/NNtuAUaHWdJtEHBb5DQOYWuAjXmTcMweeDgVn7XjiFDFdZNKynE+
         52jA==
X-Gm-Message-State: ANhLgQ1pF4m37CyV9MbYx1lksFsNG7NILYFyT39H4DaJKDWsNvPDHBm8
        FrVFMaL8CBeGikF3IYbJpyZa0w==
X-Google-Smtp-Source: ADFU+vst9Jl+0trJrSoFeIX+IdigJGzeOqfwfCZu8tG+1E2lhAkb8XROJTd9J8ov7K0eS10CkU69pw==
X-Received: by 2002:ac8:6890:: with SMTP id m16mr4960230qtq.5.1585167918987;
        Wed, 25 Mar 2020 13:25:18 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id 65sm57430qtc.4.2020.03.25.13.25.17
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Mar 2020 13:25:18 -0700 (PDT)
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Re: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
From:   Qian Cai <cai@lca.pw>
In-Reply-To: <52874e86-a8ae-dcf0-a798-a10e8c97d09e@mellanox.com>
Date:   Wed, 25 Mar 2020 16:25:17 -0400
Cc:     Vladyslav Tarasiuk <vladyslavt@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: quoted-printable
Message-Id: <483B11FF-4004-4909-B89A-06CA48E3BBBC@lca.pw>
References: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
 <52874e86-a8ae-dcf0-a798-a10e8c97d09e@mellanox.com>
To:     Moshe Shemesh <moshe@mellanox.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 25, 2020, at 3:33 PM, Moshe Shemesh <moshe@mellanox.com> wrote:
>=20
>=20
> On 3/25/2020 6:01 AM, Qian Cai wrote:
>> Reverted the linux-next commit c6acd629ee (=E2=80=9Cnet/mlx5e: Add =
support for devlink-port in non-representors mode=E2=80=9D)
>> and its dependencies,
>>=20
>> 162add8cbae4 (=E2=80=9Cnet/mlx5e: Use devlink virtual flavour for VF =
devlink port=E2=80=9D)
>> 31e87b39ba9d (=E2=80=9Cnet/mlx5e: Fix devlink port register =
sequence=E2=80=9D)
>>=20
>> on the top of next-20200324 allowed NICs to obtain an IPv4 address =
from DHCP again.
>=20
>=20
> These patches should not interfere DHCP.
>=20
> You might have dependencies on interface name which was changed by =
this patch, please check.


Yes,

Before,
[  238.225149][ T2021] mlx5_core 0000:0b:00.1 enp11s0f1: renamed from =
eth1
[  238.511324][ T2035] mlx5_core 0000:0b:00.0 enp11s0f0: renamed from =
eth0

Now,
[  234.448420][ T2013] mlx5_core 0000:0b:00.1 enp11s0f1np1: renamed from =
eth1
[  234.664236][ T2042] mlx5_core 0000:0b:00.0 enp11s0f0np0: renamed from =
eth0

>=20
>> 0b:00.0 Ethernet controller: Mellanox Technologies MT27710 Family =
[ConnectX-4 Lx]
>> 0b:00.1 Ethernet controller: Mellanox Technologies MT27710 Family =
[ConnectX-4 Lx]
>>=20
>> [  223.280777][   T13] mlx5_core 0000:0b:00.0: firmware version: =
14.21.1000
>> [  223.287753][   T13] mlx5_core 0000:0b:00.0: 63.008 Gb/s available =
PCIe bandwidth (8.0 GT/s PCIe x8 link)
>> [  226.292153][    C0] mlx5_core 0000:0b:00.0: Port module event: =
module 0, Cable plugged
>> [  226.874100][ T2023] mlx5_core 0000:0b:00.1: Adding to iommu group =
2
>> [  227.343553][   T13] mlx5_core 0000:0b:00.1: firmware version: =
14.21.1000
>> [  227.350467][   T13] mlx5_core 0000:0b:00.1: 63.008 Gb/s available =
PCIe bandwidth (8.0 GT/s PCIe x8 link)
>> [  230.026346][    C0] mlx5_core 0000:0b:00.1: Port module event: =
module 1, Cable unplugged
>> [  230.522660][ T2023] mlx5_core 0000:0b:00.0: MLX5E: StrdRq(0) =
RqSz(1024) StrdSz(256) RxCqeCmprss(0)
>> [  231.448493][ T2023] mlx5_core 0000:0b:00.1: MLX5E: StrdRq(0) =
RqSz(1024) StrdSz(256) RxCqeCmprss(0)
>> [  232.436993][ T2007] mlx5_core 0000:0b:00.1 enp11s0f1np1: renamed =
from eth1
>> [  232.690895][ T2013] mlx5_core 0000:0b:00.0 enp11s0f0np0: renamed =
from eth0

