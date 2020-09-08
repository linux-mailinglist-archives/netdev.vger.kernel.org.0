Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B302326228C
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 00:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729312AbgIHWVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 18:21:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:36550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728483AbgIHWVU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 18:21:20 -0400
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27FFD2087D;
        Tue,  8 Sep 2020 22:21:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599603680;
        bh=20KIWmITmdCPtLonv14erPXGshXgTBzOEHmvfpzSro8=;
        h=From:To:Cc:Subject:Date:From;
        b=TP1Kk6X7xf8uS9jDrKgwzqW6xdCIUw/9hxuF3H43Ux1870dBLVNNN2j5MGKwXaGWX
         RM/wiQIiTaL5CpJ/CAUQqYXQsVw5se6uot+mqD4RNYE+9O/YfIiXtxRL8RqVPMi84q
         mDyO91yAsINw4eyDS3h8YvhP+kkv7atRp3V04zR8=
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        leonro@nvidia.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next v2 0/2] mlx4: avoid devlink port type not set warnings
Date:   Tue,  8 Sep 2020 15:21:12 -0700
Message-Id: <20200908222114.190718-1-kuba@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

This small set addresses the issue of mlx4 potentially not setting
devlink port type when Ethernet or IB driver is not built, but
port has that type.

v2:
 - add patch 1

Jakub Kicinski (2):
  devlink: don't crash if netdev is NULL
  mlx4: make sure to always set the port type

 drivers/net/ethernet/mellanox/mlx4/main.c | 11 +++++++++
 net/core/devlink.c                        | 28 ++++++++++++++++-------
 2 files changed, 31 insertions(+), 8 deletions(-)

-- 
2.26.2

