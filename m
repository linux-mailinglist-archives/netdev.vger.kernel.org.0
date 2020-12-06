Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43EC2D0526
	for <lists+netdev@lfdr.de>; Sun,  6 Dec 2020 14:31:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbgLFN3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Dec 2020 08:29:16 -0500
Received: from mx4.wp.pl ([212.77.101.12]:58883 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728090AbgLFN3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 6 Dec 2020 08:29:16 -0500
Received: (wp-smtpd smtp.wp.pl 18659 invoked from network); 6 Dec 2020 14:28:23 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1607261303; bh=sx2fzwL1jcfITdolBuLJdyJVDYxWzjICd6Jsg4qoxIo=;
          h=From:To:Cc:Subject;
          b=xXqM5Jb4uxKfNPH2U9f/cqdKVB10S372YgKHWsdMP4QkrfJDJ/b2TE3UwEfjmE0kp
           VebM3sYdUBEnRINzUP0G+x3BHsRrIOBn8s3546A19djrxoXSq5U3DyiasDn0L8E4VI
           55WYDKgUPW21HxWhps6DCxbt4fhVUh1jNrHwAlGE=
Received: from riviera.nat.student.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 6 Dec 2020 14:28:23 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>
Subject: [PATCH v2 0/2] net: dsa: lantiq: add support for xRX300 and xRX330
Date:   Sun,  6 Dec 2020 14:27:11 +0100
Message-Id: <20201206132713.13452-1-olek2@wp.pl>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 5f98f602c9ef924e1a994ca9191ecf5f
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [IQLy]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aleksander Jan Bajkowski <A.Bajkowski@stud.elka.pw.edu.pl>

Changed since v1:
	* gswip_mii_mask_cfg() can now change port 3 on xRX330
	* changed alowed modes on port 0 and 5 for xRX300 and xRX330
	* moved common part of phylink validation into gswip_phylink_set_capab()
	* verify the compatible string against the hardware

Aleksander Jan Bajkowski (2):
  net: dsa: lantiq: allow to use all GPHYs on xRX300 and xRX330
  dt-bindings: net: dsa: lantiq, lantiq-gswip: add example for xRX330

 .../bindings/net/dsa/lantiq-gswip.txt         | 110 +++++++++++-
 drivers/net/dsa/lantiq_gswip.c                | 170 +++++++++++++++---
 2 files changed, 250 insertions(+), 30 deletions(-)

-- 
2.20.1

