Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92F292D52E5
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 05:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732496AbgLJEol (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 23:44:41 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39600 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730039AbgLJEol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 23:44:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B6DBB4D259C29;
        Wed,  9 Dec 2020 20:44:00 -0800 (PST)
Date:   Wed, 09 Dec 2020 20:44:00 -0800 (PST)
Message-Id: <20201209.204400.465612946214989581.davem@davemloft.net>
To:     mickeyr@marvell.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, vkochan@marvell.com,
        tchornyi@marvell.com
Subject: Re: [PATCH v3] MAINTAINERS: Add entry for Marvell Prestera
 Ethernet Switch driver
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209134739.28497-1-mickeyr@marvell.com>
References: <20201209134739.28497-1-mickeyr@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 20:44:00 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mickey Rachamim <mickeyr@marvell.com>
Date: Wed, 9 Dec 2020 15:47:39 +0200

> Add maintainers info for new Marvell Prestera Ethernet switch driver.
> 
> Signed-off-by: Mickey Rachamim <mickeyr@marvell.com>
> ---
> 1. Update +W to link to the project source github page.
> 2. Remove +L as inherited from the entry of networking drivers.

Applied, thanks.
