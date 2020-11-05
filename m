Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C87E42A7552
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:18:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732210AbgKECSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:18:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726827AbgKECSg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Nov 2020 21:18:36 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4C6020644;
        Thu,  5 Nov 2020 02:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604542716;
        bh=QETHC8KuS/Q44hI4lYE832qH2+hQLh5xFZQsGVMdSM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E1lPiBWB/P10Y6AkgHjSmCrs/EjFLznFwYE+ZDRc32j45+IX6VhmLu7ZTDo9ElGSq
         TEl1qHNOT8T0QvfVjVPLpzo0e28DiW5MgDWMdsF83GLEWX/ZUUDJm5Ygk9uFIeeIXC
         XYYa/dGTCuz1cdKlPH38Rt65K3h8NTWIWiEgSILY=
Date:   Wed, 4 Nov 2020 18:18:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/8] Netfilter updates for net-next
Message-ID: <20201104181834.390cf155@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201104141149.30082-1-pablo@netfilter.org>
References: <20201104141149.30082-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Nov 2020 15:11:41 +0100 Pablo Neira Ayuso wrote:
> 1) Move existing bridge packet reject infra to nf_reject_{ipv4,ipv6}.c
>    from Jose M. Guisado.
> 
> 2) Consolidate nft_reject_inet initialization and dump, also from Jose.
> 
> 3) Add the netdev reject action, from Jose.
> 
> 4) Allow to combine the exist flag and the destroy command in ipset,
>    from Joszef Kadlecsik.
> 
> 5) Expose bucket size parameter for hashtables, also from Jozsef.
> 
> 6) Expose the init value for reproducible ipset listings, from Jozsef.
> 
> 7) Use __printf attribute in nft_request_module, from Andrew Lunn.
> 
> 8) Allow to use reject from the inet ingress chain.

Pulled, thanks!
