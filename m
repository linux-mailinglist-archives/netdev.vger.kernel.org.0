Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 891841C0B7F
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:09:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728059AbgEABJz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:09:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbgEABJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:09:55 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44746C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 18:09:55 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87FFF1274F705;
        Thu, 30 Apr 2020 18:09:54 -0700 (PDT)
Date:   Thu, 30 Apr 2020 18:09:53 -0700 (PDT)
Message-Id: <20200430.180953.610137603497201056.davem@davemloft.net>
To:     u9012063@gmail.com
Cc:     netdev@vger.kernel.org, petrm@mellanox.com, lucien.xin@gmail.com,
        guy@alum.mit.edu, dandreye@cisco.com
Subject: Re: [PATCH net-next] erspan: Add type I version 0 support.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587913511-78101-1-git-send-email-u9012063@gmail.com>
References: <1587913511-78101-1-git-send-email-u9012063@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 18:09:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: William Tu <u9012063@gmail.com>
Date: Sun, 26 Apr 2020 08:05:11 -0700

> index 029b24eeafba..b5c5fb329f31 100644
> --- a/net/ipv4/ip_gre.c
> +++ b/net/ipv4/ip_gre.c
> @@ -248,6 +248,15 @@ static void gre_err(struct sk_buff *skb, u32 info)
>  	ipgre_err(skb, info, &tpi);
>  }
>  
> +static inline bool is_erspan_type1(int gre_hdr_len)
> +{

Please do not use the inline keyword in foo.c files, let the compiler decide.
