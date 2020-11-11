Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 190592AF17E
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 14:05:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726817AbgKKNFR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 08:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726692AbgKKNFO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 08:05:14 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38645C0613D1
        for <netdev@vger.kernel.org>; Wed, 11 Nov 2020 05:05:11 -0800 (PST)
Received: from heimdall.vpn.pengutronix.de ([2001:67c:670:205:1d::14] helo=blackshift.org)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1kcpoE-000306-Ab; Wed, 11 Nov 2020 14:05:10 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de, linux-arm-kernel@lists.infradead.org,
        Shawn Guo <shawnguo@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: pull-request: can 2020-11-11
Date:   Wed, 11 Nov 2020 14:05:03 +0100
Message-Id: <20201111130507.1560881-1-mkl@pengutronix.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <[net v2 0/4] arm: imx: flexcan: fix yaml bindings and DTs>
References: <[net v2 0/4] arm: imx: flexcan: fix yaml bindings and DTs>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:205:1d::14
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

after v5.10-rc1 the flexcan bindings were converted to yaml. This causes
several unneeded regressions on i.MX53 based boards and/or SoC specifying the
fsl,stop-mode property in their flexcan node.

This series fixes these problems by first updating the affected i.MX SoC dtsi
files and then fixing the flexcan yaml binding.

After I got the OK from the DT and fsl people, the plan is to upstream this via
net/master. If this is not an option, I'll send individual patches.

I've marked the servies das v2, as I accidentally sent out a work-in-progress
state of this series.

regards,
Marc


