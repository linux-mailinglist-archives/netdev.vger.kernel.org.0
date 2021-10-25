Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF805439ABD
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 17:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbhJYPuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 11:50:00 -0400
Received: from www62.your-server.de ([213.133.104.62]:45670 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231686AbhJYPt7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Oct 2021 11:49:59 -0400
Received: from 226.206.1.85.dynamic.wline.res.cust.swisscom.ch ([85.1.206.226] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92.3)
        (envelope-from <daniel@iogearbox.net>)
        id 1mf2CG-000BDC-8G; Mon, 25 Oct 2021 17:47:36 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     dsahern@kernel.org
Cc:     netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH iproute2 -next v2 0/3] ip, neigh: Add managed neighbor support
Date:   Mon, 25 Oct 2021 17:47:25 +0200
Message-Id: <20211025154728.2161-1-daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.3/26333/Mon Oct 25 10:29:40 2021)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

iproute2 patches to add support for managed neighbor entries as per recent
net-next commits:

  2ed08b5ead3c ("Merge branch 'Managed-Neighbor-Entries'")
  c47fedba94bc ("Merge branch 'minor-managed-neighbor-follow-ups'")

Thanks!

v1 -> v2:
  - Rebase and dropped UAPI header update patch as not needed
    anymore, rest as is.

Daniel Borkmann (3):
  ip, neigh: Fix up spacing in netlink dump
  ip, neigh: Add missing NTF_USE support
  ip, neigh: Add NTF_EXT_MANAGED support

 ip/ipneigh.c            | 38 +++++++++++++++++++++++++-------------
 man/man8/ip-neighbour.8 | 17 +++++++++++++++++
 2 files changed, 42 insertions(+), 13 deletions(-)

-- 
2.27.0

