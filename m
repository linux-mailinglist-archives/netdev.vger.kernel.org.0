Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3B43514A1D6
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:18:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728173AbgA0KSf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:18:35 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:37022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725845AbgA0KSe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:18:34 -0500
Received: from localhost (unknown [213.175.37.12])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F2C061512895E;
        Mon, 27 Jan 2020 02:18:31 -0800 (PST)
Date:   Mon, 27 Jan 2020 11:18:30 +0100 (CET)
Message-Id: <20200127.111830.1055640381586578614.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     isubramanian@apm.com, keyur@os.amperecomputing.com,
        quan@os.amperecomputing.com, tinamdar@apm.com, kdinh@apm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] drivers: net: xgene: Fix the order
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200126104429.15156-1-christophe.jaillet@wanadoo.fr>
References: <20200126104429.15156-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 27 Jan 2020 02:18:34 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Sun, 26 Jan 2020 11:44:29 +0100

> 'alloc_etherdev_mqs()' expects first 'tx', then 'rx'. The semantic here
> looks reversed.
> 
> Reorder the arguments passed to 'alloc_etherdev_mqs()' in order to keep
> the correct semantic.
> 
> In fact, this is a no-op because both XGENE_NUM_[RT]X_RING are 8.
> 
> Fixes: 107dec2749fe ("drivers: net: xgene: Add support for multiple queues")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
