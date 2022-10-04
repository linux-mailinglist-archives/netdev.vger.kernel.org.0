Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3BD75F469B
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 17:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229791AbiJDP0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 11:26:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbiJDP0P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 11:26:15 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FE861F9CF
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 08:26:13 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id d10so13412649pfh.6
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 08:26:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:from:to:cc:subject:date;
        bh=/YHX3TbrcE414qWrKKxD/6P5SN795x16J4nCGIOO2SU=;
        b=M5E2VE95d3SkTrQu8oahPM1MwzFZe7dR+0jvWYagxyi3JAJC0ajt58Dyh9tz7l/ece
         P7UQZ+n7dVpdfLvyxRSLFMzrijFyqa2nnZRC5OUg9TxaIj1tQ/FQ8I5z2ivnEqPI6jjM
         CFAkZNt7MV0JlPx5roj/tQgk+KnpOvCkFyPpVsd6GP0clcFbkamdcZfSUkKeklgYlb0W
         gqrnMMO7AqAUHRve/sm6EJqJXiQLe5DE7dg7iINLashSA4ea2Ovqpmw3flhj19yA4ji4
         fhHkNkyIa60vNJFcZKFZtIIMe54BCdWXK3zdfyYqfFA+1g/6rytQtnQ4oPK3Y77JX+FX
         D00w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:subject:cc:to
         :from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=/YHX3TbrcE414qWrKKxD/6P5SN795x16J4nCGIOO2SU=;
        b=hgc5Q4mW7ax0MJUz1rTKnteXztasoa7c+ZP/nXojzFjar1XuDFjKRhLnEstGkpeKeK
         RohKtshcpoUjv/9E5p+XNLv0tgC41uSHGqcBvZFl+YwO8zN/aR3ACyJ4mBLqlcqLydZV
         P7B593mwocGOa4QHvTFsmPtEXzZTox5xNu6RFiT4UZqkGiLrmlhmvupHOuhRsaGWgsjZ
         r4X0GPo3pL7tNmZqZG4sxEZ3mevvZkOg/Mi0Qwp28g1a+zxQn21mVe+DDIDx0sFruPCi
         W7oDm7DE+088wMjRjmb2lnc5xWLDs41VAaVSQTMy1G5iAHQG4u36XWvLbBldFaBdMJaf
         nLKA==
X-Gm-Message-State: ACrzQf2LAPPaJqEcZwEIM6bg/naxnQJnxPPx+x5nuBU/XmC9EE51cRnm
        Zp02qCvrrfC1whzKTqJQI9sPidBvbQYAQQ==
X-Google-Smtp-Source: AMsMyM4ijJdEIOeFGEzXqXFknl1z/g5IakTLbpxm+gK02UHGG2uT0fqta1VOLo5pvXUhG4siTOU0pw==
X-Received: by 2002:a65:6cc8:0:b0:3fe:2b89:cc00 with SMTP id g8-20020a656cc8000000b003fe2b89cc00mr23859744pgw.599.1664897172607;
        Tue, 04 Oct 2022 08:26:12 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id a17-20020aa795b1000000b00561830403cfsm3584888pfk.47.2022.10.04.08.26.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Oct 2022 08:26:12 -0700 (PDT)
Date:   Tue, 4 Oct 2022 08:26:10 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 6.0 release
Message-ID: <20221004082610.56b04719@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New release of iproute2 corresponding to the 6.0 kernel release.

This release is overall smaller than usual. The most active parts
appear to be the devlink and bridge commands.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-6.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Baruch Siach (2):
      devlink: fix region-new usage message
      man: devlink-region(8): document the 'new' subcommand

Benjamin Poirier (4):
      bridge: Do not print stray prefixes in monitor mode
      ip-monitor: Do not listen for nexthops by default when specifying stats
      ip-monitor: Include stats events in default and "all" cases
      ip-monitor: Fix the selection of rtnl groups when listening for all object types

Changhyeok Bae (1):
      ipstats: Add param.h for musl

David Ahern (6):
      Update kernel headers
      Update kernel headers
      Update kernel headers
      Import ppp_defs.h uapi file from point of last kernel headers sync
      Import posix_types.h uapi file from point of last kernel headers sync
      Update kernel headers

Denis Ovsienko (1):
      man: fix a typo in devlink-dev(8)

Eli Cohen (2):
      vdpa: Add support for reading vdpa device statistics
      vdpa: Update man page to include vdpa statistics

Eric Dumazet (1):
      iplink: report tso_max_size and tso_max_segs

Hangbin Liu (2):
      iplink: bond_slave: add per port prio support
      libbpf: add xdp program name support

Ido Schimmel (1):
      man: tc-fw: Document masked handle usage

Jeffrey Ji (1):
      show rx_otherehost_dropped stat in ip link show

Jiri Pirko (1):
      devlink: add support for linecard show and type set

Khem Raj (1):
      configure: Define _GNU_SOURCE when checking for setns

Maxim Mikityanskiy (2):
      ss: Show zerocopy sendfile status of TLS sockets
      ss: Shorter display format for TLS zerocopy sendfile

Nikolay Aleksandrov (10):
      bridge: fdb: add new flush command
      bridge: fdb: add flush vlan matching
      bridge: fdb: add flush port matching
      bridge: fdb: add flush [no]permanent entry matching
      bridge: fdb: add flush [no]static entry matching
      bridge: fdb: add flush [no]dynamic entry matching
      bridge: fdb: add flush [no]added_by_user entry matching
      bridge: fdb: add flush [no]extern_learn entry matching
      bridge: fdb: add flush [no]sticky entry matching
      bridge: fdb: add flush [no]offloaded entry matching

Paolo Lungaroni (1):
      seg6: add support for SRv6 Headend Reduced Encapsulation

Peilin Ye (7):
      ss: Use assignment-suppression character in sscanf()
      ss: Remove unnecessary stack variable 'p' in user_ent_hash_build()
      ss: Do not call user_ent_hash_build() more than once
      ss: Delete unnecessary call to snprintf() in user_ent_hash_build()
      ss: Fix coding style issues in user_ent_hash_build()
      ss: Factor out fd iterating logic from user_ent_hash_build()
      ss: Introduce -T, --threads option

Petr Machata (1):
      ip: Fix rx_otherhost_dropped support

Stephen Hemminger (9):
      ipstats: add missing headers
      vdpa: fix statistics API mismatch
      uapi: update headers from 6.0-rc1
      uapi: update headers for xfrm and virtio_ring.h
      uapi: update bpf and virtio_net
      uapi: update of if_tun.h
      devlink: fix man page for linecard
      ss: fix duplicate include
      v6.0.0

Vikas Gupta (1):
      devlink: add support for running selftests

Wojciech Drewek (3):
      lib: refactor ll_proto functions
      lib: Introduce ppp protocols
      f_flower: Introduce PPPoE support

