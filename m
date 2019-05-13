Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E86E51BAD4
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728850AbfEMQQY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:16:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39322 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727774AbfEMQQX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:16:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 419B514E226E9;
        Mon, 13 May 2019 09:16:23 -0700 (PDT)
Date:   Mon, 13 May 2019 09:16:22 -0700 (PDT)
Message-Id: <20190513.091622.1327750308553784712.davem@davemloft.net>
To:     chenweilong@huawei.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2] ipv4: Add support to disable icmp timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1557754137-100816-1-git-send-email-chenweilong@huawei.com>
References: <1557754137-100816-1-git-send-email-chenweilong@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:16:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>
Date: Mon, 13 May 2019 21:28:57 +0800

> The remote host answers to an ICMP timestamp request.
> This allows an attacker to know the time and date on your host.
> 
> This path is an another way contrast to iptables rules:
> iptables -A input -p icmp --icmp-type timestamp-request -j DROP
> iptables -A output -p icmp --icmp-type timestamp-reply -j DROP
> 
> Default is enabled.
> 
> enable:
> 	sysctl -w net.ipv4.icmp_timestamp_enable=1
> disable
> 	sysctl -w net.ipv4.icmp_timestamp_enable=0
> testing:
> 	hping3 --icmp --icmp-ts -V $IPADDR
> 
> Signed-off-by: Weilong Chen <chenweilong@huawei.com>

Premise is wrong, understanding of what ICMP timestamp value actually
is is inaccurate, and the solution is wrong.

No way I am applying this, sorry.
