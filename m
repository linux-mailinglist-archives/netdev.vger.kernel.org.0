Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3BA2F84F2
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 01:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727567AbfKLAMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 19:12:06 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:35410 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726960AbfKLAMF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 19:12:05 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 6DD5E154005C1;
        Mon, 11 Nov 2019 16:12:04 -0800 (PST)
Date:   Mon, 11 Nov 2019 16:12:01 -0800 (PST)
Message-Id: <20191111.161201.88134333908165523.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     pshelar@ovn.org, blp@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org, ychen103103@163.com
Subject: Re: [PATCH net-next v2] net: openvswitch: add hash info to upcall
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573386844-35344-1-git-send-email-xiangxia.m.yue@gmail.com>
References: <1573386844-35344-1-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 11 Nov 2019 16:12:05 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sun, 10 Nov 2019 19:54:04 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> When using the kernel datapath, the upcall don't
> add skb hash info relatived. That will introduce
> some problem, because the hash of skb is very
> important (e.g. vxlan module uses it for udp src port,
> tx queue selection on tx path.).
> 
> For example, there will be one upcall, without information
> skb hash, to ovs-vswitchd, for the first packet of one tcp
> session. When kernel sents the tcp packets, the hash is
> random for a tcp socket:
 ...
> Reported-at: https://mail.openvswitch.org/pipermail/ovs-dev/2019-October/364062.html
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> ---
> v2: add define before #endif

OVS folks, please review.

Thanks.
