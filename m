Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E29F215CB0F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 20:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728389AbgBMTUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 14:20:47 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:41173 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgBMTUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 14:20:46 -0500
Received: from mwalle01.sab.local. (unknown [213.135.10.150])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 43FE722EC1;
        Thu, 13 Feb 2020 20:20:44 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1581621644;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2RmaQGm0lvaaZdyi8J9DphOhSthl4nnUcKDIYeJnHSs=;
        b=bbAFM5yrzt4spPAwGOx4Fjd9FU61WlN/rRyV7C/aP3n9B68WGuZTx340zmmDBFfaHpk+sC
        /zDZ/xvenz8gnu1pzGz3X2BUijN5SArfeVcZM91v/xweVg0ZVoI1RFIS9AZ2YaC5ympYZE
        1c3Ejna7RhSJoN9XjreUgzS4iNOCZ7Y=
From:   Michael Walle <michael@walle.cc>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, wg@grandegger.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org,
        Pankaj Bansal <pankaj.bansal@nxp.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 0/8] can: flexcan: add CAN FD support for NXP Flexcan
Date:   Thu, 13 Feb 2020 20:20:27 +0100
Message-Id: <20200213192027.4813-1-michael@walle.cc>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
References: <24eb5c67-4692-1002-2468-4ae2e1a6b68b@pengutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Bar: ++++
X-Spam-Level: ****
X-Rspamd-Server: web
X-Spam-Status: No, score=4.90
X-Spam-Score: 4.90
X-Rspamd-Queue-Id: 43FE722EC1
X-Spamd-Result: default: False [4.90 / 15.00];
         FROM_HAS_DN(0.00)[];
         TO_DN_SOME(0.00)[];
         R_MISSING_CHARSET(2.50)[];
         TO_MATCH_ENVRCPT_ALL(0.00)[];
         MIME_GOOD(-0.10)[text/plain];
         BROKEN_CONTENT_TYPE(1.50)[];
         DKIM_SIGNED(0.00)[];
         RCPT_COUNT_SEVEN(0.00)[7];
         MID_CONTAINS_FROM(1.00)[];
         NEURAL_HAM(-0.00)[-0.414];
         RCVD_COUNT_ZERO(0.00)[0];
         FROM_EQ_ENVFROM(0.00)[];
         MIME_TRACE(0.00)[0:+];
         ASN(0.00)[asn:12941, ipnet:213.135.0.0/19, country:DE]
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

>>> Are you prepared to add back these patches as they are necessary for
>>> Flexcan CAN FD? And this Flexcan CAN FD patch set is based on these
>>> patches.
>>
>> Yes, these patches will be added back.
>
>I've cleaned up the first patch a bit, and pushed everything to the
>testing branch. Can you give it a test.

What happend to that branch? FWIW I've just tried the patches on a custom
board with a LS1028A SoC. Both CAN and CAN-FD are working. I've tested
against a Peaktech USB CAN adapter. I'd love to see these patches upstream,
because our board also offers CAN and basic support for it just made it
upstream [1].

If these patches are upstream, only the device tree nodes seems to be
missing. I don't know what has happened to [2]. But the patch doesn't seem
to be necessary.

Pankaj already send a patch to add the device node to the LS1028A [3].
Thats basically the same I've used, only that mine didn't had the
"fsl,ls1028ar1-flexcan" compatiblity string, but only the
"lx2160ar1-flexcan" which is the correct way to use it, right?

Sorry for putting this all in one mail, but I've just subscribed to
linux-can and there is no message archive on lore.kernel.org for it :/

[1] https://lore.kernel.org/lkml/20200212073617.GA11096@dragon/
[2] https://www.spinics.net/lists/linux-can/msg01584.html
[3] https://www.spinics.net/lists/linux-can/msg01577.html

-michael
