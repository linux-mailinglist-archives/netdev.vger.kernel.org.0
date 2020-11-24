Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDF8D2C28BE
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 14:53:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388671AbgKXNxU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 08:53:20 -0500
Received: from simonwunderlich.de ([79.140.42.25]:46020 "EHLO
        simonwunderlich.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388652AbgKXNxO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 08:53:14 -0500
X-Greylist: delayed 533 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 08:53:14 EST
Received: from kero.packetmixer.de (p200300c59720c9e082fbfcd64a8e5ba3.dip0.t-ipconnect.de [IPv6:2003:c5:9720:c9e0:82fb:fcd6:4a8e:5ba3])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by simonwunderlich.de (Postfix) with ESMTPSA id C0E8117405E;
        Tue, 24 Nov 2020 14:44:18 +0100 (CET)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net: batman-adv 2020-11-24
Date:   Tue, 24 Nov 2020 14:44:16 +0100
Message-Id: <20201124134417.17269-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David, hi Jakub,

here is a bugfix for batman-adv which we would like to have integrated into net.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit f8394f232b1eab649ce2df5c5f15b0e528c92091:

  Linux 5.10-rc3 (2020-11-08 16:10:16 -0800)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-net-pullrequest-20201124

for you to fetch changes up to 14a2e551faea53d45bc11629a9dac88f88950ca7:

  batman-adv: set .owner to THIS_MODULE (2020-11-15 11:43:56 +0100)

----------------------------------------------------------------
Here is a batman-adv bugfix:

 - set module owner to THIS_MODULE, by Taehee Yoo

----------------------------------------------------------------
Taehee Yoo (1):
      batman-adv: set .owner to THIS_MODULE

 net/batman-adv/log.c | 1 +
 1 file changed, 1 insertion(+)
