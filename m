Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77E0A37B14
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 19:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730157AbfFFRae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 13:30:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:54564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726924AbfFFRad (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 13:30:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 225A514DB3D2B;
        Thu,  6 Jun 2019 10:30:33 -0700 (PDT)
Date:   Thu, 06 Jun 2019 10:30:32 -0700 (PDT)
Message-Id: <20190606.103032.1177448114269235903.davem@davemloft.net>
To:     olivier.matz@6wind.com
Cc:     netdev@vger.kernel.org, hannes@stressinduktion.org
Subject: Re: [PATCH net 0/2] ipv6: fix EFAULT on sendto with icmpv6 and
 hdrincl
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190606071519.5841-1-olivier.matz@6wind.com>
References: <20190606071519.5841-1-olivier.matz@6wind.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 06 Jun 2019 10:30:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Olivier Matz <olivier.matz@6wind.com>
Date: Thu,  6 Jun 2019 09:15:17 +0200

> The following code returns EFAULT (Bad address):
> 
>   s = socket(AF_INET6, SOCK_RAW, IPPROTO_ICMPV6);
>   setsockopt(s, SOL_IPV6, IPV6_HDRINCL, 1);
>   sendto(ipv6_icmp6_packet, addr);   /* returns -1, errno = EFAULT */
> 
> The problem is fixed in the second patch. The first one aligns the
> code to ipv4, to avoid a race condition in the second patch.

Series applied and queued up for -stable.

Thanks.
