Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3A8643BB1F
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 21:41:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236995AbhJZTnb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 15:43:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:54366 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238975AbhJZTnO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 15:43:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 952F960F6F;
        Tue, 26 Oct 2021 19:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635277247;
        bh=EB4pB9FSYxEAuxT42EHBLWI0m50cPJoX3PzcWKd345w=;
        h=From:To:Cc:Subject:Date:From;
        b=fPW2wOK+l0FvPJSb13CcYSSg0BCb96xNtEQKtJzyCOF7tlf4bwaE4voR+SEDHEGh5
         gS1VzwS1gCHDJ6YDAp71bzel+wvLv+cF1pyqhJ1ahLonDl60B6in873uApWxV9h0x6
         hgIBA1/SApIBz1/T5RbFT0SIG2pjkwyVHLjgxeBGDUcqX8/KauXf6dP0zZ2fydiFFg
         fiWHdwi+gGDdCGrphWNSA7Oq5yWMXBUvls+rEa+KBcyeJp/PfgsZqw5rffSnX01nnO
         Xp2bh5Wpnj4ldWESnJEkOKCHhNOBGKPw0h5w2VDeCS1Y9kxK+fayrVUsHEKa/vDsKZ
         t07KVQ4fqQrSA==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH net-next 0/2] Two reverts to calm down devlink discussion
Date:   Tue, 26 Oct 2021 22:40:40 +0300
Message-Id: <cover.1635276828.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

Hi,

Two reverts as was discussed in [1], fast, easy and wrong in long run
solution to syzkaller bug [2].

Thanks

[1] https://lore.kernel.org/all/20211026120234.3408fbcc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com
[2] https://lore.kernel.org/netdev/000000000000af277405cf0a7ef0@google.com/

Leon Romanovsky (2):
  Revert "devlink: Remove not-executed trap group notifications"
  Revert "devlink: Remove not-executed trap policer notifications"

 net/core/devlink.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

-- 
2.31.1

