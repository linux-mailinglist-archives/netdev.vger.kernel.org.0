Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53498F8ED0
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 12:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbfKLLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 06:45:44 -0500
Received: from metis.ext.pengutronix.de ([85.220.165.71]:42281 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725947AbfKLLpo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Nov 2019 06:45:44 -0500
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ukl@pengutronix.de>)
        id 1iUUc8-0006x8-33; Tue, 12 Nov 2019 12:45:40 +0100
Received: from ukl by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ukl@pengutronix.de>)
        id 1iUUc7-0003TL-ED; Tue, 12 Nov 2019 12:45:39 +0100
Date:   Tue, 12 Nov 2019 12:45:39 +0100
From:   Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
        <u.kleine-koenig@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        dev.kurt@vandijck-laurijssen.be, wg@grandegger.com,
        netdev@vger.kernel.org, kernel@pengutronix.de,
        linux-can@vger.kernel.org
Subject: Re: [PATCH v1 1/9] can: af_can: export can_sock_destruct()
Message-ID: <20191112114539.zjluqnpo3cynhssi@pengutronix.de>
References: <20191112111600.18719-1-o.rempel@pengutronix.de>
 <20191112111600.18719-2-o.rempel@pengutronix.de>
 <20191112113724.pff6atmyii5ri4my@pengutronix.de>
 <1da06748-6233-b65e-9b02-da5a867a4ecb@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1da06748-6233-b65e-9b02-da5a867a4ecb@pengutronix.de>
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Marc,

On Tue, Nov 12, 2019 at 12:39:27PM +0100, Marc Kleine-Budde wrote:
> On 11/12/19 12:37 PM, Uwe Kleine-König wrote:
> > On Tue, Nov 12, 2019 at 12:15:52PM +0100, Oleksij Rempel wrote:
> >> +EXPORT_SYMBOL(can_sock_destruct);
> > 
> > If the users are only expected to be another can module, it might make
> > sense to use a namespace here?!
> 
> How?

Use

	EXPORT_SYMBOL_NS(can_sock_destruct, CAN)

instead of the plain EXPORT_SYMBOL, and near the declaration of
can_sock_destruct or in the source that makes use of the symbol add:

	MODULE_IMPORT_NS(CAN);

See https://lwn.net/Articles/760045/ for some details.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | https://www.pengutronix.de/ |
