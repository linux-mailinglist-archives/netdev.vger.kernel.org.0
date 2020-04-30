Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C523B1C043A
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 19:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726534AbgD3R6G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 13:58:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:39872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726285AbgD3R6G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 13:58:06 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C013C20836;
        Thu, 30 Apr 2020 17:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588269486;
        bh=Hv1y641BH4qovDJmcYM9lLoglfW8Q/x5U+hcX9rwnK4=;
        h=From:To:Cc:Subject:Date:From;
        b=Xdm0w5PNdSBNWMf/6XeNhy1o5rvInem69NLGTXJ2CZXM1BtiDdZRZQcaKrUvZUs+M
         yvkXBVQ21zfBDkrXvEobgNvQvUYQo78LyR7ZFizMi6PqQJ6wuJc1v2VcvTnY3YFEUT
         t2yaIjN96YGC1/d+Xurfp7r23G+6Q6mWgVlBlQus=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net, jiri@resnulli.us
Cc:     netdev@vger.kernel.org, kernel-team@fb.com,
        jacob.e.keller@intel.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v3 0/3] devlink: kernel region snapshot id allocation
Date:   Thu, 30 Apr 2020 10:57:55 -0700
Message-Id: <20200430175759.1301789-1-kuba@kernel.org>
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

 .../networking/devlink/devlink-region.rst     |  11 +-
 net/core/devlink.c                            | 108 ++++++++++++++----
 .../drivers/net/netdevsim/devlink.sh          |  13 +++
 3 files changed, 106 insertions(+), 26 deletions(-)

-- 
2.25.4

