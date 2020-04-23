Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAC391B646D
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbgDWT0t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:26:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDWT0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:26:49 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB508C09B042
        for <netdev@vger.kernel.org>; Thu, 23 Apr 2020 12:26:49 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3FE61277221D;
        Thu, 23 Apr 2020 12:26:46 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:26:40 -0700 (PDT)
Message-Id: <20200423.122640.181542852051859304.davem@davemloft.net>
To:     fgont@si6networks.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next] ipv6: Implement draft-ietf-6man-rfc4941bis
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200419121658.GA765@archlinux-current.localdomain>
References: <20200419121658.GA765@archlinux-current.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:26:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Fernando Gont <fgont@si6networks.com>
Date: Sun, 19 Apr 2020 09:16:58 -0300

> @@ -1306,12 +1304,11 @@ static void ipv6_del_addr(struct inet6_ifaddr *ifp)
>  	in6_ifa_put(ifp);
>  }
>  
> -static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp,
> -				struct inet6_ifaddr *ift,
> -				bool block)
> +static int ipv6_create_tempaddr(struct inet6_ifaddr *ifp, bool block)
>  {
>  	struct inet6_dev *idev = ifp->idev;
> -	struct in6_addr addr, *tmpaddr;
> +	struct in6_addr addr;
> +	struct inet6_ifaddr *ift;
>  	unsigned long tmp_tstamp, age;
>  	unsigned long regen_advance;
>  	struct ifa6_config cfg;

Please preserve the reverse christmas tree ordering of local variables
here.

Thank you.
