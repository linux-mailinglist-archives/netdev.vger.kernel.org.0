Return-Path: <netdev+bounces-6969-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CDBC6719119
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:12:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 650391C20FFC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 03:12:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DB18B6FBA;
	Thu,  1 Jun 2023 03:10:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F09D4C7E
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 03:10:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05A26C433EF;
	Thu,  1 Jun 2023 03:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685589054;
	bh=rjaEOql+1cVQA1g4HqJSCDksaf+UN7jkTbKEnQ1wsJ4=;
	h=From:To:Cc:Subject:Date:From;
	b=iCNbFqFKHSaAr5/J3JeKGP1WKcwO3YXectG6ya9g7tXov1a8zBXD4+fDWdf6mcrY9
	 ZGSVGA7AhHUCSBT1+TEHEqu2ZAUzfwVylusktPiNacoHW8Hqg18oMeJHWXv2/6RUcs
	 bzMcATe+MoV93JTFBE8yoT5CO4RovUcu2dpDyfDdd7/KDJBaAUxhQFXY8c4pQ7B8kr
	 FMuvATvr10XD2Nbl26c4LtbWDR09gBLq1iAT2d3hen2N6CqtHQ1+tTc2cmvc/CAQTB
	 yIhB+HccKiWR04BGztjgWx7mf8S8VVzQ7scm5wp8ksLr+Dh6G+CtGnD5j145AWsgY5
	 LdjHKNJVtKj9w==
From: Saeed Mahameed <saeed@kernel.org>
To: "David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Eric Dumazet <edumazet@google.com>
Cc: Saeed Mahameed <saeedm@nvidia.com>,
	netdev@vger.kernel.org,
	Tariq Toukan <tariqt@nvidia.com>
Subject: [pull request][net 0/5] mlx5 fixes 2023-05-31
Date: Wed, 31 May 2023 20:10:46 -0700
Message-Id: <20230601031051.131529-1-saeed@kernel.org>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Saeed Mahameed <saeedm@nvidia.com>

This series provides bug fixes to mlx5 driver.
Please pull and let me know if there is any problem.

Thanks,
Saeed.


The following changes since commit 448a5ce1120c5bdbce1f1ccdabcd31c7d029f328:

  udp6: Fix race condition in udp6_sendmsg & connect (2023-05-31 10:35:10 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-fixes-2023-05-31

for you to fetch changes up to bbfa4b58997e3d38ba629c9f6fc0bd1c163aaf43:

  net/mlx5: Read embedded cpu after init bit cleared (2023-05-31 20:08:37 -0700)

----------------------------------------------------------------
mlx5-fixes-2023-05-31

----------------------------------------------------------------
Chuck Lever (1):
      net/mlx5: Ensure af_desc.mask is properly initialized

Moshe Shemesh (1):
      net/mlx5: Read embedded cpu after init bit cleared

Niklas Schnelle (1):
      net/mlx5: Fix setting of irq->map.index for static IRQ case

Saeed Mahameed (1):
      net/mlx5e: Fix error handling in mlx5e_refresh_tirs

Shay Drory (1):
      net/mlx5: Remove rmap also in case dynamic MSIX not supported

 drivers/net/ethernet/mellanox/mlx5/core/en_common.c | 11 ++++-------
 drivers/net/ethernet/mellanox/mlx5/core/main.c      |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/pci_irq.c   | 13 +++++++------
 3 files changed, 12 insertions(+), 14 deletions(-)

