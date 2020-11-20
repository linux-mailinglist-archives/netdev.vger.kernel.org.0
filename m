Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D42042BA4E7
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 09:43:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727241AbgKTImI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 03:42:08 -0500
Received: from mailout04.rmx.de ([94.199.90.94]:51677 "EHLO mailout04.rmx.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727120AbgKTImH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 03:42:07 -0500
Received: from kdin02.retarus.com (kdin02.dmz1.retloc [172.19.17.49])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mailout04.rmx.de (Postfix) with ESMTPS id 4CcqmD2twdz3qyY7;
        Fri, 20 Nov 2020 09:42:04 +0100 (CET)
Received: from mta.arri.de (unknown [217.111.95.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by kdin02.retarus.com (Postfix) with ESMTPS id 4Ccqlz5Hm5z2TTN8;
        Fri, 20 Nov 2020 09:41:51 +0100 (CET)
Received: from N95HX1G2.wgnetz.xx (192.168.54.143) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.487.0; Fri, 20 Nov
 2020 09:41:28 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Richard Cochran <richardcochran@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
CC:     Vladimir Oltean <olteanv@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Christian Eggers <ceggers@arri.de>
Subject: [PATCH net-next v3 0/3] net: ptp: introduce common defines for PTP message types
Date:   Fri, 20 Nov 2020 09:41:03 +0100
Message-ID: <20201120084106.10046-1-ceggers@arri.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [192.168.54.143]
X-RMX-ID: 20201120-094153-4Ccqlz5Hm5z2TTN8-0@kdin02
X-RMX-SOURCE: 217.111.95.66
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series introduces commen defines for PTP event messages. Driver
internal defines are removed and some uses of magic numbers are replaced
by the new defines.

Changes v2 --> v3
------------------
- extend commit description for ptp_ines (Jacob Keller)

Changes v1 --> v2
------------------
- use defines instead of an enum (Richard Cochran)
- no changes necessary for dp63640
- add cover message (Vladimir Oltean)


