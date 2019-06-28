Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12C085A1DE
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 19:07:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726646AbfF1RHi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 13:07:38 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:36877 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726520AbfF1RHi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jun 2019 13:07:38 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hguLY-0002PZ-BV; Fri, 28 Jun 2019 19:07:36 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH 0/1] Disable all ports on b53 setup
Date:   Fri, 28 Jun 2019 18:58:10 +0200
Message-Id: <20190628165811.30964-1-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

while working on a Banana Pi R1 based system I faced inconsistent
switch configurations. The switch is attached to an EEPROM which feeds
additional configuration which is applied after the reset of the chip.

As a result all ports remained active while the DSA subsystem
assumed that those ports were inactive after the reset.
Disable the ports on switch setup to get a consistent view of things
between real life and DSA. 

Benedikt Spranger (1):
  net: dsa: b53: Disable all ports on setup

 drivers/net/dsa/b53/b53_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
2.20.1

