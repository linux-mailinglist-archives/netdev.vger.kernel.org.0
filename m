Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06BB0251155
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 07:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbgHYFIU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 01:08:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgHYFIS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 01:08:18 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2354CC061574
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:18 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id d139so4880153qke.11
        for <netdev@vger.kernel.org>; Mon, 24 Aug 2020 22:08:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=u640OaobPHFzcS5upItcsMK59UxaOWft829Rke4KdfA=;
        b=VUvzBkiDgymE5aSVMgJ7wNEmvndl0P+Q9K+cYOJRI9MMv02IM3+EYhG6VoT3u4vWPv
         ON0k3KVbb7X2ro74HXVV2ANqQNSES7+6DnZs0dXD4uIHqfY2/h1800C/+bSwNd2YLrhH
         iv/OXOKzESscbUnV/I9yihiJRQluQdov6zfgLVxddDli3vExXmfPLPPevVeMTZa28kr4
         lSbLXY+sPUN4S2BKpM5M8zx77qCZeiPqxQ9P55e9V5j3LAnfeAB1ptns+2BU6U88sQub
         L5qm9ZilXpgujL8yU/WtvUed2OaL36MFa2amDxodXVtzIGe69Ti+6eZjIfYiMgDTCBKM
         0Dyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=u640OaobPHFzcS5upItcsMK59UxaOWft829Rke4KdfA=;
        b=R9ebUk8Gmo3Xls2EveOYv4QBzyldGR6kjraLH1E46oxxx7zCE8KN+3zwGRoS2XI6/t
         qFxlRe6aThJEJjqGjcnyp+PHZ0a42V+OJGW4eLGgt81YDJP8yimhgydZqkvCzkhOYBAy
         rAJvZShHJn2rUYWCE7uQJBjIpIwnxdEayZkL119DLi+XtFd3DMMhgDwnoTXJraV9ecJZ
         6v++CPrghw2dMHbHR+ZWq6Ts28dLp27AutbdFOhdp8akDzmZW0iRsE7sy2YwPfCkOqmM
         bRS0uvxpp+H5AM/g3A2kyUd6TvXvMu1d2oteN5BfiNt+rXLv2E4DnpE4FhbLe1flPX4Z
         Bdcw==
X-Gm-Message-State: AOAM531gMFHrSSRfUfaVUVwh4oMxjwbdrl9f/BPXR3bhJRGHcQVsEO4z
        DoJ8ioUd+mOQcXWMbZH5DoM=
X-Google-Smtp-Source: ABdhPJxL8t11jsW/gwJlsdPUowihTF2y8puZxoQJlooOzKZNkP0Y7NmmOHROEtOx29dmjOutSteAgg==
X-Received: by 2002:a37:2781:: with SMTP id n123mr7667877qkn.59.1598332097314;
        Mon, 24 Aug 2020 22:08:17 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 16sm7261723qkv.34.2020.08.24.22.08.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Aug 2020 22:08:16 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     davem@davemloft.net, pshelar@ovn.org, xiyou.wangcong@gmail.com
Cc:     dev@openvswitch.org, netdev@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v3 0/3] net: openvswitch: improve codes
Date:   Tue, 25 Aug 2020 13:06:33 +0800
Message-Id: <20200825050636.14153-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patches are not bug fix, just improve codes.

Tonghao Zhang (3):
  net: openvswitch: improve coding style
  net: openvswitch: refactor flow free function
  net: openvswitch: remove unnused keep_flows

 net/openvswitch/actions.c    |  5 +--
 net/openvswitch/datapath.c   | 35 +++++++++++--------
 net/openvswitch/flow_table.c | 68 +++++++++++++++++-------------------
 net/openvswitch/flow_table.h |  1 -
 net/openvswitch/vport.c      |  7 ++--
 5 files changed, 60 insertions(+), 56 deletions(-)

-- 
2.23.0

