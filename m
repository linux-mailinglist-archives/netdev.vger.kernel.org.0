Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28C82191FFF
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 05:01:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbgCYEBW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 00:01:22 -0400
Received: from mail-qk1-f178.google.com ([209.85.222.178]:41854 "EHLO
        mail-qk1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727174AbgCYEBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 00:01:21 -0400
Received: by mail-qk1-f178.google.com with SMTP id q188so1199976qke.8
        for <netdev@vger.kernel.org>; Tue, 24 Mar 2020 21:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=from:content-transfer-encoding:mime-version:subject:message-id:date
         :cc:to;
        bh=DskibvAiGWQU1ARR7W7zFMaIjJJriimC2l9FtZs64I0=;
        b=pZvmY7ZkAuo+/4NyiQcHwafNLNtwnKmB3PrdQGW6qKrTjt/CMJ+uEYqcrz9xT2Cw4x
         j13vxwwYZSriP3IBLLplKbBjj/wTLCohU5oINSohFlBoPZ+U+FRZgxX1liqYM2GAfs7Y
         w3QXDzUn9kf3fOGGmdgbk6W10mH2wEmrsdmC7YpXDTDDpqlIZc6Fz3RwpzCnvmk2L7aA
         Y+4/KG+JkjZzYZ3N9BFkxA0xztIgklf5Yvx8KIIaBFrUqwN7MEc4tsSDZ8/D84EtBhCQ
         8DFe13NsU8zwxP27EwxdFzuhpKLSFPg2TDEpKL82wn9P1pOepYnUnkyNFSh3EsUmaf/M
         dUyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:content-transfer-encoding:mime-version
         :subject:message-id:date:cc:to;
        bh=DskibvAiGWQU1ARR7W7zFMaIjJJriimC2l9FtZs64I0=;
        b=MkRlFHVHe60c0CIhzTRTYLeVcK77Cx6+9t9nuS36kX744Uj+3FDpXDX0Kgjr2T4kKe
         R06xl4R1NTzQ3Lej/gGa5xKpxbqFatYq+Q0e7/9KWzym4NFy1iOQkdJmTjNJCcOgpNj0
         ZoFBWWcltsF7pyjfyX1vGgWPb9FtosQhng2JgJXsg0HH7ZNDzqfpDqbAR00B5U619kX9
         x4vvSqhsgEUPD+PlV1uvzoiCkadZUPm3fJdhYPoDlkHMC48fJCgkPFcK6W3wA8/6ob6C
         iYBD0GWkfZSpjPudqgpsDaVmVCzaJ+gltpLtrCRUsGtWQQO/tkV+IIuyMONUeV7Seoej
         Q1Pg==
X-Gm-Message-State: ANhLgQ3snfHv9Nd8+QySzC3nujfEU+x09k4j56nWSeXMqioFxWr7VTGb
        ifA/cdXIBrSBVTJdIHgG6sKoRg==
X-Google-Smtp-Source: ADFU+vsdiGhtpKoOEJ+eixikB8yrQocIP7tDnbFeUUKU+nUsAgxyDuV4OYOhCiPsPbyS4lLGKFs/Pw==
X-Received: by 2002:a37:2f43:: with SMTP id v64mr1115949qkh.480.1585108879825;
        Tue, 24 Mar 2020 21:01:19 -0700 (PDT)
Received: from [192.168.1.153] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id w28sm16608346qtc.27.2020.03.24.21.01.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 24 Mar 2020 21:01:18 -0700 (PDT)
From:   Qian Cai <cai@lca.pw>
Content-Type: text/plain;
        charset=utf-8
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: No networking due to "net/mlx5e: Add support for devlink-port in
 non-representors mode"
Message-Id: <0DF043A6-F507-4CB4-9764-9BD472ABCF01@lca.pw>
Date:   Wed, 25 Mar 2020 00:01:17 -0400
Cc:     Moshe Shemesh <moshe@mellanox.com>, Jiri Pirko <jiri@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Parav Pandit <parav@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
To:     Vladyslav Tarasiuk <vladyslavt@mellanox.com>
X-Mailer: Apple Mail (2.3608.60.0.2.5)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Reverted the linux-next commit c6acd629ee (=E2=80=9Cnet/mlx5e: Add =
support for devlink-port in non-representors mode=E2=80=9D)
and its dependencies,

162add8cbae4 (=E2=80=9Cnet/mlx5e: Use devlink virtual flavour for VF =
devlink port=E2=80=9D)
31e87b39ba9d (=E2=80=9Cnet/mlx5e: Fix devlink port register sequence=E2=80=
=9D)

on the top of next-20200324 allowed NICs to obtain an IPv4 address from =
DHCP again.

0b:00.0 Ethernet controller: Mellanox Technologies MT27710 Family =
[ConnectX-4 Lx]
0b:00.1 Ethernet controller: Mellanox Technologies MT27710 Family =
[ConnectX-4 Lx]

[  223.280777][   T13] mlx5_core 0000:0b:00.0: firmware version: =
14.21.1000
[  223.287753][   T13] mlx5_core 0000:0b:00.0: 63.008 Gb/s available =
PCIe bandwidth (8.0 GT/s PCIe x8 link)
[  226.292153][    C0] mlx5_core 0000:0b:00.0: Port module event: module =
0, Cable plugged
[  226.874100][ T2023] mlx5_core 0000:0b:00.1: Adding to iommu group 2
[  227.343553][   T13] mlx5_core 0000:0b:00.1: firmware version: =
14.21.1000
[  227.350467][   T13] mlx5_core 0000:0b:00.1: 63.008 Gb/s available =
PCIe bandwidth (8.0 GT/s PCIe x8 link)
[  230.026346][    C0] mlx5_core 0000:0b:00.1: Port module event: module =
1, Cable unplugged
[  230.522660][ T2023] mlx5_core 0000:0b:00.0: MLX5E: StrdRq(0) =
RqSz(1024) StrdSz(256) RxCqeCmprss(0)
[  231.448493][ T2023] mlx5_core 0000:0b:00.1: MLX5E: StrdRq(0) =
RqSz(1024) StrdSz(256) RxCqeCmprss(0)
[  232.436993][ T2007] mlx5_core 0000:0b:00.1 enp11s0f1np1: renamed from =
eth1
[  232.690895][ T2013] mlx5_core 0000:0b:00.0 enp11s0f0np0: renamed from =
eth0=
