Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA38D1C1AB5
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 18:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbgEAQkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 12:40:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728443AbgEAQkp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 May 2020 12:40:45 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96FA324953;
        Fri,  1 May 2020 16:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588351244;
        bh=PJlDSZFsHrYM6ooXXHU2ZQ3Ok8D76vUAyw2B+mpmUeo=;
        h=From:To:Cc:Subject:Date:From;
        b=gBeaiqlQSAAyEZO3V73jLrIVUazZTaCgOYW5NQwopIQ7LzvKQlJnwu+sk/W2X2i/+
         K/IyH8bCqeE7ZSgmzlZiU9J730Z18b5UjT4lOzKpt+c/eUkjUKXP20vXr8zKCvmDNG
         x/V+LCGUzWAfDMOqgEvgoxjRHgafwqDTrHSMse5c=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v4 0/3] devlink: kernel region snapshot id allocation
Date:   Fri,  1 May 2020 09:40:39 -0700
Message-Id: <20200501164042.1430604-1-kuba@kernel.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

currently users have to find a free snapshot id to pass
to the kernel when they are requesting a snapshot to be
taken.

This set extends the kernel so it can allocate the id
on its own and send it back to user space in a response.

Jakub Kicinski (3):
  devlink: factor out building a snapshot notification
  devlink: let kernel allocate region snapshot id
  docs: devlink: clarify the scope of snapshot id

 .../networking/devlink/devlink-region.rst     | 11 ++-
 net/core/devlink.c                            | 96 ++++++++++++++-----
 .../drivers/net/netdevsim/devlink.sh          | 13 +++
 3 files changed, 94 insertions(+), 26 deletions(-)

-- 
2.25.4

