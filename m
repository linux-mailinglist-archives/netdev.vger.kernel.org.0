Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F69878677
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 09:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726862AbfG2Hmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 03:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725917AbfG2Hmd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 03:42:33 -0400
Received: from localhost (unknown [77.137.115.125])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0223020657;
        Mon, 29 Jul 2019 07:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564386152;
        bh=Rgny8Tk0vXqgXakpvPQMlgmVuC2/1q7Vnnl3TbApp54=;
        h=From:To:Cc:Subject:Date:From;
        b=T6G2OAVQCQSX2PRNV4wjJZJVCghZsve+G9FFFwW3aqTXZYolnCz7uNFf+zJF4+zPF
         RSfm53vGf9GVwKEPMai6IFVg80wSVdZOBAwlcrL8GZ12aNC38KE78l2orp4cpd476T
         8DjJLYpf9vagWmHSLPv4fRFML8heLJJCFQqEzSa8=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Leon Romanovsky <leonro@mellanox.com>,
        netdev <netdev@vger.kernel.org>, David Ahern <dsahern@gmail.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>,
        Yamin Friedman <yaminf@mellanox.com>
Subject: [PATCH iproute2-rc 0/2] Control CQ adaptive moderation (RDMA DIM)
Date:   Mon, 29 Jul 2019 10:42:24 +0300
Message-Id: <20190729074226.4335-1-leon@kernel.org>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

Hi,

This is supplementary part of RDMA DIM feature [1] accepted
for the kernel v5.3. In this patch set Yamin extends rdmatool
to get/set as a default this adaptive-moderation setting on
IB device level and provides an information about DIM on/off
status per-CQ.

Thanks

[1] https://lore.kernel.org/linux-rdma/20190708105905.27468-1-leon@kernel.org/

Yamin Friedman (2):
  rdma: Control CQ adaptive moderation (DIM)
  rdma: Document adaptive-moderation

 man/man8/rdma-dev.8 | 16 ++++++++++++-
 rdma/dev.c          | 55 ++++++++++++++++++++++++++++++++++++++++++++-
 rdma/rdma.h         |  1 +
 rdma/res-cq.c       | 15 +++++++++++++
 rdma/utils.c        |  6 +++++
 5 files changed, 91 insertions(+), 2 deletions(-)

--
2.20.1

