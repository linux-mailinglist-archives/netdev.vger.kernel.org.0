Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50C8A106735
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 08:43:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfKVHnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 02:43:45 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:52207 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726620AbfKVHnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 02:43:45 -0500
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=leda.hi.pengutronix.de)
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <rsc@pengutronix.de>)
        id 1iY3bS-0002i6-0Q; Fri, 22 Nov 2019 08:43:42 +0100
Received: by leda.hi.pengutronix.de (Postfix, from userid 1006)
        id DB1B02C877E4; Fri, 22 Nov 2019 08:43:40 +0100 (CET)
From:   Robert Schwebel <r.schwebel@pengutronix.de>
To:     "David S. Miller" <davem@davemloft.net>
Cc:     Robert Schwebel <r.schwebel@pengutronix.de>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH v2 0/5] docs: networking: nfc: convert from txt to rst
Date:   Fri, 22 Nov 2019 08:43:01 +0100
Message-Id: <20191122074306.78179-1-r.schwebel@pengutronix.de>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: rsc@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

here is v2 of the series converting the NFC documentation from txt to
rst. Thanks to Jonathan and Dave for the input.

Changes since (implicit) v1:

* replace code-block by more compact :: syntax

* really add the rst file to the index

rsc
