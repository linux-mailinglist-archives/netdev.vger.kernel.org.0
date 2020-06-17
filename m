Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 064D11FD1CB
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726840AbgFQQTI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:52110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726496AbgFQQTI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Jun 2020 12:19:08 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A7D282080D;
        Wed, 17 Jun 2020 16:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592410747;
        bh=O63FTYo2bZgKRLcKaMC8kx5VHu/JZKpbfoq352EqP0s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UZN3DGoBhtnp6G77xh8Py+A01/wnE8EjrlxE8jO393KlWewhEOt0tdv4fdD3gQgk/
         R2FMjNMr4yzmyl79JjrU2Us5gh3fNsUzAj3o34UevkzUcpnrC8agDyYTcEKDoD7CXy
         o+NmrvZQ4CQuoiryl8U72p8KTPne9+Eu60s86UDA=
Date:   Wed, 17 Jun 2020 09:19:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 02/10] tunnel4: add cb_handler to struct
 xfrm_tunnel
Message-ID: <20200617091905.2b007939@kicinski-fedora-PC1C0HJN>
In-Reply-To: <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
References: <cover.1592328814.git.lucien.xin@gmail.com>
        <84bcb772ea1b68f3b150106b9db1825b65742cef.1592328814.git.lucien.xin@gmail.com>
        <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Jun 2020 01:36:27 +0800 Xin Long wrote:
> This patch is to register a callback function tunnel4_rcv_cb with
> is_ipip set in a xfrm_input_afinfo object for tunnel4 and tunnel64.
> 
> It will be called by xfrm_rcv_cb() from xfrm_input() when family
> is AF_INET and proto is IPPROTO_IPIP or IPPROTO_IPV6.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Please make sure W=1 C=1 builds don't add new warnings:

net/ipv4/tunnel4.c:118:14: warning: incorrect type in assignment (different address spaces)
net/ipv4/tunnel4.c:118:14:    expected struct xfrm_tunnel *head
net/ipv4/tunnel4.c:118:14:    got struct xfrm_tunnel [noderef] <asn:4> *
net/ipv4/tunnel4.c:120:9: error: incompatible types in comparison expression (different address spaces):
net/ipv4/tunnel4.c:120:9:    struct xfrm_tunnel [noderef] <asn:4> *
net/ipv4/tunnel4.c:120:9:    struct xfrm_tunnel *
