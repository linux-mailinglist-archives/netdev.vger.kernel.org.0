Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7542A191D46
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 00:12:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727100AbgCXXMM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 19:12:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37682 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726204AbgCXXMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 19:12:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 88A51159F39A2;
        Tue, 24 Mar 2020 16:12:11 -0700 (PDT)
Date:   Tue, 24 Mar 2020 16:10:11 -0700 (PDT)
Message-Id: <20200324.161011.1071844122704777408.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     vishal@chelsio.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rahul.lakkireddy@chelsio.com
Subject: Re: [PATCH net-next] cxgb4: remove set but not used variable 'tab'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200324062614.29644-1-yuehaibing@huawei.com>
References: <20200324062614.29644-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 24 Mar 2020 16:12:11 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Tue, 24 Mar 2020 14:26:14 +0800

> @@ -544,7 +544,7 @@ int cxgb4_get_free_ftid(struct net_device *dev, u8 family, bool hash_en,
>  {
>  	struct adapter *adap = netdev2adap(dev);
>  	struct tid_info *t = &adap->tids;
> -	struct filter_entry *tab, *f;
> +	struct filter_entry *f;
>  	u32 bmap_ftid, max_ftid;
>  	unsigned long *bmap;
>  	bool found = false;

Please preserve the reverse christmas tree ordering here.
