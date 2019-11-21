Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 86B35105D01
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 00:06:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726767AbfKUXGI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 18:06:08 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:55092 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726265AbfKUXGI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 18:06:08 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2B92150AD829;
        Thu, 21 Nov 2019 15:06:07 -0800 (PST)
Date:   Thu, 21 Nov 2019 15:06:07 -0800 (PST)
Message-Id: <20191121.150607.1310896813096710634.davem@davemloft.net>
To:     r.schwebel@pengutronix.de
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: nfc: change to rst format
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121155503.52019-5-r.schwebel@pengutronix.de>
References: <20191121155503.52019-1-r.schwebel@pengutronix.de>
        <20191121155503.52019-5-r.schwebel@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 15:06:08 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Robert Schwebel <r.schwebel@pengutronix.de>
Date: Thu, 21 Nov 2019 16:55:03 +0100

> Now that the sphinx syntax has been fixed, change the document from txt
> to rst and add it to the index.
> 
> Signed-off-by: Robert Schwebel <r.schwebel@pengutronix.de>

As Jon mentioned, you aren't actually adding it to the index in this
patch yet the commit message says that you did.

Please fix that, repsin this series, and provide a proper "[PATCH 0/5]
..."  cover letter this time.

Thank you.
