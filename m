Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 923CD280C0B
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 03:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387534AbgJBBkO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 21:40:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733275AbgJBBkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 21:40:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E273C0613D0;
        Thu,  1 Oct 2020 18:40:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C8CF1285CF60;
        Thu,  1 Oct 2020 18:23:26 -0700 (PDT)
Date:   Thu, 01 Oct 2020 18:40:13 -0700 (PDT)
Message-Id: <20201001.184013.1373555560291108341.davem@davemloft.net>
To:     sfr@canb.auug.org.au
Cc:     netdev@vger.kernel.org, vadym.kochan@plvision.eu,
        ap420073@gmail.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the net-next tree
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200929130446.0c2630d2@canb.auug.org.au>
References: <20200929130446.0c2630d2@canb.auug.org.au>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 01 Oct 2020 18:23:26 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 29 Sep 2020 13:04:46 +1000

> Caused by commit
> 
>   eff7423365a6 ("net: core: introduce struct netdev_nested_priv for nested interface infrastructure")
> 
> interacting with commit
> 
>   e1189d9a5fbe ("net: marvell: prestera: Add Switchdev driver implementation")
> 
> also in the net-next tree.

I would argue against that "also" as the first commit is only in the
'net' tree right now. :-)

This is simply something I'll have to resolve the next time net is merged
into net-next.

Thanks.
