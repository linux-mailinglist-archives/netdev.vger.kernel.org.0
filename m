Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC4ECFDC5
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 17:39:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727835AbfJHPjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 11:39:09 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:56306 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfJHPjJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 11:39:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=gQ6yim/mQFooQMeP/zNoWTmRo6Z0q2Fo7+0BkS2ADW8=; b=DIs2aEC0JjMlCqmk42tU/gadH
        fvYKfkxnjhAihwig0aqg82AYkTcXgIWEVo+hoM6pvcGQCbM1Rl3OGnVPAKfRQobFc9vH520Gdu2Rn
        WGFtihPJg6/yVeoPYGy6ap85kxeLWLY4TUx4g7fL6zsdlTERTsQPuRmTDZ9VGy4l+9gPC4KgEUu/q
        AC5TQM2o32HNEO1GAHtIyxW2S95rVNAAa7xixmcU/MjW0Gl6Jkl4wZmeEl1a0sEwBS8M4TAeElKHI
        qStCOfzeu7T1uswwMIQ4aob1OHaUZpF/vAdfnTW+8UcO+x/IAsERuHFylChuwHWSMGDfIiSsq89/6
        FOqtQCl3Q==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iHrZr-0005Mg-T6; Tue, 08 Oct 2019 15:39:07 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH -net] phylink: fix kernel-doc warnings
Message-ID: <9e756330-80b0-e613-c9df-85b58af064c9@infradead.org>
Date:   Tue, 8 Oct 2019 08:39:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Fix kernel-doc warnings in phylink.c:

../drivers/net/phy/phylink.c:595: warning: Function parameter or member 'config' not described in 'phylink_create'
../drivers/net/phy/phylink.c:595: warning: Excess function parameter 'ndev' description in 'phylink_create'

Fixes: 8796c8923d9c ("phylink: add documentation for kernel APIs")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Russell King <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/phylink.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20191008.orig/drivers/net/phy/phylink.c
+++ linux-next-20191008/drivers/net/phy/phylink.c
@@ -576,7 +576,7 @@ static int phylink_register_sfp(struct p
 
 /**
  * phylink_create() - create a phylink instance
- * @ndev: a pointer to the &struct net_device
+ * @config: a pointer to the target &struct phylink_config
  * @fwnode: a pointer to a &struct fwnode_handle describing the network
  *	interface
  * @iface: the desired link mode defined by &typedef phy_interface_t


