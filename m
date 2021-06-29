Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8641C3B77EA
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 20:37:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235159AbhF2Sjl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 14:39:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235090AbhF2Sji (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 14:39:38 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8176BC061766
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:37:10 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id s14so115774pfg.0
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 11:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=GYYJFaamlQ4AbQj9SmOWxz+LUl9zQKs+pisuzQmMkXA=;
        b=KJ+xFjXfeCOO5ZhDCTKNmwJ659KGsUyIEFobgyb8D3yBkb5z76d52Cn00X2mCNN6NP
         2qCkYIo58JE5oH1KGmYvbRV77ZPilh8QkG466J6cqks1IiJfR/oGF9zSlncBY9cKfN6W
         uiYhsLYoTBzwaEz2Gavec81yVwhYtlyG5U5LyBbCEtlRXKLAXhFBO4KLUbSerWvIIkfN
         jN4pkLtnyOOlIDhrG9T8k7TNKlRgI2ldJPN/4OzdnpQ0QKRYbvjOv3fnqXWqOOpWLbAg
         SNwJVD3OkpKttimj5F/ipP7RSCdRKeSZo0/wtjsltN39ryT8wHqVjJcV/AvOvtPJAUj2
         Z/zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-transfer-encoding;
        bh=GYYJFaamlQ4AbQj9SmOWxz+LUl9zQKs+pisuzQmMkXA=;
        b=S9x1eFQmeBHjbWS8S50iRWvvhPPJ5wKYPlQ0rVrwiCxdx04Hj1UvdrreavdJjMZKdV
         jA4OEXcCjTwgQcVYlGtgcjx4oy2lOi1a4AlVJOfViJUAu7+MgRxNGHt/l9ev2yuQN7Q1
         DttmqcCnPjseXwJq9DTpKkJfo8ZTznB0uyClLC+AZKNSMa2lueO6poaypTiang475ToZ
         YlUpZbJ84luopWyGFQUmFXTYsJJVjt92d12VOcv77xDLWhqfIlDrQNel+biEKGb54kGX
         x+6CJ50/ND1INUkAwwq1nnCysgKVWYuRXzOLqmduMq8LqBbhPC9SvsDC1EREkklYxAcE
         /JFg==
X-Gm-Message-State: AOAM531CYgLpQezggE/yPnYbJk50yXYuuguHBF62qjn563dK3wK+xYBz
        rY8t4fUR17G88SEGkrbXRh2yzpziOjZcgg==
X-Google-Smtp-Source: ABdhPJxgsL0vdmAkUg7ssETOJ8eh/OMZHtexQ5T23O42L3SLTyUnkARwYN2SyYk4xxAuDuHgSBj6rA==
X-Received: by 2002:a62:7f58:0:b029:300:9551:8cc0 with SMTP id a85-20020a627f580000b029030095518cc0mr31808219pfd.21.1624991829399;
        Tue, 29 Jun 2021 11:37:09 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id s1sm19282247pgg.49.2021.06.29.11.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 11:37:09 -0700 (PDT)
Date:   Tue, 29 Jun 2021 11:37:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Subject: [ANNOUNCE] iproute2 5.13
Message-ID: <20210629113706.4706d3bb@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It's been too hot here, but still Linus manages to get a kernel out.
So its time for another version of iproute2. This is a small release
must be the weather.

Note: iproute2 is now maintained on the "main" branch.
There are parallel copies (both updated) on kernel.org and github.

As always, it is recommended to always use the latest iproute2.
Do not treat iproute2 like perf and require matching packages.
The latest code will always run on older kernels (and vice versa);
this is possible because of the kernel API/ABI guarantees.
Except for rare cases, iproute2 does not do maintenance releases
and there is no long term stable version.


Download:
    https://www.kernel.org/pub/linux/utils/net/iproute2/iproute2-5.13.0.tar.gz

Repository for current release
    https://github.com/shemminger/iproute2.git
    git://git.kernel.org/pub/scm/network/iproute2/iproute2.git

And future release (net-next):
    git://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git

Contributions:

Andrea Claudi (1):
      lib: move get_task_name() from rdma

Baowen Zheng (1):
      police: add support for packet-per-second rate limiting

Ben Hutchings (2):
      utils: Fix BIT() to support up to 64 bits on all architectures
      devlink: Fix printf() type mismatches on 32-bit architectures

Chunmei Xu (1):
      ip-nexthop: support flush by id

Cooper Lees (1):
      Add Open/R to rt_protos

David Ahern (2):
      Update kernel headers
      Update kernel headers

Florian Westphal (2):
      mptcp: add support for event monitoring
      libgenl: make genl_add_mcast_grp set errno on error

Hoang Le (1):
      tipc: use the libmnl functions in lib/mnl_utils.c

Ido Schimmel (3):
      nexthop: Add ability to specify group type
      nexthop: Add support for resilient nexthop groups
      nexthop: Add support for nexthop buckets

Nikolay Aleksandrov (7):
      bridge: rename and export print_portstate
      bridge: add parse_stp_state helper
      bridge: vlan: add option set command and state option
      libnetlink: add bridge vlan dump request helper
      bridge: vlan: add support for the new rtm dump call
      bridge: monitor: add support for vlan monitoring
      bridge: vlan: dump port only if there are any vlans

Paolo Abeni (1):
      mptcp: add support for port based endpoint

Parav Pandit (4):
      devlink: Use library provided string processing APIs
      utils: Introduce helper routines for generic socket recv
      devlink: Use generic socket helpers from library
      devlink: Add error print when unknown values specified

Petr Machata (2):
      json_print: Add print_tv()
      nexthop: Extract a helper to parse a NH ID

Roi Dayan (1):
      devlink: Fix link errors on some systems

Roman Mashak (1):
      ss: update ss man page

Sabrina Dubroca (1):
      ip: xfrm: add support for tfcpad

Stephen Hemminger (4):
      uapi: update kernel headers to 5.13-rc6
      man: fix syntax for ip link property
      uapi: update headers to 5.13
      v5.13.0

Tony Ambardar (1):
      ip: drop 2-char command assumption


