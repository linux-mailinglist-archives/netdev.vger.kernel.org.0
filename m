Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A17F34A28
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 16:20:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfFDOTk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 10:19:40 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:52480 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727348AbfFDOSC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 10:18:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1DGih5hxjM3hCpgxfZAZGkcczMEB+Oahf4kiHIhmR2E=; b=Ky//m2eXiJBcCs/2J4EtdOqc2w
        E7LN8KMX95AIf83ZbgtbzdveDzOcaUOEShWQFXddiizhsOc8d7pbHZgUR4fFS48MjaZiahOK+bfPa
        axk6lD9bs79iH8MxysZSUA0/mzDHS8cw1XqQGIuJcs1bzNPzWGgdEXcsJr+K7f85thoN3WBE0W6CA
        +GNpNC5/WHwQSZ7nYepHqDm4AmlLt5FL0MhKOVne1Z+WDCYbO/enFEjEy/6i30jxkGAhUMRtyST7g
        ve79K78v6SHa9ej8KzZfMyQsKtf/Dzyu6oKpyp0XRmQqgZ8DLK0tqN6jYfwVrf7x/9trBY9e8gILc
        6r3qtJ5g==;
Received: from [179.182.172.34] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hYAGH-0001Rf-Th; Tue, 04 Jun 2019 14:18:01 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hYAGE-0002kj-Hw; Tue, 04 Jun 2019 11:17:58 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH v2 02/22] isdn: mISDN: remove a bogus reference to a non-existing doc
Date:   Tue,  4 Jun 2019 11:17:36 -0300
Message-Id: <be9340261bfd0d36c256a4ded49f67a68abaa4af.1559656538.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1559656538.git.mchehab+samsung@kernel.org>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The mISDN driver was added on those commits:

	960366cf8dbb ("Add mISDN DSP")
	1b2b03f8e514 ("Add mISDN core files")
	04578dd330f1 ("Define AF_ISDN and PF_ISDN")
	e4ac9bc1f668 ("Add mISDN driver")

None of them added a Documentation/isdn/mISDN.cert file.
Also, whatever were supposed to be written there on that time,
probably doesn't make any sense nowadays, as I doubt isdn would
have any massive changes.

So, let's just get rid of the broken reference, in order to
shut up a warning produced by ./scripts/documentation-file-ref-check.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
---
 drivers/isdn/mISDN/dsp_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/isdn/mISDN/dsp_core.c b/drivers/isdn/mISDN/dsp_core.c
index cd036e87335a..038e72a84b33 100644
--- a/drivers/isdn/mISDN/dsp_core.c
+++ b/drivers/isdn/mISDN/dsp_core.c
@@ -4,8 +4,6 @@
  *		Karsten Keil (keil@isdn4linux.de)
  *
  *		This file is (c) under GNU PUBLIC LICENSE
- *		For changes and modifications please read
- *		../../../Documentation/isdn/mISDN.cert
  *
  * Thanks to    Karsten Keil (great drivers)
  *              Cologne Chip (great chips)
-- 
2.21.0

