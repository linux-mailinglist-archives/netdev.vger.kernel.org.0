Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23C652CA4A6
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 15:00:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391406AbgLAN5q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Dec 2020 08:57:46 -0500
Received: from out30-132.freemail.mail.aliyun.com ([115.124.30.132]:44354 "EHLO
        out30-132.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2391267AbgLAN5p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Dec 2020 08:57:45 -0500
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R441e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04420;MF=xuanzhuo@linux.alibaba.com;NM=1;PH=DS;RN=17;SR=0;TI=SMTPD_---0UHBq6Xj_1606831018;
Received: from localhost(mailfrom:xuanzhuo@linux.alibaba.com fp:SMTPD_---0UHBq6Xj_1606831018)
          by smtp.aliyun-inc.com(127.0.0.1);
          Tue, 01 Dec 2020 21:56:59 +0800
From:   Xuan Zhuo <xuanzhuo@linux.alibaba.com>
To:     magnus.karlsson@intel.com, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        KP Singh <kpsingh@chromium.org>,
        netdev@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        bpf@vger.kernel.org (open list:XDP SOCKETS (AF_XDP)),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH bpf V3 0/2] xsk: fix for xsk_poll writeable
Date:   Tue,  1 Dec 2020 21:56:56 +0800
Message-Id: <cover.1606555939.git.xuanzhuo@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
References: <MW3PR11MB46023BE924A19FB198604C0DF7F40@MW3PR11MB4602.namprd11.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


V2:
   #2 patch made some changes following magnus' opinions.

V3:
   Regarding the function xskq_cons_present_entries, I think daniel are right,
   I have modified it.

Xuan Zhuo (2):
  xsk: replace datagram_poll by sock_poll_wait
  xsk: change the tx writeable condition

 net/xdp/xsk.c       | 20 ++++++++++++++++----
 net/xdp/xsk_queue.h |  6 ++++++
 2 files changed, 22 insertions(+), 4 deletions(-)

--
1.8.3.1

