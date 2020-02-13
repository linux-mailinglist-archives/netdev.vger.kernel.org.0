Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8429715C045
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 15:26:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727436AbgBMO0h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 09:26:37 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:41904 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725781AbgBMO0h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Feb 2020 09:26:37 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8144215B11740;
        Thu, 13 Feb 2020 06:26:36 -0800 (PST)
Date:   Thu, 13 Feb 2020 06:26:34 -0800 (PST)
Message-Id: <20200213.062634.960355941643109808.davem@davemloft.net>
To:     Per@axis.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, o.rempel@pengutronix.de,
        per.forlin@axis.com, perfn@axis.com
Subject: Re: [PATCH net 2/2] net: dsa: tag_ar9331: Make sure there is
 headroom for tag
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200213135100.2963-3-per.forlin@axis.com>
References: <20200213135100.2963-1-per.forlin@axis.com>
        <20200213135100.2963-3-per.forlin@axis.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2020 06:26:36 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


You need to fix your email setup if you want to post patches here.

You are providing multiple email addresses in your From: field and
almost every major email provider (including gmail) rejects emails
with that.

So nobody is seeing your postings until you fix this.

Thank you.
