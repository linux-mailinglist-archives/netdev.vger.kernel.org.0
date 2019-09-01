Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69BE7A47F4
	for <lists+netdev@lfdr.de>; Sun,  1 Sep 2019 08:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728771AbfIAGxf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Sep 2019 02:53:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:34682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728693AbfIAGxf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Sep 2019 02:53:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9585514F51DF3;
        Sat, 31 Aug 2019 23:53:34 -0700 (PDT)
Date:   Sat, 31 Aug 2019 23:53:34 -0700 (PDT)
Message-Id: <20190831.235334.383882811136027003.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     yangbo.lu@nxp.com, claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] enetc: Add missing call to 'pci_free_irq_vectors()' in
 probe and remove functions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190830202312.21287-1-christophe.jaillet@wanadoo.fr>
References: <20190830202312.21287-1-christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 31 Aug 2019 23:53:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Fri, 30 Aug 2019 22:23:12 +0200

> Call to 'pci_free_irq_vectors()' are missing both in the error handling
> path of the probe function, and in the remove function.
> Add them.
> 
> Fixes: 19971f5ea0ab ("enetc: add PTP clock driver")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks.
