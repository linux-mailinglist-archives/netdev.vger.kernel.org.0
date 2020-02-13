Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6FAB15BFBA
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 14:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730036AbgBMNvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 08:51:11 -0500
Received: from smtp1.axis.com ([195.60.68.17]:9096 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730003AbgBMNvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 08:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=471; q=dns/txt; s=axis-central1;
  t=1581601871; x=1613137871;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=u7TrqpljM6+g5jc0R1+ugOcsj0fCQ4+dleDu1neodY0=;
  b=bK1zwZUBsrIQ1f1ZEGxhRsTyMZkyVKMkfqALwgsTXc2s+3QN6g7Cg+sE
   DgNaY8xV4omdJQpB7juAkkfoZuzGH5b0XqvKhu6hPPhkcah3DT5hysJJM
   8EnKmLcERXegmQvw2DGkmkCmtSntoQCSZDMD3cBOkHHoyNgbrJhJuW6xc
   0AnFfvSLeskuCKSb2B8bVr/PCqDjvL5P4+T0oo4nldCJUEexvanEdwr4E
   2Fj+jX+NYMKudnvJZs15QkFek9YbFVnyWlUgScHydowAKH/hjU5Zeek4G
   18TFWnPMxeIj4f+q7C7ej1EnbRt/67Bz463oBSaP0ihi4dZBSNachM5ZV
   g==;
IronPort-SDR: zDsOwGEb7hZWVR6qyFIym6GNMhIyMQomdYa4cm0CTL/GpCBQnkf9w4VdZ7iGXH/AbIzQP9VYFq
 pFHA/kbtZD6OGBQ5DyUHaim8DoCEkVK3QuUAJ2/C//KAiSsCwKXhOPf3kDwqLVG9ENCkBuPtJv
 +HbClpw3C3/96aniaw/nO/p4cUSNlRscoiEHoLi4//2bWltFG11SuJ8MegkyksFs8wodgQOSE+
 Y/GJ3TKZavC3kseiUFFB4RF4Wh9u9L26gzlUaAhVIaTpGH6vb8qs+SYa6/bJWAudkv66Frk1EN
 GVE=
X-IronPort-AV: E=Sophos;i="5.70,436,1574118000"; 
   d="scan'208";a="5388423"
From:   <Per@axis.com>, <"Forlin <per.forlin"@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>
Subject: [PATCH net 0/2] net: dsa: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 14:50:58 +0100
Message-ID: <20200213135100.2963-1-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Per Forlin <per.forlin@axis.com>

Re-posting patches with a cover letter.
I forgot to include a cover-letter in the first round.

Fix two tag drivers to make sure there is headroom for the tag data.

Per Forlin (2):
  net: dsa: tag_qca: Make sure there is headroom for tag
  net: dsa: tag_ar9331: Make sure there is headroom for tag

 net/dsa/tag_ar9331.c | 2 +-
 net/dsa/tag_qca.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.11.0

