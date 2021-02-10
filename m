Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A11AC315EE1
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 06:22:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhBJFVr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 00:21:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231177AbhBJFVm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Feb 2021 00:21:42 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FD7C061574
        for <netdev@vger.kernel.org>; Tue,  9 Feb 2021 21:21:02 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id sa23so1759535ejb.0
        for <netdev@vger.kernel.org>; Tue, 09 Feb 2021 21:21:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=zcil9yBsyb11vgWqk9m0acnZKPPEs9nu4oVL99KFnrc=;
        b=oyZnWch7nabeLbSERXPW746OQBJzMiWNOAiCjKUrZquafgYdwHPBPOUaasrsluJmtV
         k0wwARrgkB304B5xBFSsAg8LIuJ9Viv5ZGWo8sHertvCnLjPPBzIbOAIqqJgnZhY7BUA
         O2lsITUvEbWJJhnAiz7kqmCH7KEoLnx67mn9bYNX3J4dJoggsoE7gUSbTJ/Q2VZ771+c
         WcckfEzKsm6elOdQJNGVE9T/6OcuQyAxV+8TLoOllEsTjjwrC47ZaaB3ZZVWeIjbUh9d
         PROU4npB8ACi6aG6NPMTAemFN0r+Ndd0tZXiKgnv8btgmX4DQk1883RE4dHltl+alwUO
         Vq6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=zcil9yBsyb11vgWqk9m0acnZKPPEs9nu4oVL99KFnrc=;
        b=abo9jcQp6wd9buhP0mhUYnVf7jJVxyqFrlb3Q8PTAy4wB5Qpd35Q8JjIq6wcTDFvf8
         bER3vfcWH10D/ROcRVUdLG9vE4L1ozWtyZdG9H3VM/6mGAu9EHdieiVN4DbqRjaio9T2
         4pjRUXckQg7fRgwYbAEGQK/ocX4DzPuu92/gd3X78ROE/t7WhNMfEWHbH02UbSC8G8u0
         ijRZPdxPDuVForb+OORlRnxKT8TgZkS/GhE2aRrKpH5PuUSNtXgt0uCMPR6BGtuRQTLo
         MBae0bwQaKIhAavkk1z/5YqQf7ViJMYLMh+Em0zgeQM4h/vLqB+ZhxSJCeiC5Qhagrrt
         4RYg==
X-Gm-Message-State: AOAM533LaiMEXBQ2JVrPdITfHuQezr7ZlxBthDSptjONLVo2M0zMwdcD
        DXrjFL43Md/0MAQzRWNjftWtZOI5i95hj7io01jmr7X/G/ltJTDP
X-Google-Smtp-Source: ABdhPJyCxAJMShFrQJ0Q/DjdrVGM+/q0x7p/eKec99dUaKIJHj143uPdv7TJUqxoWS7Tnard3hIsgB7jgaTTFH/MF0w=
X-Received: by 2002:a17:906:a153:: with SMTP id bu19mr1238552ejb.287.1612934460578;
 Tue, 09 Feb 2021 21:21:00 -0800 (PST)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 10 Feb 2021 10:50:49 +0530
Message-ID: <CA+G9fYsOHVObZyK0mFTLN452q43N3hkYp5Tmf7HQaB=1ZbVJxw@mail.gmail.com>
Subject: [next] [s390 ] net: mlx5: tc_tun.h:24:29: error: field 'match_level'
 has incomplete type
To:     Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>, eli@mellanox.com,
        Paul Blakey <paulb@mellanox.com>, huyn@mellanox.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While building Linux next tag 20210209 s390 (defconfig) with gcc-9
make modules failed.
  - s390 (defconfig) with gcc-8 - FAILED
  - s390 (defconfig) with gcc-9 - FAILED
  - s390 (defconfig) with gcc-10 - FAILED

make --silent --keep-going --jobs=8
O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=s390
CROSS_COMPILE=s390x-linux-gnu- 'CC=sccache s390x-linux-gnu-gcc'
'HOSTCC=sccache gcc'
In file included from drivers/net/ethernet/mellanox/mlx5/core/en_tc.h:40,
                 from drivers/net/ethernet/mellanox/mlx5/core/en_main.c:45:
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:24:29: error:
field 'match_level' has incomplete type
   24 |  enum mlx5_flow_match_level match_level;
      |                             ^~~~~~~~~~~
drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.h:27:26: warning:
'struct mlx5e_encap_entry' declared inside parameter list will not be
visible outside of this definition or declaration
   27 |  int (*calc_hlen)(struct mlx5e_encap_entry *e);
      |                          ^~~~~~~~~~~~~~~~~

Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>

build link,
https://builds.tuxbuild.com/1oF9mT3pKaPfVIptyzGbiNjKW0m/

-- 
Linaro LKFT
https://lkft.linaro.org
