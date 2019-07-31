Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D15597C6EB
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 17:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728774AbfGaPiw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 11:38:52 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39312 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbfGaPiu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 11:38:50 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26D9812B8C6EC;
        Wed, 31 Jul 2019 08:38:50 -0700 (PDT)
Date:   Wed, 31 Jul 2019 08:38:49 -0700 (PDT)
Message-Id: <20190731.083849.181428798865323625.davem@davemloft.net>
To:     christophe.jaillet@wanadoo.fr
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ag71xx: Slighly simplify code in
 'ag71xx_rings_init()'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <08fbcfe0f913644fe538656221a15790a1a83f1d.1564560130.git.christophe.jaillet@wanadoo.fr>
References: <cover.1564560130.git.christophe.jaillet@wanadoo.fr>
        <08fbcfe0f913644fe538656221a15790a1a83f1d.1564560130.git.christophe.jaillet@wanadoo.fr>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 31 Jul 2019 08:38:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Date: Wed, 31 Jul 2019 10:06:38 +0200

> A few lines above, we have:
>    tx_size = BIT(tx->order);
> 
> So use 'tx_size' directly to be consistent with the way 'rx->descs_cpu' and
> 'rx->descs_dma' are computed below.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied to net-next.
