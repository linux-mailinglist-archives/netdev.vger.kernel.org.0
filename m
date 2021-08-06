Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED3D13E2A2E
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 13:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243630AbhHFL5G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Aug 2021 07:57:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229578AbhHFL5F (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Aug 2021 07:57:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6C40610CB;
        Fri,  6 Aug 2021 11:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628251010;
        bh=r8kvqaMszSSwZoRgi7xAfkmVF6R+Ig+dxYweEdMXW0k=;
        h=From:To:Cc:Subject:Date:From;
        b=ptw6kqOWyFt2EeI6RFgPcRgKeGMUgfdiAeewWhju8IcH10fruA7ERJKxjLchmHTpg
         K8QNhgDmoumjP+rrG8onjydbOF052LkbMXEqMxJDws6IYS3LDT5IxXr87F3jnVWk2B
         xo9CoU00FQwE9Ah/hEE/6fP/ryXXP+Dksi1UAB53QyGTKui8vQv/JIHD9pL2LlQzFX
         hWHnefZzEooA3wcMN8cWYEdKSEnAFHbWYMzZmzk3/dP8ufPIiTFV/4UgbOoORkKZTQ
         cKMl4ArrjN22YGGTfGkGUY9SKgNhGMyNZkJtFfTS2gGDyhEXkEi7auGbPARMngX/Rq
         4iyFLLw+1MqGw==
From:   Mark Brown <broonie@kernel.org>
To:     Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: linux-next: manual merge of the bluetooth tree with the net tree
Date:   Fri,  6 Aug 2021 12:56:33 +0100
Message-Id: <20210806115633.23180-1-broonie@kernel.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi all,

Today's linux-next merge of the bluetooth tree got conflicts in:

  net/bluetooth/hci_sysfs.c
  net/bluetooth/hci_core.c
  include/net/bluetooth/hci_core.h

between commit:

  e04480920d1e ("Bluetooth: defer cleanup of resources in hci_unregister_dev()")

from the net tree and commit:

  58ce6d5b271a ("Bluetooth: defer cleanup of resources in hci_unregister_dev()")

from the bluetooth tree.

I fixed it up (see below) and can carry the fix as necessary. This
is now fixed as far as linux-next is concerned, but any non trivial
conflicts should be mentioned to your upstream maintainer when your tree
is submitted for merging.  You may also want to consider cooperating
with the maintainer of the conflicting tree to minimise any particularly
complex conflicts.

diff --cc include/net/bluetooth/hci_core.h
index db4312e44d47,a7d06d7da602..000000000000
--- a/include/net/bluetooth/hci_core.h
+++ b/include/net/bluetooth/hci_core.h
diff --cc net/bluetooth/hci_core.c
index e1a545c8a69f,cb2e9e513907..000000000000
--- a/net/bluetooth/hci_core.c
+++ b/net/bluetooth/hci_core.c
diff --cc net/bluetooth/hci_sysfs.c
index b69d88b88d2e,ebf282d1eb2b..000000000000
--- a/net/bluetooth/hci_sysfs.c
+++ b/net/bluetooth/hci_sysfs.c
