Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F6592A378A
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 01:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727243AbgKCANT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 19:13:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727193AbgKCANT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 19:13:19 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9652222268;
        Tue,  3 Nov 2020 00:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604362398;
        bh=BY3coVs3vobSctQRzoySqpCGeKlBiiKbx4QQAQa4D8s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GyumUN6wKyZYGpQSPcTeW8sWp6ENPY8hQGL6xsZB9Ur8NeRUr7D3owC7ztyr0kwJW
         ssPKxj7Xwa9ontZcBlmbs/4FKzgvXSg/uOh9W7VY2Bii3ziNDkIKPu37O/jM6d/pg1
         YCd1HuTxtsX6Y6kMJCX/8tCJ/7vTdx+a7bJDRSOI=
Date:   Mon, 2 Nov 2020 16:13:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Xin Long <lucien.xin@gmail.com>
Subject: Re: [PATCH net-next] net: ipv6: For kerneldoc warnings with W=1
Message-ID: <20201102161318.75cceff9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031183044.1082193-1-andrew@lunn.ch>
References: <20201031183044.1082193-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 19:30:44 +0100 Andrew Lunn wrote:
> From: Xin Long <lucien.xin@gmail.com>
> 
> net/ipv6/addrconf.c:2005: warning: Function parameter or member 'dev' not described in 'ipv6_dev_find'
> net/ipv6/ip6_vti.c:138: warning: Function parameter or member 'ip6n' not described in 'vti6_tnl_bucket'
> net/ipv6/ip6_tunnel.c:218: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_bucket'
> net/ipv6/ip6_tunnel.c:238: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_link'
> net/ipv6/ip6_tunnel.c:254: warning: Function parameter or member 'ip6n' not described in 'ip6_tnl_unlink'
> net/ipv6/ip6_tunnel.c:427: warning: Function parameter or member 'raw' not described in 'ip6_tnl_parse_tlv_enc_lim'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'skb' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'ipproto' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'opt' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'type' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'code' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'msg' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'info' not described in 'ip6_tnl_err'
> net/ipv6/ip6_tunnel.c:499: warning: Function parameter or member 'offset' not described in 'ip6_tnl_err'
> 
> ip6_tnl_err() is an internal function, so remove the kerneldoc. For
> the others, add the missing parameters.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
