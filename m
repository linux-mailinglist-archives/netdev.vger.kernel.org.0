Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8B6176E6D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 06:11:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCCFLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 00:11:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgCCFLI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 00:11:08 -0500
Received: from kicinski-fedora-PC1C0HJN.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C2E5C20CC7;
        Tue,  3 Mar 2020 05:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583212268;
        bh=MSJlZzIsWKJk63l9OvPUH4wPGhMhw5K1TXo0SLcMGAg=;
        h=From:To:Cc:Subject:Date:From;
        b=p3yMKhF8o7ayhU2/Yht9GzAzJxQoPD+uNMK2ljUOwGKA4uLANSG0DWmAw2txI2YUx
         /+gGJ3E0EKg0aUvduLpkutVJBUiUsqIdhTHsLQy6DtfjkgnNfDVVDwfRq+4xrPSVXk
         lezP1cM3nk/FV5RpZRp6l4HLl6k62Gkja9McxjJQ=
From:   Jakub Kicinski <kuba@kernel.org>
To:     johannes@sipsolutions.net
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        kvalo@codeaurora.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH wireless 0/3] nl80211: add missing attribute validation
Date:   Mon,  2 Mar 2020 21:10:55 -0800
Message-Id: <20200303051058.4089398-1-kuba@kernel.org>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Wireless seems to be missing a handful of netlink policy entries.

Compilation tested only.

Jakub Kicinski (3):
  nl80211: add missing attribute validation for critical protocol
    indication
  nl80211: add missing attribute validation for beacon report scanning
  nl80211: add missing attribute validation for channel switch

 net/wireless/nl80211.c | 5 +++++
 1 file changed, 5 insertions(+)

-- 
2.24.1

