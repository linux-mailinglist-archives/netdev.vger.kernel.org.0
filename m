Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C1F49F821
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 12:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348145AbiA1LUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 06:20:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348138AbiA1LUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 06:20:09 -0500
Received: from relay11.mail.gandi.net (relay11.mail.gandi.net [IPv6:2001:4b98:dc4:8::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 609FAC061714;
        Fri, 28 Jan 2022 03:20:08 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 88878100008;
        Fri, 28 Jan 2022 11:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1643368806;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=4nv991dysX9iy3/kfE7r4VZ21Vrlg+JMIFLIIetOjCg=;
        b=c9ZU6Tl2i2lSiQAjTCUd4NK0SckfEeUBxcCoq+WXQiqhq8n0U1OcP98FuHhNyVp9DnE5QW
        cgFilRfdVHKbdqVjCCRMsti/CNznJDPOzomvCZwqQGd+4FWwCFVu5gIAT8Q/9GgNqExN+/
        DEgUlOuoSCDAjCRcEV+31pxod4Vdd9ypwMbbslzrhXH6whPWHKNxlud9ugMRZzrrVwJQcI
        bH67sJ+VkVCVF1/sgB0uLd/vU3ajQOrl4gxsHg+MBSR8bqDA3bDWWIqxDMA5l1ltD+E0iU
        sT0GqPv/SfxJeWTXkovAS6ykOaY3o/PrPAaiccO8zZJKuWhdaE9RHhQxUn3gEw==
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH wpan-next v2 0/2] ieee802154: Internal moves
Date:   Fri, 28 Jan 2022 12:20:00 +0100
Message-Id: <20220128112002.1121320-1-miquel.raynal@bootlin.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I am sending just a couple of patches from David that can easily be
reviewed outside of any other big patch series:
* reorder a bit the Kconfig entries
* move the ieee802154_addr structure and give it a kdoc before using it
  in the scan procedure.

Changes since v1:
* There were four patches merged into two as advised by Stefan.

David Girault (2):
  net: ieee802154: Move the IEEE 802.15.4 Kconfig main entries
  net: ieee802154: Move the address structure earlier and provide a kdoc

 include/net/cfg802154.h | 28 +++++++++++++++++++---------
 net/Kconfig             |  3 +--
 net/ieee802154/Kconfig  |  1 +
 3 files changed, 21 insertions(+), 11 deletions(-)

-- 
2.27.0

