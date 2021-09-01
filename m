Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C60C13FD7F5
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 12:46:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235853AbhIAKrL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 06:47:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51814 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231903AbhIAKrK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Sep 2021 06:47:10 -0400
Received: from localhost (cpc147930-brnt3-2-0-cust60.4-2.cable.virginm.net [86.15.196.61])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 03AC74D25361F;
        Wed,  1 Sep 2021 03:46:11 -0700 (PDT)
Date:   Wed, 01 Sep 2021 11:46:10 +0100 (BST)
Message-Id: <20210901.114610.1079964034163320336.davem@davemloft.net>
To:     schalla@marvell.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, sgoutham@marvell.com,
        lcherian@marvell.com, gakula@marvell.com, hkelam@marvell.com,
        jerinj@marvell.com, sbhatta@marvell.com, vvelumuri@marvell.com
Subject: Re: [PATCH] octeontx2-af: Hardware configuration for inline IPsec
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210901103123.646139-1-schalla@marvell.com>
References: <20210901103123.646139-1-schalla@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 27.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 01 Sep 2021 03:46:14 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Srujana Challa <schalla@marvell.com>
Date: Wed, 1 Sep 2021 16:01:23 +0530

> On OcteonTX2/CN10K SoC, the admin function (AF) is the only one
> with all priviliges to configure HW and alloc resources, PFs and
> it's VFs have to request AF via mailbox for all their needs.
> This patch adds new mailbox messages for CPT PFs and VFs to configure
> HW resources for inline-IPsec.
> 
> Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
> Signed-off-by: Srujana Challa <schalla@marvell.com>
> Signed-off-by: Vidya Sagar Velumuri <vvelumuri@marvell.com>

net-next is closed.  Please resubmit this when it opens back up.

Thank you.
