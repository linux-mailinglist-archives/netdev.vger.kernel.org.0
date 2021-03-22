Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE851345384
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 00:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230468AbhCVX6l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 19:58:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231260AbhCVX6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 19:58:36 -0400
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C455C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 16:58:35 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id B8DB04D249270;
        Mon, 22 Mar 2021 16:58:33 -0700 (PDT)
Date:   Mon, 22 Mar 2021 16:58:33 -0700 (PDT)
Message-Id: <20210322.165833.254193305389397663.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        groeck@google.com
Subject: Re: [PATCH net-next] net: set initial device refcount to 1
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210322.165526.2248035624466168840.davem@davemloft.net>
References: <20210322182145.531377-1-eric.dumazet@gmail.com>
        <20210322.165526.2248035624466168840.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Mon, 22 Mar 2021 16:58:33 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 22 Mar 2021 16:55:26 -0700 (PDT)

> From: Eric Dumazet <eric.dumazet@gmail.com>
> Date: Mon, 22 Mar 2021 11:21:45 -0700
> 
> This hunk:
>> @@ -10682,6 +10682,9 @@ struct net_device *alloc_netdev_mqs(int sizeof_priv, const char *name,
>>  	dev->pcpu_refcnt = alloc_percpu(int);
>>  	if (!dev->pcpu_refcnt)
>>  		goto free_dev;
>> +	dev_hold(dev);
>> +#else
>> +	refcount_set(&dev->dev_refcnt, 1);
>>  #endif
>>  
>>  	if (dev_addr_init(dev))
>  gets rejects in net-next.  Please respin.
>  

My bad, I was trying to apply it to 'net' mistakedly.

All good now, thanks.
