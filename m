Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B23AD42FE63
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 00:53:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243409AbhJOWzo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 18:55:44 -0400
Received: from www62.your-server.de ([213.133.104.62]:46066 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243388AbhJOWzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 18:55:40 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mbW4w-000Beb-Ol; Sat, 16 Oct 2021 00:53:30 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next 0/4] ip, neigh: Add managed neighbor support
Date:   Sat, 16 Oct 2021 00:53:15 +0200
Message-Id: <20211015225319.2284-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26323/Fri Oct 15 10:25:36 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 patches to add support for managed neighbor entries as per recent
net-next commits:

  2ed08b5ead3c ("Merge branch 'Managed-Neighbor-Entries'")
  c47fedba94bc ("Merge branch 'minor-managed-neighbor-follow-ups'")

Thanks!

Daniel Borkmann (4):
  Update kernel headers
  ip, neigh: Fix up spacing in netlink dump
  ip, neigh: Add missing NTF_USE support
  ip, neigh: Add NTF_EXT_MANAGED support

 include/uapi/linux/neighbour.h | 35 +++++++++++++++++++++----------
 ip/ipneigh.c                   | 38 ++++++++++++++++++++++------------
 man/man8/ip-neighbour.8        | 17 +++++++++++++++
 3 files changed, 66 insertions(+), 24 deletions(-)

-- 
2.27.0

