Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC6B23AF8
	for <lists+netdev@lfdr.de>; Mon, 20 May 2019 16:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392072AbfETOsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 May 2019 10:48:12 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35944 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392064AbfETOsL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 May 2019 10:48:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=1DGih5hxjM3hCpgxfZAZGkcczMEB+Oahf4kiHIhmR2E=; b=onQIg6gkOleo+RFzU6Yw8tugW5
        WD40+s9mPCUCJ/Lgzm9kthjA+RjmDAmTVGO7x+Ah7ywSQlthx2u4nYnESq4Mt5r4YtfVflhtImbyS
        wd5tkzZiVWy+YNVtq7JUGSXPWjO0rAnTXahhSjSux4LpAegNh+d2zZVZ7S6HfXZhMTmROM9XL7ZWW
        tJRpxUdydH/IhLt+3wztZcVr97ZRCCA2cT5pyMxuf3F/RxH3JgD4rJ5UiJ6WKLV/nDcPxoxq3pl7e
        Onh1SKsfCTqqVaIfxYOpvZ758nIWmSvfRUer8i5PF0a8UfExdEejywbSLpfzm2kqxnoDKFBCpGPx2
        S9dcw9qw==;
Received: from [179.176.119.151] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hSjaC-0000Us-Q9
        for netdev@vger.kernel.org; Mon, 20 May 2019 14:48:08 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1hSjZu-000113-GB; Mon, 20 May 2019 11:47:50 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org
Subject: [PATCH 06/10] isdn: mISDN: remove a bogus reference to a non-existing doc
Date:   Mon, 20 May 2019 11:47:35 -0300
Message-Id: <fc32252984b91ad726d6ee2845a71e204e9afe25.1558362030.git.mchehab+samsung@kernel.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <cover.1558362030.git.mchehab+samsung@kernel.org>
References: <cover.1558362030.git.mchehab+samsung@kernel.org>
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

