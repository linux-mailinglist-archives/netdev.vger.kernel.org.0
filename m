Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C361958026
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 12:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726566AbfF0KYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 06:24:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:52951 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726187AbfF0KYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 06:24:24 -0400
Received: from [5.158.153.52] (helo=mitra.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <b.spranger@linutronix.de>)
        id 1hgRZm-0007Wg-2T; Thu, 27 Jun 2019 12:24:22 +0200
From:   Benedikt Spranger <b.spranger@linutronix.de>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [RFC PATCH 0/1] Document the configuration of b53
Date:   Thu, 27 Jun 2019 12:15:05 +0200
Message-Id: <20190627101506.19727-1-b.spranger@linutronix.de>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
References: <39b134ed-9f3e-418a-bf26-c1e716018e7e@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

my comment about the configuration got misunderstood.
I apologize for that.

I try to update the Debian ifupdown util to handle DSA capable
configurations. To avoid bafflement and frayed nerves I would like to get
some conclusion about the configuration of the b53. I would like to know
if this configuration can be expected to be expected to remain unchanged,
or if some parts need to be handled with more or special care.

Please consider this patch as starting/discussion point to get a quotable
reference in the kernel documentation.

This reference would ease the development and justification to upstream
changes to tools like ifupdown.

Regards
    Bene Spranger

Benedikt Spranger (1):
  Documentation: net: dsa: b53: Describe b53 configuration

 Documentation/networking/dsa/b53.rst | 300 +++++++++++++++++++++++++++
 1 file changed, 300 insertions(+)
 create mode 100644 Documentation/networking/dsa/b53.rst

-- 
2.20.1

