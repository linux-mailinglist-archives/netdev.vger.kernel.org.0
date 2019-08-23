Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1262B9B873
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 00:17:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392604AbfHWWQ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 18:16:59 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38560 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387472AbfHWWQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Aug 2019 18:16:59 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6BE871543CF8D;
        Fri, 23 Aug 2019 15:16:58 -0700 (PDT)
Date:   Fri, 23 Aug 2019 15:16:57 -0700 (PDT)
Message-Id: <20190823.151657.2068961230800142712.davem@davemloft.net>
To:     tom@herbertland.com
Cc:     netdev@vger.kernel.org, tom@quantonium.net
Subject: Re: [PATCH v4 net-next 4/7] ip6tlvs: Registration of TLV handlers
 and parameters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566587643-16594-5-git-send-email-tom@herbertland.com>
References: <1566587643-16594-1-git-send-email-tom@herbertland.com>
        <1566587643-16594-5-git-send-email-tom@herbertland.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 23 Aug 2019 15:16:58 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Herbert <tom@herbertland.com>
Date: Fri, 23 Aug 2019 12:14:00 -0700

>  					int off, enum ipeh_parse_errors error))
>  {
>  	const unsigned char *nh = skb_network_header(skb);
> -	const struct tlvtype_proc *curr;
> +	const struct tlv_proc *curr;
>  	bool disallow_unknowns = false;
>  	int tlv_count = 0;
>  	int padlen = 0;

Please retain the reverse christmas tree ordering here.
