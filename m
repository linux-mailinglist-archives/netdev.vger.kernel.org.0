Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9088834B290
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:16:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230026AbhCZXQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:16:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230027AbhCZXQM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Mar 2021 19:16:12 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CF3C0613AA;
        Fri, 26 Mar 2021 16:16:11 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id a11so5458173qto.2;
        Fri, 26 Mar 2021 16:16:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vgsz7ZN7uKy3wB1ShodSX/+9bSxifBh4BI3uckNFdmg=;
        b=YkrleWqbwO4BVBJWVA8WzfZD9F3QX7Sti2ANq3sxydQC9u4deOiETG9LXkw9PQo6Zm
         76xP5MJYL7+mVjLfxqcRXaCpxPXgx0Jz+phBwTYZYWTwmwbbXhoqpNjhXmJT4j4pHjDB
         mHHIcJi90GftJpe/fuXXjviBJpYhvEmCikOv0PeY1ocUiI/moy1RF7Q5fflej6HbAQ5Z
         /zmeVIG31oGZJ1cQEfuHUExYWQx+clnmymJb5uMjXYbGyZqcCs2aZguwq4muk0ic+8fx
         ZfGxY71T7KF7KVnMVyjFyJ5FJ+5FnXBHZdMiIX5ZcDx9q8LTUaSHgHgdWxEComS4pXDT
         VNPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Vgsz7ZN7uKy3wB1ShodSX/+9bSxifBh4BI3uckNFdmg=;
        b=PRH+4Bs393eh9xDp5f21s3R1BD0jhlk/uwFy1AzPL6B5+PaBrc0DAnPfO8xc43F+Lg
         0Bm4L4lzb+UWzVxKFqLZGhvycZns4ZIzBZCr+5M4vN4tVlcTO+9dwfc8XovtoF3dkSIP
         gTVeXdlWICZHnNBSNWSXhFDZwmn4kkZZOPhwXToSQFM37myMxgaUBpyrB1lE0JrLk7yt
         9Zi9ry+YBo0DoPERmhD8BNkpxT9p6iAgEMgyBFlv6hnLmCcJlQ/EnYqCM947EWCO/hu5
         nMBKZ6/BBsk1+2CKmmw2SrF5AyRrGszWW/cIlJOGfjDOJjT4L1Gio3PBtCKpkxVWY06M
         kLOQ==
X-Gm-Message-State: AOAM531wHselrXYL4ND1/QlVTY5IQT57WlMAIyNcAg6AurPnOU1IZMGb
        HbW+n979TjCKhmIFZwDmbTE=
X-Google-Smtp-Source: ABdhPJxN+05tcyuP3/wuenZyhXMmnVsYg81QksRIFkb0bmqUmK3+63WnsQienQcrQbvqhXLP4FVygQ==
X-Received: by 2002:ac8:4b58:: with SMTP id e24mr14054323qts.120.1616800570655;
        Fri, 26 Mar 2021 16:16:10 -0700 (PDT)
Received: from localhost.localdomain ([156.146.58.30])
        by smtp.gmail.com with ESMTPSA id w78sm7960414qkb.11.2021.03.26.16.16.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Mar 2021 16:16:09 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>, rdunlap@infradead.org
Subject: [PATCH 00/19] net: Trivial spello/typo fixes throughout the tree
Date:   Sat, 27 Mar 2021 04:42:35 +0530
Message-Id: <cover.1616797633.git.unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is a patch series with all mundane/trivial/rudimentary typo/spello/
fixes in various files in the net subsystem.

Bhaskar Chowdhury (19):
  xfrm_policy.c : Mundane typo fix
  xfrm_user.c: Added a punctuation
  af_x25.c: Fix a spello
  reg.c: Fix a spello
  node.c: A typo fix
  bearer.h: Spellos fixed
  sm_statefuns.c: Mundane spello fixes
  netfilter: ipvs: A spello fix
  netfilter: nf_conntrack_acct.c: A typo fix
  mptcp: subflow.c: Fix a typo
  ncsi: internal.h: Fix a spello
  mac80211: cfg.c: A typo fix
  llc: llc_core.c: COuple of typo fixes
  iucv: af_iucv.c: Couple of typo fixes
  kcm: kcmsock.c: Couple of typo fixes
  ipv6: route.c: A spello fix
  ipv6: addrconf.c: Fix a typo
  ipv4: ip_output.c: Couple of typo fixes
  ipv4: tcp_lp.c: Couple of typo fixes

 net/ipv4/ip_output.c              |  4 ++--
 net/ipv4/tcp_lp.c                 |  4 ++--
 net/ipv6/addrconf.c               |  2 +-
 net/ipv6/route.c                  |  2 +-
 net/iucv/af_iucv.c                |  4 ++--
 net/kcm/kcmsock.c                 |  4 ++--
 net/llc/llc_core.c                |  4 ++--
 net/mac80211/cfg.c                |  2 +-
 net/mptcp/subflow.c               |  2 +-
 net/ncsi/internal.h               |  2 +-
 net/netfilter/ipvs/ip_vs_core.c   |  2 +-
 net/netfilter/nf_conntrack_acct.c |  2 +-
 net/sctp/sm_statefuns.c           | 10 +++++-----
 net/tipc/bearer.h                 |  6 +++---
 net/tipc/node.c                   |  2 +-
 net/wireless/reg.c                |  2 +-
 net/x25/af_x25.c                  |  2 +-
 net/xfrm/xfrm_policy.c            |  2 +-
 net/xfrm/xfrm_user.c              |  2 +-
 19 files changed, 30 insertions(+), 30 deletions(-)

--
2.26.2

