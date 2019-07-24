Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC0F73239
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 16:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbfGXOwg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 10:52:36 -0400
Received: from node.akkea.ca ([192.155.83.177]:58462 "EHLO node.akkea.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726422AbfGXOwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 10:52:36 -0400
Received: from localhost (localhost [127.0.0.1])
        by node.akkea.ca (Postfix) with ESMTP id 9FD424E2010;
        Wed, 24 Jul 2019 14:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1563979955; bh=+2e6JvgeBJMYL6tuzdR0QNS5B6RGy+3p+M0wb5aTC+8=;
        h=From:To:Cc:Subject:Date;
        b=waFQTHr1Yg8fj0ck5KBtd4B4akQsnqM2x9n84mzsuLcH0v2FN7IjE/JHFAvmUvNKn
         khj++FFvgxLJMfKELQkB4N9ypDMZ8jOZvZnXazaauhtlvjhFvS4lCsGUZa6r+cTzGY
         QTZuLQ7csi1bmHmINYI75ZAcKM16FL4hckGkPqFc=
X-Virus-Scanned: Debian amavisd-new at mail.akkea.ca
Received: from node.akkea.ca ([127.0.0.1])
        by localhost (mail.akkea.ca [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id pm5yXsXOHYYl; Wed, 24 Jul 2019 14:52:35 +0000 (UTC)
Received: from midas.localdomain (S0106788a2041785e.gv.shawcable.net [70.66.86.75])
        by node.akkea.ca (Postfix) with ESMTPSA id D8A874E2003;
        Wed, 24 Jul 2019 14:52:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akkea.ca; s=mail;
        t=1563979955; bh=+2e6JvgeBJMYL6tuzdR0QNS5B6RGy+3p+M0wb5aTC+8=;
        h=From:To:Cc:Subject:Date;
        b=waFQTHr1Yg8fj0ck5KBtd4B4akQsnqM2x9n84mzsuLcH0v2FN7IjE/JHFAvmUvNKn
         khj++FFvgxLJMfKELQkB4N9ypDMZ8jOZvZnXazaauhtlvjhFvS4lCsGUZa6r+cTzGY
         QTZuLQ7csi1bmHmINYI75ZAcKM16FL4hckGkPqFc=
From:   "Angus Ainslie (Purism)" <angus@akkea.ca>
To:     kernel@puri.sm
Cc:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Angus Ainslie (Purism)" <angus@akkea.ca>
Subject: [PATCH 0/2] Add the BroadMobi BM818 card
Date:   Wed, 24 Jul 2019 07:52:25 -0700
Message-Id: <20190724145227.27169-1-angus@akkea.ca>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add qmi_wwan and option support for the BroadMobi BM818

Bob Ham (2):
  usb: serial: option: Add the BroadMobi BM818 card
  net: usb: qmi_wwan: Add the BroadMobi BM818 card

 drivers/net/usb/qmi_wwan.c  | 1 +
 drivers/usb/serial/option.c | 2 ++
 2 files changed, 3 insertions(+)

-- 
2.17.1

