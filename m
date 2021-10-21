Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C14854363E5
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 16:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231494AbhJUOSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 10:18:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229878AbhJUOSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Oct 2021 10:18:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0943461212;
        Thu, 21 Oct 2021 14:16:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634825781;
        bh=k/hUrfv1KL3laVyYybpYMOL24N3eolj8XDi2HV7vh5Q=;
        h=From:To:Cc:Subject:Date:From;
        b=c0+P0dpUEcNr6pslbEn2GgvQYK9Gh2dvaafX4qMXbMleYtR68OddbGM9CZfyjzO2z
         PuKRWfCQvXpHYwB3It7jcc+boTjSAGP/VYDtlQ1l+HPoBbT7U0Rqw+czx9RyyINduU
         Z3UX9Q8GuwHL2NLi8mZsoOluEmbNHnzYUPqv0/cqvcnemqo373VvH0ZJQlATKPVKHh
         BWY+BJrzotJzqYGKiglb6QuRLokiAfDwgq1b02NlEXPCKa3nSED5KhAXmD8fSeMU3w
         xAbdlUdIlxvaZQ06h3AcuVRgjZOABF61KAlNl7ROn827mcMdefw0m5VPA3xoGkIECu
         bde92nsrhgXPg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/4] Delete impossible devlink notifications
Date:   Thu, 21 Oct 2021 17:16:12 +0300
Message-Id: <cover.1634825474.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

This series is a followup to the delayed devlink notification scheme.

I removed the impossible notifications together with attempt to annotate
various calls in order to mark them as pre/post devlink)register().

Other notifications are called before and after delvink_register() so
they weren't changed in this pathcset.

Thanks

Leon Romanovsky (4):
  devlink: Delete obsolete parameters publish API
  devlink: Remove not-executed trap policer notifications
  devlink: Remove not-executed trap group notifications
  devlink: Clean not-executed param notifications

 include/net/devlink.h |  3 --
 net/core/devlink.c    | 96 +++++++++++++------------------------------
 2 files changed, 29 insertions(+), 70 deletions(-)

-- 
2.31.1

