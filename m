Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06150F3C21
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:25:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfKGXZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:25:48 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49860 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725928AbfKGXZs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:25:48 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BF1515371C3C;
        Thu,  7 Nov 2019 15:25:47 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:25:46 -0800 (PST)
Message-Id: <20191107.152546.133751672372358154.davem@davemloft.net>
To:     michael@walle.cc
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com
Subject: Re: [PATCH] enetc: add ioctl() support for PHY-related ops
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107083937.18228-1-michael@walle.cc>
References: <20191107083937.18228-1-michael@walle.cc>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:25:47 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Walle <michael@walle.cc>
Date: Thu,  7 Nov 2019 09:39:37 +0100

> If there is an attached PHY try to handle the requested ioctl with its
> handler, which allows the userspace to access PHY registers, for
> example. This will make mii-diag and similar tools work.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Applied.
