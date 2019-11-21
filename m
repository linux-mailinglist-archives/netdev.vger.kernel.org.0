Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A308F104A97
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 07:14:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfKUGOB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 01:14:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:36978 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbfKUGOB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 01:14:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 99F4214DDBC5C;
        Wed, 20 Nov 2019 22:14:00 -0800 (PST)
Date:   Wed, 20 Nov 2019 22:13:57 -0800 (PST)
Message-Id: <20191120.221357.2118936276393168423.davem@davemloft.net>
To:     tuong.t.lien@dektech.com.au
Cc:     jon.maloy@ericsson.com, maloy@donjonn.com, ying.xue@windriver.com,
        netdev@vger.kernel.org, tipc-discussion@lists.sourceforge.net
Subject: Re: [net-next v2] tipc: support in-order name publication events
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121025325.15366-1-tuong.t.lien@dektech.com.au>
References: <20191121025325.15366-1-tuong.t.lien@dektech.com.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 20 Nov 2019 22:14:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tuong Lien <tuong.t.lien@dektech.com.au>
Date: Thu, 21 Nov 2019 09:53:25 +0700

> +static inline int publication_after(struct publication *pa,
> +				    struct publication *pb)
> +{
> +	return ((int)(pb->id - pa->id) < 0);
> +}

Juse use time32_after() et al. instead of reinventing the same exact
code please.
