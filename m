Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5363C15C077
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727578AbgBMOhe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:37:34 -0500
Received: from smtp1.axis.com ([195.60.68.17]:13346 "EHLO smtp1.axis.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726282AbgBMOhe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 09:37:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=axis.com; l=502; q=dns/txt; s=axis-central1;
  t=1581604654; x=1613140654;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=U3Okkilu6fqsJwbzxSkLVie4dKySsyeQ+EUUYAthcbE=;
  b=neYryCKIujhOqSL9plosPVQUMdlGLtydGf5RYNgdAaLepJF5w6ibQMaS
   fHM69YKaOw28jm0Q4ELndL2wfbUOORGQhW68V5udyPMgOsjjicdlFlJpZ
   xZCB0wrkPOrdm9KX8io2blefoe5P7uZX5A3ecRORnuTGW4By4vY6kYrJN
   eSzRmuLAlGabJkXdtU6ypNS4iFFEwJxhLgn25hBA1+678moRlNHKXo9Y+
   536q3/GtGXq96I/QJejsa7cSu8mFU4Z7Di1d6u+6Rh1QNuRBpVqYMV3Fd
   dZPSo9U8ZBsXiStepwHhWhjHhY9rCM1FqNrFANJR58hfXG/99hnfKfw4t
   w==;
IronPort-SDR: LbDU6wkfFRNqb2qL/FruFC8DIC9Z/ll9vSNT0xNPgW/kCPTWY/44UY/aOB4qgNktLuGJgUMH6h
 eYm+C0XdBhRiWxwpCTeVpaMWyZcVINyRrve/m7dKUwDIrDridNbdLLqZ8FNPC6EhuH3jRxAUgm
 t4K3I+6YUN+5NDKObzI+EmwIjrzpvXuCUxhaD+WNit/zq+J+jUyFCdotoKSslZcM6Lyi0u8vdo
 1wXcuBj7DdbclETP4RMCk11UQZkoyJbzkfDy875JrPZo9F7RoOuo4vIs4VYomjYCX0rXP/NffN
 KPo=
X-IronPort-AV: E=Sophos;i="5.70,437,1574118000"; 
   d="scan'208";a="5391017"
From:   Per Forlin <per.forlin@axis.com>
To:     <netdev@vger.kernel.org>, <andrew@lunn.ch>,
        <o.rempel@pengutronix.de>, <davem@davemloft.net>
CC:     Per Forlin <per.forlin@axis.com>
Subject: [PATCH net 0/2] net: dsa: Make sure there is headroom for tag
Date:   Thu, 13 Feb 2020 15:37:08 +0100
Message-ID: <20200213143710.22811-1-per.forlin@axis.com>
X-Mailer: git-send-email 2.11.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sorry for re-posting yet another time....
I manage to include multiple email-senders and forgot to include cover-letter.
Let's hope everyhthing is in order this time.

Fix two tag drivers to make sure there is headroom for the tag data.

Per Forlin (2):
  net: dsa: tag_qca: Make sure there is headroom for tag
  net: dsa: tag_ar9331: Make sure there is headroom for tag

 net/dsa/tag_ar9331.c | 2 +-
 net/dsa/tag_qca.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.11.0

