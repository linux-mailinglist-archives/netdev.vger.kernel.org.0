Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D82C241731
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 09:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728205AbgHKHcJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Aug 2020 03:32:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:37184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728093AbgHKHcI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Aug 2020 03:32:08 -0400
Received: from localhost (unknown [213.57.247.131])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0A12220781;
        Tue, 11 Aug 2020 07:32:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597131127;
        bh=wf8Y3IbUv4acwXjYKzhaB++2Fsi2xmihkG3ndC6Kzl4=;
        h=From:To:Cc:Subject:Date:From;
        b=mNCPQpGb94C0MjHS/FiG/q+45mVB4fcr0N4gfq4Tg7oh4NELQAAYG0Or/qW222TRi
         fLXp41gMaY9Cr6SvsgXaaREEulPFjAo29/BqnJMee7dhcoIoJokNwbYZEVtEnv9ZFo
         GhyLzfTKtyxKrCnds8NDQvwH1ZfxbTRC3IKK6MjQ=
From:   Leon Romanovsky <leon@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-rc v1 0/2] Fix rdmatool JSON conversion
Date:   Tue, 11 Aug 2020 10:31:59 +0300
Message-Id: <20200811073201.663398-1-leon@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Changelog:
v1:
 * Added extra patch
 * Don't print [] in owner name in JSON output
v0:
https://lore.kernel.org/linux-rdma/20200811063304.581395-1-leon@kernel.org
---------------------------------------------------------------------------

Two fixes to RDMAtool JSON/CLI prints.

Leon Romanovsky (2):
  rdma: Fix owner name for the kernel resources
  rdma: Properly print device and link names in CLI output

 rdma/res.c | 24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--
2.26.2

