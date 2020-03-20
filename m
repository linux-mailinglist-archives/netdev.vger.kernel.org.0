Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 04FFD18CF58
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 14:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727113AbgCTNsO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 09:48:14 -0400
Received: from wp148.webpack.hosteurope.de ([80.237.132.155]:44608 "EHLO
        wp148.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726843AbgCTNsO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 09:48:14 -0400
X-Greylist: delayed 1797 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Mar 2020 09:48:13 EDT
Received: from p5097d022.dip0.t-ipconnect.de ([80.151.208.34] helo=[10.41.80.32]); authenticated
        by wp148.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1jFHXT-0008CH-Hj; Fri, 20 Mar 2020 14:18:15 +0100
From:   Roelof Berg <rberg@berg-solutions.de>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0 (Mac OS X Mail 13.0 \(3608.60.0.2.5\))
Subject: Is my patch interesting for contribution: FixedPHY support for
 Microchip LAN743x ?
Message-Id: <DD2042A5-68EA-40A1-A4A9-5A1DCE4F9583@berg-solutions.de>
Date:   Fri, 20 Mar 2020 14:18:14 +0100
To:     netdev@vger.kernel.org
X-Mailer: Apple Mail (2.3608.60.0.2.5)
X-bounce-key: webpack.hosteurope.de;rberg@berg-solutions.de;1584712093;94169b7a;
X-HE-SMSGID: 1jFHXT-0008CH-Hj
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Kernel-Heros,

for our custom PCB I added FixedPHY support to the Microchip lan743x driver. This allows running a combination of lan7431 (MAC) and Microchip ksz9893 (switch) via a direct MII connection, i.e. without any PHYs in between. The .config determines wether (and how) FixedPHY is used, and the patch has 100%ly no (side-)effect in the default setting.

Is such a patch interesting for the community ?

Pro:
+ Supports lan7431<->kaz9893, a cost effective way of doing: PCIe<->2x-RJ45
+ Tested
+ Can be a grep-template for others with the same issue, i.e. adding FixedPHY to their driver

Con:
- Maybe a more general approach would be better, that allows connecting any driver to a FixedPhy ? Insread of every driver doing its own thing ?

Thanks, best regards,
Roelof Berg
www.berg-solutions.de

