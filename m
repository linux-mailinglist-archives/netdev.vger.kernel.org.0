Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84BA71024CB
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 13:45:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727797AbfKSMpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 07:45:13 -0500
Received: from pandora.armlinux.org.uk ([78.32.30.218]:51148 "EHLO
        pandora.armlinux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbfKSMpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 07:45:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:To:From:Date:Reply-To:Cc:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=JBlRb/8MDgbJJP/2nmVYv4M/saunhT5xhdbyTfZYaSg=; b=ymn4LgCRWJtnfJU82qwKDcPw2
        l88KDAoRRsx89dgXY/n+83d5QhFC2AoB9GCwWSF51H8bhKIQMiVQgqVS8Xw6mMacX1pnDiHZQG2L1
        Fg0sls9C+mROmx+xzAiUuCyHaZqn/+gY8AMxg+lGEpJZpKiDFE9Dy9r0k5ghK70zH0l2Vu0ORi+xH
        Fj6fZPfB0jH1QekKMAULEapxFX5gR1evIfaP03pJlC2Fk5F7qyLarB2qwljQm2130t8CDwW4+Wqv/
        cytPkiQzR3dXLn1APSiOmNP5PyMxEuJscAOhGRqH6xgVEMfbbg7YKLEzV9Bu4n/ZhoopeWnMq0oo9
        EkpdViHXg==;
Received: from shell.armlinux.org.uk ([2002:4e20:1eda:1:5054:ff:fe00:4ec]:37574)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1iX2sX-0001LK-Lk; Tue, 19 Nov 2019 12:45:09 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1iX2sU-0000jf-IG; Tue, 19 Nov 2019 12:45:06 +0000
Date:   Tue, 19 Nov 2019 12:45:06 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     netdev@vger.kernel.org, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>
Subject: Felix Fietkau email address become stale?
Message-ID: <20191119124506.GC25745@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

  nbd@openwrt.org
    host util-01.infra.openwrt.org [2a03:b0c0:3:d0::175a:2001]
    SMTP error from remote mail server after RCPT TO:<nbd@openwrt.org>:
    550 Unrouteable address

which was triggered due to MAINTAINERS saying:

MEDIATEK ETHERNET DRIVER
M:      Felix Fietkau <nbd@openwrt.org>
M:      John Crispin <john@phrozen.org>
M:      Sean Wang <sean.wang@mediatek.com>
M:      Mark Lee <Mark-MC.Lee@mediatek.com>

Does Felix's address need updating or removing?

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 12.1Mbps down 622kbps up
According to speedtest.net: 11.9Mbps down 500kbps up
