Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F79BF7386
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 13:03:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726957AbfKKMDQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 07:03:16 -0500
Received: from inva020.nxp.com ([92.121.34.13]:32774 "EHLO inva020.nxp.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726810AbfKKMDQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 07:03:16 -0500
Received: from inva020.nxp.com (localhost [127.0.0.1])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9D1E31A08D9;
        Mon, 11 Nov 2019 13:03:14 +0100 (CET)
Received: from inva024.eu-rdc02.nxp.com (inva024.eu-rdc02.nxp.com [134.27.226.22])
        by inva020.eu-rdc02.nxp.com (Postfix) with ESMTP id 9124A1A0626;
        Mon, 11 Nov 2019 13:03:14 +0100 (CET)
Received: from fsr-fed2164-101.ea.freescale.net (fsr-fed2164-101.ea.freescale.net [10.171.82.91])
        by inva024.eu-rdc02.nxp.com (Postfix) with ESMTP id 49FC9205FE;
        Mon, 11 Nov 2019 13:03:14 +0100 (CET)
From:   Madalin Bucur <madalin.bucur@nxp.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net,
        Madalin Bucur <madalin.bucur@nxp.com>
Subject: [PATCH net-next 0/2] dpaa_eth documentation updates
Date:   Mon, 11 Nov 2019 14:03:10 +0200
Message-Id: <1573473792-17797-1-git-send-email-madalin.bucur@nxp.com>
X-Mailer: git-send-email 2.1.0
Content-Type: text/plain; charset="us-ascii"
Reply-to: madalin.bucur@nxp.com
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Documentation updates for the DPAA Ethernet driver

Madalin Bucur (2):
  Documentation: networking: dpaa_eth: adjust buffer pool info
  Documentation: networking: dpaa_eth: adjust sysfs paths

 Documentation/networking/device_drivers/freescale/dpaa.txt | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

-- 
2.1.0

