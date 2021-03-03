Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6504A32C4A4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1450073AbhCDAPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:15:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59102 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1576221AbhCCVNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 16:13:17 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 07D6F4D2ECC93;
        Wed,  3 Mar 2021 13:12:35 -0800 (PST)
Date:   Wed, 03 Mar 2021 13:12:31 -0800 (PST)
Message-Id: <20210303.131231.1574207832462999993.davem@davemloft.net>
To:     mkl@pengutronix.de
Cc:     martin@strongswan.org, kuba@kernel.org, wg@grandegger.com,
        netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH net] can: dev: Move device back to init netns on owning
 netns delete,Re: [PATCH net] can: dev: Move device back to init netns on
 owning netns delete
From:   David Miller <davem@davemloft.net>
In-Reply-To: <86f703d8-d658-505a-6493-54bf09ed65b2@pengutronix.de>
References: <20210302122423.872326-1-martin@strongswan.org>
        <20210302122423.872326-1-martin@strongswan.org>
        <86f703d8-d658-505a-6493-54bf09ed65b2@pengutronix.de>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 03 Mar 2021 13:12:36 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Wed, 3 Mar 2021 21:29:39 +0100

> Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> David, Jakub are you taking this patch?

Nope, please take via the can tree, thanks!
