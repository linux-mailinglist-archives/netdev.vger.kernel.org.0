Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A18536CFCA
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 01:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239576AbhD1AAf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Apr 2021 20:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237104AbhD1AAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Apr 2021 20:00:34 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8953C061574
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 16:59:50 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id q2so10537435pfk.9
        for <netdev@vger.kernel.org>; Tue, 27 Apr 2021 16:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=3bWO8kKzQdgRTfohoIdmZPbbFKbiuMnDAYSLjvXeuA8=;
        b=Kmp2h97AJ0+Zm+e1Cus7BGJOIBvEy51/wc6MSZLYa8hN5PrDOIqff2ELvMlmjOZ0RS
         WhoYDRbNM2ZKTnZN/KMjdooLMl9/bEwGTCT/c0NY2BT4BxkvNb3yVphnqW2JZmwpizqY
         Q1M9P2nCHzW93aB+Kp+Ob5dCXSzI850Jc43iBXwJzLfozmBovHPgMQHafB8JsAgw9rgc
         RVZW6j94XTD0Hy3MMyj7NljXcmrPJw7tLixRAuFo73/H/Y+4p/ISKoxANSMCDgamK6d4
         Z9VKalt+RuoINnQQu018ZfFgIzOHCW2nrN/bW9ZK9QgClqrtBStm7GqqGgCwcoZYO6AN
         sDXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=3bWO8kKzQdgRTfohoIdmZPbbFKbiuMnDAYSLjvXeuA8=;
        b=OiMgFnX7/7eEias+K5tAGSV6P6daBRgh/JZSP4gaM1ZK2WEeftS8aEARAsH1VIAg88
         FMWPOsX8+LdTJpskrn159g2GcO2RVyIhdqCKDuA9kxEbrGoNIzGu0BGxBWaxA4pNSjZS
         NTRPxM9JSWrzSNGILIdoIx0KZcpLk3jrQh4qKiTE5eynAti2n644of3QR/C3JX5hK3kb
         U2BaRG8A1pgFeWt7sYWbJKU675NSzuGE+mN2jlYHdDGLrb45UiQKcw3WN8CtiswwPcH6
         eVDHZo9tTNtewQfIBWQVCbmYuJX0LktqgJMHmMD+deCl5yFA0uNv2BYig5FrcQ8LfkjZ
         i4mA==
X-Gm-Message-State: AOAM531hLmsivDiXpQ9T6YvB/eN9jGsvrZ22dvmeT+XovJTIt78z9nfm
        Lyr/HISCjAGKTgN/tiNDaX6IVvFqZ3lMrw==
X-Google-Smtp-Source: ABdhPJxP4GBL2HRKhpqkrVJUTGm8NZvqTd9vXsyfLxoKa0HkM9ofaND/2VRSuKVZuwOR2tPxHZcifA==
X-Received: by 2002:a05:6a00:1a54:b029:278:e0f7:919d with SMTP id h20-20020a056a001a54b0290278e0f7919dmr9155348pfv.52.1619567989825;
        Tue, 27 Apr 2021 16:59:49 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id u12sm3272103pfh.122.2021.04.27.16.59.49
        for <netdev@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 16:59:49 -0700 (PDT)
Date:   Tue, 27 Apr 2021 16:59:45 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.12.0 release
Message-ID: <20210427165946.0bbd8fc0@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is updated version of iproute2 to go with the 5.12 kernel.
Relatively small release, only a few minor enhancements in this cycle.

Note: iproute2 is now maintained on the "main" branch.
There are parallel copies (both updated) on kernel.org and github.

As always, it is recommended to always use the latest iproute2.
The version iproute2 does not have to match the running kernel.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.

Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.12.0.tar=
.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Thanks for all the contributions.

Report problems (or enhancements) to the netdev@vger.kernel.org mailing lis=
t.

Amit Cohen (1):
      ip route: Print "rt_offload_failed" indication

Andrea Claudi (9):
      devlink: always check strslashrsplit() return value
      q_cake: remove useless check on argv
      nexthop: fix memory leak in add_nh_group_attr()
      rdma: stat: initialize ret in stat_qp_show_parse_cb()
      rdma: stat: fix return code
      ip: netns: fix missing netns close on some error paths
      tc: e_bpf: fix memory leak in parse_bpf()
      lib: bpf_legacy: treat 0 as a valid file descriptor
      lib: bpf_legacy: fix missing socket close when connect() fails

David Ahern (3):
      Update kernel headers
      Update kernel headers
      Update kernel headers

Ido Schimmel (2):
      nexthop: Fix usage output
      ipmonitor: Mention "nexthop" object in help and man page

Jarod Wilson (1):
      bond: support xmit_hash_policy=3Dvlan+srcmac

Luca Boccassi (1):
      iproute: fix printing resolved localhost

Maxim Mikityanskiy (1):
      tc/htb: Hierarchical QoS hardware offload

Oleksandr Mazur (1):
      devlink: add support for port params get/set

Oliver Hartkopp (1):
      iplink_can: add Classical CAN frame LEN8_DLC support

Parav Pandit (10):
      devlink: Introduce and use string to number mapper
      devlink: Introduce PCI SF port flavour and attribute
      devlink: Supporting add and delete of devlink port
      devlink: Support get port function state
      devlink: Support set of port function state
      Add kernel headers
      utils: Add helper routines for indent handling
      utils: Add generic socket helpers
      utils: Add helper to map string to unsigned int
      vdpa: Add vdpa tool

Patrisious Haddad (1):
      rdma: Add support for the netlink extack

Paul Blakey (1):
      tc: flower: Add support for ct_state reply flag

Petr Machata (8):
      lib: rt_names: Add rtnl_dsfield_get_name()
      lib: Generalize parse_mapping()
      dcb: Generalize dcb_set_attribute()
      dcb: Generalize dcb_get_attribute()
      dcb: Support -N to suppress translation to human-readable names
      dcb: Add a subtool for the DCB APP object
      dcb: Add a subtool for the DCBX object
      ip: Fix batch processing

Roi Dayan (1):
      dcb: Fix compilation warning about reallocarray

Sabrina Dubroca (1):
      ip: xfrm: limit the length of the security context name when printing

Stephen Hemminger (11):
      Update kernel headers from 5.12-pre rc
      vdpa: add .gitignore
      ip: cleanup help message text
      README: remove doc instructions
      uapi: minor header update for l2tp
      uapi: bpf.h update from upstream
      erspan: fix JSON output
      uapi: update can.h
      uapi: add missing virtio related headers
      remove trailing whitespace
      v5.12.0

Thayne McCombs (2):
      ss: always prefer family as part of host condition to default family
      ss: Make leading ":" always optional for sport and dport

Toke H=C3=B8iland-J=C3=B8rgensen (1):
      q_cake: Fix incorrect printing of signed values in class statistics

Tony Ambardar (1):
      lib/bpf: add missing limits.h includes

wenxu (1):
      tc: flower: add tc conntrack inv ct_state support

