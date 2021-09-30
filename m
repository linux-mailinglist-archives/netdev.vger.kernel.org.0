Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55F5E41D29D
	for <lists+netdev@lfdr.de>; Thu, 30 Sep 2021 07:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348040AbhI3FOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Sep 2021 01:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236162AbhI3FOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Sep 2021 01:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9309D6142A;
        Thu, 30 Sep 2021 05:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632978769;
        bh=4QH/619IxiuIEopsC3sn97j1l53+ZQHiNJ5wMPJ/Qh8=;
        h=From:To:Cc:Subject:Date:From;
        b=t4f5+IOoNuPKrETE3mgjPdJlnlgf4s8MGtVu4ewbBLvwS18Ny9A5rq4buMZ9VF6ZH
         +MuYGdVUhM4YfoVYmvn/5K41HG4mMtAdJ+hR2c8CI1MRRlLyA/Yx6dyjPVGOT+qGY+
         fZZaRCHjlIXaMwIvuG1mGEtNHpyyP5x+2dxbX899ALEaTznwN8QojvHSsx3HFk6Y17
         6U7B3OQ4+wC02rZRxKIDdI8cXwlom6w8imd2l1sfmYcGuqIiT6ujzk7hxPKoWZgtgf
         W5P9pSgZVoOKXNR72kFbCOkvXdcdhmsQnraKOCJnyWpGhjRewP9enDo3mSJr0Sucmp
         5I6gSw2+FqKAg==
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Leon Romanovsky <leonro@nvidia.com>, linux-kernel@vger.kernel.org,
        linux-netdev <netdev@vger.kernel.org>
Subject: [PATCH net] MAINTAINERS: Remove Bin Luo as his email bounces
Date:   Thu, 30 Sep 2021 08:12:43 +0300
Message-Id: <045a32ccf394de66b7899c8b732f44dc5f4a1154.1632978665.git.leonro@nvidia.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leonro@nvidia.com>

The emails sent to luobin9@huawei.com bounce with error:
 "Recipient address rejected: Failed recipient validation check."

So let's remove his entry and change the status of hinic driver till
someone in Huawei will step-in to maintain it again.

Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
---
 MAINTAINERS | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index b585e6092a74..1e39189b4004 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -8609,9 +8609,8 @@ F:	Documentation/devicetree/bindings/iio/humidity/st,hts221.yaml
 F:	drivers/iio/humidity/hts221*
 
 HUAWEI ETHERNET DRIVER
-M:	Bin Luo <luobin9@huawei.com>
 L:	netdev@vger.kernel.org
-S:	Supported
+S:	Orphan
 F:	Documentation/networking/device_drivers/ethernet/huawei/hinic.rst
 F:	drivers/net/ethernet/huawei/hinic/
 
-- 
2.31.1

