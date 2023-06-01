Return-Path: <netdev+bounces-7031-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CD2C171957D
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 10:26:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60096280D36
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 08:26:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DBAF14271;
	Thu,  1 Jun 2023 08:26:19 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1057714262
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 08:26:18 +0000 (UTC)
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEB4C126
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 01:26:17 -0700 (PDT)
Received: from drehscheibe.grey.stw.pengutronix.de ([2a0a:edc0:0:c01:1d::a2])
	by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddE-0002ti-GT; Thu, 01 Jun 2023 10:26:04 +0200
Received: from [2a0a:edc0:0:900:1d::77] (helo=ptz.office.stw.pengutronix.de)
	by drehscheibe.grey.stw.pengutronix.de with esmtp (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddC-004JKW-Se; Thu, 01 Jun 2023 10:26:02 +0200
Received: from ukl by ptz.office.stw.pengutronix.de with local (Exim 4.94.2)
	(envelope-from <ukl@pengutronix.de>)
	id 1q4ddB-00A5yT-N0; Thu, 01 Jun 2023 10:26:01 +0200
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
To: Kalle Valo <kvalo@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org,
	kernel@pengutronix.de
Subject: [PATCH net-next 0/4] Convert to platform remove callback returning void
Date: Thu,  1 Jun 2023 10:25:52 +0200
Message-Id: <20230601082556.2738446-1-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 2.39.2
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-Developer-Signature: v=1; a=openpgp-sha256; l=694; i=u.kleine-koenig@pengutronix.de; h=from:subject; bh=LDH1GV5OzpFdWpqljYlURuz66Yddzkf91qnNMP1L1/I=; b=owEBbQGS/pANAwAKAY+A+1h9Ev5OAcsmYgBkeFYL6blk48dDBZlBxSMvwwo9tSJyyfPVB8GgZ uLtgKzsALKJATMEAAEKAB0WIQQ/gaxpOnoeWYmt/tOPgPtYfRL+TgUCZHhWCwAKCRCPgPtYfRL+ Toa3B/9QAE/Xf3Bc5GdAS3I3ut7SbNYsFuCllbzG2XTQZQTj/c/5jvjl3XjNp1b6NoK8gNt5oUa umkrElgUY5f+g58K8dUW0x0ui3qMQYomra028yxPCzzZQacYM/Wi1cQnehHCzVZMjX9Y9BTtWUL NmnORDdGxmitfQ3b11inPsGDZEjVP6xge4k6bWQOaVCTMwZBRIP4A0TiSbJaw6b9JpSjPtqOHhW l/tEHoOWdhCgDu1cvzMwJQ/PPap861qVnY878uyDuoN1ZEUG3L8p7UAkfRELNibTZx/XW6KElgK 1nmOYQF1OXLYv3WBrORk2RfrpmBn0XJ656LKWq3/k66hh8qn
X-Developer-Key: i=u.kleine-koenig@pengutronix.de; a=openpgp; fpr=0D2511F322BFAB1C1580266BE2DCDD9132669BD6
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2a0a:edc0:0:c01:1d::a2
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hello,

the motivation for this series is patch #3, patch #2 is a preparation for it
and patches #1 and #4 are just cleanups that I noticed en passant.

Best regards
Uwe

Uwe Kleine-König (4):
  ath10k: Drop cleaning of driver data from probe error path and remove
  ath10k: Drop checks that are always false
  ath10k: Convert to platform remove callback returning void
  atk10k: Don't opencode ath10k_pci_priv() in ath10k_ahb_priv()

 drivers/net/wireless/ath/ath10k/ahb.c  | 20 +++-----------------
 drivers/net/wireless/ath/ath10k/snoc.c |  8 +++-----
 2 files changed, 6 insertions(+), 22 deletions(-)

base-commit: ac9a78681b921877518763ba0e89202254349d1b
-- 
2.39.2


