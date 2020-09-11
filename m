Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A02426697C
	for <lists+netdev@lfdr.de>; Fri, 11 Sep 2020 22:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725853AbgIKUUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Sep 2020 16:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgIKUUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Sep 2020 16:20:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2080BC061795
        for <netdev@vger.kernel.org>; Fri, 11 Sep 2020 13:20:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A437F1365DC95;
        Fri, 11 Sep 2020 13:03:33 -0700 (PDT)
Date:   Fri, 11 Sep 2020 13:20:19 -0700 (PDT)
Message-Id: <20200911.132019.354699951896203473.davem@davemloft.net>
To:     allen.lkml@gmail.com
Cc:     jes@trained-monkey.org, kuba@kernel.org, dougmill@linux.ibm.com,
        cooldavid@cooldavid.org, mlindner@marvell.com,
        stephen@networkplumber.org, borisp@mellanox.com,
        netdev@vger.kernel.org, romain.perier@gmail.com
Subject: Re: [PATCH v2 01/20] ethernet: alteon: convert tasklets to use new
 tasklet_setup() API
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAOMdWSKMc1HDgmeWaqp1Z+kniNNE1Es9PLLo-3b1PwCrjKLw6A@mail.gmail.com>
References: <CAOMdWSKQxbKzo6z9BBO=0HPCxSs1nt8ArAe5zi_X5cPQhtnUVA@mail.gmail.com>
        <20200909.143324.405366987951760976.davem@davemloft.net>
        <CAOMdWSKMc1HDgmeWaqp1Z+kniNNE1Es9PLLo-3b1PwCrjKLw6A@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 11 Sep 2020 13:03:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Allen <allen.lkml@gmail.com>
Date: Fri, 11 Sep 2020 15:30:41 +0530

>> Just add a backpointer to the netdev from the netdev_priv() if you
>> absolutely have too.
>>
> 
> How does this look?

Looks good.

