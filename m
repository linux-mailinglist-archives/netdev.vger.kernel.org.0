Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B84839260
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 18:42:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731007AbfFGQmr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 12:42:47 -0400
Received: from sed198n136.SEDSystems.ca ([198.169.180.136]:40367 "EHLO
        sed198n136.sedsystems.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730192AbfFGQmr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 12:42:47 -0400
Received: from barney.sedsystems.ca (barney [198.169.180.121])
        by sed198n136.sedsystems.ca  with ESMTP id x57GgfK5004730
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Fri, 7 Jun 2019 10:42:41 -0600 (CST)
Received: from SED.RFC1918.192.168.sedsystems.ca (eng1n65.eng.sedsystems.ca [172.21.1.65])
        by barney.sedsystems.ca (8.14.7/8.14.4) with ESMTP id x57GgeOk030818
        (version=TLSv1/SSLv3 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 7 Jun 2019 10:42:40 -0600
From:   Robert Hancock <hancock@sedsystems.ca>
To:     netdev@vger.kernel.org
Cc:     linux@armlinux.org.uk, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, Robert Hancock <hancock@sedsystems.ca>
Subject: [PATCH net-next 0/2] SFP polling fixes
Date:   Fri,  7 Jun 2019 10:42:34 -0600
Message-Id: <1559925756-29593-1-git-send-email-hancock@sedsystems.ca>
X-Mailer: git-send-email 1.8.3.1
X-Scanned-By: MIMEDefang 2.64 on 198.169.180.136
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This has an updated version of an earlier patch to ensure that SFP
operations are stopped during shutdown, and another patch suggested by
Russell King to address a potential concurrency issue with SFP state
checks.

Robert Hancock (2):
  net: sfp: Stop SFP polling and interrupt handling during shutdown
  net: sfp: add mutex to prevent concurrent state checks

 drivers/net/phy/sfp.c | 37 +++++++++++++++++++++++++++++++------
 1 file changed, 31 insertions(+), 6 deletions(-)

-- 
1.8.3.1

