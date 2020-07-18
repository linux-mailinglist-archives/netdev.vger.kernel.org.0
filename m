Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC862247E9
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 03:56:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728430AbgGRB4M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 21:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726665AbgGRB4M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 21:56:12 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22CB7C0619D2;
        Fri, 17 Jul 2020 18:56:12 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AAEFE11E4590D;
        Fri, 17 Jul 2020 18:56:11 -0700 (PDT)
Date:   Fri, 17 Jul 2020 18:56:11 -0700 (PDT)
Message-Id: <20200717.185611.1278374862685166021.davem@davemloft.net>
To:     m-karicheri2@ti.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        nsekhar@ti.com, grygorii.strashko@ti.com, vinicius.gomes@intel.com
Subject: Re: [net-next PATCH v3 1/7] hsr: enhance netlink socket interface
 to support PRP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717151511.329-2-m-karicheri2@ti.com>
References: <20200717151511.329-1-m-karicheri2@ti.com>
        <20200717151511.329-2-m-karicheri2@ti.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 17 Jul 2020 18:56:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Fri, 17 Jul 2020 11:15:05 -0400

> @@ -32,7 +33,9 @@ static int hsr_newlink(struct net *src_net, struct net_device *dev,
>  		       struct netlink_ext_ack *extack)
>  {
>  	struct net_device *link[2];
> -	unsigned char multicast_spec, hsr_version;
> +	unsigned char multicast_spec;
> +	enum hsr_version proto_version;
> +	u8 proto = HSR_PROTOCOL_HSR;

Please use reverse christmas tree ordering for local variables.

Thank you.
