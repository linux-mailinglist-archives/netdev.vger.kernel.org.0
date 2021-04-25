Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC40136A6F0
	for <lists+netdev@lfdr.de>; Sun, 25 Apr 2021 13:53:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbhDYLyH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Apr 2021 07:54:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:47840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229659AbhDYLyH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Apr 2021 07:54:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B11716103E;
        Sun, 25 Apr 2021 11:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619351607;
        bh=wgS/v3/+OVtZXdVAwWWxH92auIBTLF24zaE75+o73Wg=;
        h=From:To:Cc:Subject:Date:From;
        b=ko6lnwG375zMwY2kDkK/9+cJN20Ow+NLEjEXWGHQp+Dul1T8nK6FqVVWnMXjAPzMP
         WEX0GlaxB5//C21d3D+SEkt5VU0kxA/gLVNYqQYRONKj0McD+XAoTwzgXwZ9EkZdSq
         vzGEbLlH9AmUnL6wtKn7HoTkGl4FabDHjXzjyVyMYIWyPJjetqq/efDmy/QtDLJbmZ
         UY9QpbeuBd/LenHGb+9N9vtNuURTBWjzfdQq76tc2XbylX3Pzpl7sHSFN+l5+ZCDBi
         6xosMujfQVaNPKU5z84agWti18/0LnznZKHmc2N1rjRdQvlLybPJv6uKA2ynf8FNwd
         lclWp5GCZxB2w==
From:   Leon Romanovsky <leon@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Ido Kalir <idok@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        Mark Zhang <markz@mellanox.com>,
        Neta Ostrovsky <netao@nvidia.com>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: [PATCH iproute2-next 0/3] Add context and SRQ information to rdmatool
Date:   Sun, 25 Apr 2021 14:53:19 +0300
Message-Id: <cover.1619351025.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

This is the user space part of already accepted to the kernel series
that extends RDMA netlink interface to return uverbs context and SRQ
information.

The accepted kernel series can be seen here:
https://lore.kernel.org/linux-rdma/20210422133459.GA2390260@nvidia.com/

Thanks

Neta Ostrovsky (2):
  rdma: Update uapi headers
  rdma: Add context resource tracking information
  rdma: Add SRQ resource tracking information

 man/man8/rdma-resource.8              |  12 +-
 rdma/Makefile                         |   2 +-
 rdma/include/uapi/rdma/rdma_netlink.h |  13 ++
 rdma/res-ctx.c                        | 103 ++++++++++
 rdma/res-srq.c                        | 274 ++++++++++++++++++++++++++
 rdma/res.c                            |   8 +-
 rdma/res.h                            |  28 +++
 rdma/utils.c                          |   8 +
 8 files changed, 445 insertions(+), 3 deletions(-)
 create mode 100644 rdma/res-ctx.c
 create mode 100644 rdma/res-srq.c

-- 
2.30.2

