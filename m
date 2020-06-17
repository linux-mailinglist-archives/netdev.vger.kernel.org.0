Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CEC11FD1D4
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726941AbgFQQT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:19:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:52406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQQT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:19:59 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81B3C2080D;
        Wed, 17 Jun 2020 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592410798;
        bh=UOL6UPUpr6KSxlkFBPWbq1wSoz65Ue9qk/Gf2MQ1UMw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vq/1AVpC0z0Cw8oXHxTd4lwQT19F9JHnVe399eeYHEw93thKdenImReREVnjxNe4l
         6hzNVObfpExMUt6WH8VONm/Dqjq7KHCG5DHX4pbdYEPWUENtULo4CT+m+hQIUceeWF
         0fpV6RKo7pKr0UQIknvorA9kW1e6ghQZ5DRqsjC8=
Date:   Wed, 17 Jun 2020 09:19:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 03/10] tunnel6: add tunnel6_input_afinfo for
 ipip and ipv6 tunnels
Message-ID: <20200617091957.1ba687e1@kicinski-fedora-PC1C0HJN>
In-Reply-To: <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
        <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
        <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
        <ed6925fb49c11273efb78fcd47e75e0dc302addd.1592328814.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 01:36:28 +0800 Xin Long wrote:
> This patch is to register a callback function tunnel6_rcv_cb with
> is_ipip set in a xfrm_input_afinfo object for tunnel6 and tunnel46.
> 
> It will be called by xfrm_rcv_cb() from xfrm_input() when family
> is AF_INET6 and proto is IPPROTO_IPIP or IPPROTO_IPV6.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

net/ipv6/tunnel6.c:163:14: warning: incorrect type in assignment (different address spaces)
net/ipv6/tunnel6.c:163:14:    expected struct xfrm6_tunnel *head
net/ipv6/tunnel6.c:163:14:    got struct xfrm6_tunnel [noderef] <asn:4> *
net/ipv6/tunnel6.c:165:9: error: incompatible types in comparison expression (different address spaces):
net/ipv6/tunnel6.c:165:9:    struct xfrm6_tunnel [noderef] <asn:4> *
net/ipv6/tunnel6.c:165:9:    struct xfrm6_tunnel *
