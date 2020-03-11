Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A2F518235E
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 21:38:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729229AbgCKUiy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 16:38:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52428 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729190AbgCKUix (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 16:38:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AD0A115825FF1;
        Wed, 11 Mar 2020 13:38:52 -0700 (PDT)
Date:   Wed, 11 Mar 2020 13:38:50 -0700 (PDT)
Message-Id: <20200311.133850.1668349987867126659.davem@davemloft.net>
To:     tangbin@cmss.chinamobile.com
Cc:     andrew@lunn.ch, corbet@lwn.net, benh@kernel.crashing.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net:ftgmac100:remove redundant judgement
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200311020537.12420-1-tangbin@cmss.chinamobile.com>
References: <20200311020537.12420-1-tangbin@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Mar 2020 13:38:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: tangbin <tangbin@cmss.chinamobile.com>
Date: Wed, 11 Mar 2020 10:05:37 +0800

> In this function, ftgmac100_probe() can be triggered only
> if the platform_device and platform_driver matches, so the
> judgement at the beginning is redundant.
> 
> Signed-off-by: tangbin <tangbin@cmss.chinamobile.com>

Applied to net-next, thanks.
