Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87F797734C
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:18:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728312AbfGZVSc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:18:32 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55254 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726102AbfGZVSc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jul 2019 17:18:32 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1460312B8A119;
        Fri, 26 Jul 2019 14:18:31 -0700 (PDT)
Date:   Fri, 26 Jul 2019 14:18:30 -0700 (PDT)
Message-Id: <20190726.141830.1385987551076676185.davem@davemloft.net>
To:     yanhaishuang@cmss.chinamobile.com
Cc:     kuznet@ms2.inr.ac.ru, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ip6_tunnel: fix possible use-after-free on xmit
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1564072817-13240-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
References: <1564072817-13240-1-git-send-email-yanhaishuang@cmss.chinamobile.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 26 Jul 2019 14:18:31 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>
Date: Fri, 26 Jul 2019 00:40:17 +0800

> ip4ip6/ip6ip6 tunnels run iptunnel_handle_offloads on xmit which
> can cause a possible use-after-free accessing iph/ipv6h pointer
> since the packet will be 'uncloned' running pskb_expand_head if
> it is a cloned gso skb.
> 
> Fixes: 0e9a709560db ("ip6_tunnel, ip6_gre: fix setting of DSCP on encapsulated packets")
> Signed-off-by: Haishuang Yan <yanhaishuang@cmss.chinamobile.com>

Applied and queued up for -stable, thanks.
