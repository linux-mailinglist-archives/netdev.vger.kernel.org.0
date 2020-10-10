Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E035728A244
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 00:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731302AbgJJW4F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Oct 2020 18:56:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731212AbgJJTxn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Oct 2020 15:53:43 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53AC9C08EA75;
        Sat, 10 Oct 2020 10:21:12 -0700 (PDT)
Received: from p548da7b6.dip0.t-ipconnect.de ([84.141.167.182] helo=kmk0.Speedport_W_724V_09011603_06_006); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1kRI10-0004hK-9c; Sat, 10 Oct 2020 18:46:38 +0200
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, kurt@linutronix.de,
        Kurt Kanzenbach <kurt@kmk-computers.de>
Subject: [PATCH net-next 0/2] dt-bindings: net: dsa: b53: Add YAML bindings
Date:   Sat, 10 Oct 2020 18:46:25 +0200
Message-Id: <20201010164627.9309-1-kurt@kmk-computers.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1602350472;5eb50426;
X-HE-SMSGID: 1kRI10-0004hK-9c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

the DSA device tree bindings have been converted to YAML. Let's start
using them. Convert the b53 bindings as suggested by Florian Fainelli.

Kurt Kanzenbach (2):
  dt-bindings: net: dsa: b53: Add YAML bindings
  dt-bindings: net: dsa: b53: Drop old bindings

 .../devicetree/bindings/net/dsa/b53.txt       | 149 -----------
 .../devicetree/bindings/net/dsa/b53.yaml      | 249 ++++++++++++++++++
 MAINTAINERS                                   |   2 +-
 3 files changed, 250 insertions(+), 150 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/net/dsa/b53.txt
 create mode 100644 Documentation/devicetree/bindings/net/dsa/b53.yaml

-- 
2.26.2

