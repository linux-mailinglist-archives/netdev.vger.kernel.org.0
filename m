Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF402C5874
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391301AbgKZPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:47:14 -0500
Received: from guitar.tcltek.co.il ([192.115.133.116]:42704 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbgKZPrO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 10:47:14 -0500
X-Greylist: delayed 588 seconds by postgrey-1.27 at vger.kernel.org; Thu, 26 Nov 2020 10:47:13 EST
Received: from tarshish (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id BAE7A440439;
        Thu, 26 Nov 2020 17:37:22 +0200 (IST)
User-agent: mu4e 1.4.13; emacs 27.1
From:   Baruch Siach <baruch@tkos.co.il>
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Get MAC supported link modes for SFP port
Date:   Thu, 26 Nov 2020 17:37:22 +0200
Message-ID: <87pn40uo25.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi netdev list,

I am trying to retrieve all MAC supported link modes
(ETHTOOL_LINK_MODE_*) for network interfaces with SFP port. The
'supported' bit mask that ETHTOOL_GLINKSETTINGS provides in
link_mode_masks[] changes to match the SFP module that happens to be
plugged in. When no SFP module is plugged, the bit mask looks
meaningless.

I understand that ETHTOOL_LINK_MODE_* bits are meant to describe PHY
level capabilities. So I would settle for a MAC level "supported rates"
list.

Is there anything like that?

Thanks,
baruch

-- 
                                                     ~. .~   Tk Open Systems
=}------------------------------------------------ooO--U--Ooo------------{=
   - baruch@tkos.co.il - tel: +972.52.368.4656, http://www.tkos.co.il -
