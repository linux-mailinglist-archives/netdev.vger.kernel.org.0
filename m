Return-Path: <netdev+bounces-11834-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 754BD734C21
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 09:09:50 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 309EF280F55
	for <lists+netdev@lfdr.de>; Mon, 19 Jun 2023 07:09:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B75474C9F;
	Mon, 19 Jun 2023 07:09:38 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7D046A7
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 07:09:38 +0000 (UTC)
Received: from proxima.lasnet.de (proxima.lasnet.de [78.47.171.185])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32EED106
	for <netdev@vger.kernel.org>; Mon, 19 Jun 2023 00:09:37 -0700 (PDT)
Received: from localhost.localdomain.datenfreihafen.local (p200300e9d715954d26b5d993c1929d94.dip0.t-ipconnect.de [IPv6:2003:e9:d715:954d:26b5:d993:c192:9d94])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: stefan@sostec.de)
	by proxima.lasnet.de (Postfix) with ESMTPSA id 80CE2C0244;
	Mon, 19 Jun 2023 09:09:31 +0200 (CEST)
From: Stefan Schmidt <stefan@datenfreihafen.org>
To: davem@davemloft.net,
	kuba@kernel.org,
	pabeni@redhat.com
Cc: linux-wpan@vger.kernel.org,
	alex.aring@gmail.com,
	miquel.raynal@bootlin.com,
	netdev@vger.kernel.org
Subject: pull-request: ieee802154 for net 2023-06-19
Date: Mon, 19 Jun 2023 09:09:27 +0200
Message-Id: <20230619070927.825332-1-stefan@datenfreihafen.org>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_LOW,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello Dave, Jakub, Paolo.

An update from ieee802154 for your *net* tree:

Two small fixes and MAINTAINERS update this time.

Azeem Shaikh ensured consistent use of strscpy through the tree and fixed
the usage in our trace.h.

Chen Aotian fixed a potential memory leak in the hwsim simulator for
ieee802154.

Miquel Raynal updated the MAINATINERS file with the new team git tree
locations and patchwork URLs.

regards
Stefan Schmidt

The following changes since commit 209373537648d815a104c3af787663d7db06bd5d:

  Merge branch 'bnxt_en-3-bug-fixes' (2023-03-29 21:48:18 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/wpan/wpan.git tags/ieee802154-for-net-2023-06-19

for you to fetch changes up to cd9125030689dda69f73f6c2843d63135cb383f0:

  ieee802154: Replace strlcpy with strscpy (2023-06-16 22:14:24 +0200)

----------------------------------------------------------------
Azeem Shaikh (1):
      ieee802154: Replace strlcpy with strscpy

Chen Aotian (1):
      ieee802154: hwsim: Fix possible memory leaks

Miquel Raynal (2):
      MAINTAINERS: Update wpan tree
      MAINTAINERS: Add wpan patchwork

 MAINTAINERS                              | 5 +++--
 drivers/net/ieee802154/mac802154_hwsim.c | 6 ++++--
 net/ieee802154/trace.h                   | 2 +-
 net/mac802154/trace.h                    | 2 +-
 4 files changed, 9 insertions(+), 6 deletions(-)

