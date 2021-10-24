Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6F4B438AAB
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 18:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbhJXQkz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 12:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbhJXQky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 12:40:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0FDCC061745;
        Sun, 24 Oct 2021 09:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=6rqwAQVcU8RExEBYpubo8y6lp6GJZjUyOLdqH6wO3Vk=; b=MneYuI2kba1XYlk9jQgeZS5iuN
        WVvINjk2mgJEgaj0y3QREf6td9W09vC5L30vbtNVkoZIVpjuBEmaFbQfo3CaVTyGRcABczKJm81eY
        cK2yHaGZVIfbdbCs3QjPJUuhpI1P3Bvnwqon+LAC8RN6RhGwJePD8+ld5WbCXX0JjivwW7DVzKNbY
        kd4d7v6iLtbWbl51p8yy4livNZfrcETqOeHv0UBC1RwoptPrZ7U/K2MsfHHtXfIO01vmBP3EEkLag
        2WcD6O7ToRJApRBPHcu/P8QzYYLI3JvpLsg298FOcVghlDKenzyYz9SFS5AFlMXhUgvI0nhMjeccO
        j0UZGQ5Q==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1megW0-00ELkE-TH; Sun, 24 Oct 2021 16:38:33 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Richard Cochran <richardcochran@gmail.com>,
        John Stultz <john.stultz@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Subject: [PATCH] ptp: Document the PTP_CLK_MAGIC ioctl number
Date:   Sun, 24 Oct 2021 09:38:31 -0700
Message-Id: <20211024163831.10200-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add PTP_CLK_MAGIC to the userspace-api/ioctl/ioctl-number.rst
documentation file.

Fixes: d94ba80ebbea ("ptp: Added a brand new class driver for ptp clocks.")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: John Stultz <john.stultz@linaro.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>
Cc: linux-doc@vger.kernel.org
---
Richard- do you want to adjust the range (0x0 - 0x3f) to
something else?

 Documentation/userspace-api/ioctl/ioctl-number.rst |    1 +
 1 file changed, 1 insertion(+)

--- linux-next-20211022.orig/Documentation/userspace-api/ioctl/ioctl-number.rst
+++ linux-next-20211022/Documentation/userspace-api/ioctl/ioctl-number.rst
@@ -105,6 +105,7 @@ Code  Seq#    Include File
 '8'   all                                                            SNP8023 advanced NIC card
                                                                      <mailto:mcr@solidum.com>
 ';'   64-7F  linux/vfio.h
+'='   00-3f  uapi/linux/ptp_clock.h                                  <mailto:richardcochran@gmail.com>
 '@'   00-0F  linux/radeonfb.h                                        conflict!
 '@'   00-0F  drivers/video/aty/aty128fb.c                            conflict!
 'A'   00-1F  linux/apm_bios.h                                        conflict!
