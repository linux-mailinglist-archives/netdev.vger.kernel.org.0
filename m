Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B44205C0A5
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 17:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfGAPvh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 11:51:37 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:41747 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727373AbfGAPvh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 11:51:37 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hhyad-0002lb-C3; Mon, 01 Jul 2019 17:51:35 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH v2 0/2] Document the configuration of b53
Date:   Mon,  1 Jul 2019 17:42:07 +0200
Message-Id: <20190701154209.27656-1-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

this is the second RFC to document the configuration of a b53 supported
switch.

Thanks for the comments.

Regards
    Bene Spranger

v1..v2:
- split out generic parts of the configuration.
- target comments by Andrew Lunn and Florian Fainelli.
- make changes visible to build system

Benedikt Spranger (2):
  Documentation: net: dsa: Describe DSA switch configuration
  Documentation: net: dsa: b53: Describe b53 configuration

 Documentation/networking/dsa/b53.rst          | 174 +++++++++++
 .../networking/dsa/configuration.rst          | 292 ++++++++++++++++++
 Documentation/networking/dsa/index.rst        |   2 +
 3 files changed, 468 insertions(+)
 create mode 100644 Documentation/networking/dsa/b53.rst
 create mode 100644 Documentation/networking/dsa/configuration.rst

-- 
2.20.1

