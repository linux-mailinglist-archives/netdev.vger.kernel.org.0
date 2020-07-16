Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD938221CA2
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:32:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgGPGca (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:32:30 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:39208 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726141AbgGPGca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 02:32:30 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id EFF1E20536;
        Thu, 16 Jul 2020 08:32:28 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id WFxsQhpiM24I; Thu, 16 Jul 2020 08:32:28 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 8DC6D200A7;
        Thu, 16 Jul 2020 08:32:28 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Thu, 16 Jul 2020 08:32:28 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 16 Jul
 2020 08:32:28 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id E19D93180222;
 Thu, 16 Jul 2020 08:32:27 +0200 (CEST)
Date:   Thu, 16 Jul 2020 08:32:27 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, "David S. Miller" <davem@davemloft.net>,
        "Sabrina Dubroca" <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 0/3] xfrm: not register one xfrm(6)_tunnel
 object twice
Message-ID: <20200716063227.GW20687@gauss3.secunet.de>
References: <cover.1594625993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1594625993.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 13, 2020 at 03:42:35PM +0800, Xin Long wrote:
> Now in ip(6)_vti and xfrm interface tunnel support, it uses the
> same xfrm(6)_tunnel object to handle for AF_NET and AF_INET6 by
> registering it twice.
> 
> However the xfrm(6)_tunnel object is linked into a list with its
> 'next' pointer. The second registering will cause its 'next'
> pointer to be overwritten, and break the list.
> 
> So this patchset is to add a new xfrm(6)_tunnel object for each
> of them and register it, although its members are the same with
> the old one.
> 
> Xin Long (3):
>   ip_vti: not register vti_ipip_handler twice
>   ip6_vti: not register vti_ipv6_handler twice
>   xfrm: interface: not xfrmi_ipv6/ipip_handler twice


Applied, thanks Xin!
