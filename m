Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1FC671044C1
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 21:08:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727179AbfKTUIL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 15:08:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59242 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726270AbfKTUIL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Nov 2019 15:08:11 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6584714C1A0C0;
        Wed, 20 Nov 2019 12:08:10 -0800 (PST)
Date:   Wed, 20 Nov 2019 12:08:09 -0800 (PST)
Message-Id: <20191120.120809.1526734581965504532.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next] tipc: support in-order name publication events
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191120021519.2690-1-tuong.t.lien@dektech.com.au>
References: <20191120021519.2690-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 12:08:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Wed, 20 Nov 2019 09:15:19 +0700

> @@ -277,6 +283,17 @@ static struct publication *tipc_service_remove_publ(struct service_range *sr,
>  	return NULL;
>  }
>  
> +#define publication_after(pa, pb) (((int)((pb)->id - (pa)->id) < 0))

We have enough of these things, please use existing interfaces such
as time32_after() et al.

Thank you.
