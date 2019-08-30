Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E7314A30F3
	for <lists+netdev@lfdr.de>; Fri, 30 Aug 2019 09:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728107AbfH3H1k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Aug 2019 03:27:40 -0400
Received: from packetmixer.de ([79.140.42.25]:52134 "EHLO
        mail.mail.packetmixer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726452AbfH3H1k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Aug 2019 03:27:40 -0400
Received: from kero.packetmixer.de (p200300C5970B8500250C6283C70837BA.dip0.t-ipconnect.de [IPv6:2003:c5:970b:8500:250c:6283:c708:37ba])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.mail.packetmixer.de (Postfix) with ESMTPSA id 79AC16206F;
        Fri, 30 Aug 2019 09:27:38 +0200 (CEST)
From:   Simon Wunderlich <sw@simonwunderlich.de>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, b.a.t.m.a.n@lists.open-mesh.org,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 0/1] pull request for net-next: batman-adv 2019-08-30
Date:   Fri, 30 Aug 2019 09:27:35 +0200
Message-Id: <20190830072736.18535-1-sw@simonwunderlich.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi David,

here is a small maintenance pull request of batman-adv to go into net-next.

Please pull or let me know of any problem!

Thank you,
      Simon

The following changes since commit 9cb9a17813bf0de1f8ad6deb9538296d5148b5a8:

  batman-adv: BATMAN_V: aggregate OGMv2 packets (2019-08-04 22:22:00 +0200)

are available in the Git repository at:

  git://git.open-mesh.org/linux-merge.git tags/batadv-next-for-davem-20190830

for you to fetch changes up to 2a813f1392205654aea28098f3bcc3e6e2478fa5:

  batman-adv: Add Sven to MAINTAINERS file (2019-08-17 13:11:50 +0200)

----------------------------------------------------------------
This maintenance patchset includes the following patches:

 - Add Sven to the MAINTAINERS file, by Simon Wunderlich

----------------------------------------------------------------
Simon Wunderlich (1):
      batman-adv: Add Sven to MAINTAINERS file

 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)
