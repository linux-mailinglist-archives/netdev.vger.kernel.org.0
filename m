Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE436260617
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 23:16:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgIGVQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 17:16:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:53756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726871AbgIGVQi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 17:16:38 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DFC42145D;
        Mon,  7 Sep 2020 21:16:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599513398;
        bh=UDqE4koH6uSZouSZ9O9PDcwu3aSRG/Q2oReFsFVUaqU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qRGNJDFJIFvnmQY3EWCE+xE8I2o+kw5xS2eqiyVan7gIiwjlxW61NB10UzeRO8q7F
         buAmE6vA/fqCy0KK7s/9Nvs7rfpwWMED2iEUj6+FM9ExMFTUdR4KuCV9pvT/JOIgEq
         63cCbxHURamwdDtbAgVaR/fiTMs/c+SrWCVOAOiM=
Date:   Mon, 7 Sep 2020 14:16:36 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Fabian Frederick <fabf@skynet.be>, davem@davemloft.net,
        fw@strlen.de, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] selftests/net: replace obsolete NFT_CHAIN
 configuration
Message-ID: <20200907141636.6b61a838@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200907161428.16847-1-fabf@skynet.be>
References: <20200907161428.16847-1-fabf@skynet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  7 Sep 2020 18:14:28 +0200 Fabian Frederick wrote:
> Replace old parameters with global NFT_NAT from commit db8ab38880e0
> ("netfilter: nf_tables: merge ipv4 and ipv6 nat chain types")
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  tools/testing/selftests/net/config | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
> index 3b42c06b59858..5a57ea02802df 100644
> --- a/tools/testing/selftests/net/config
> +++ b/tools/testing/selftests/net/config
> @@ -24,8 +24,7 @@ CONFIG_IP_NF_NAT=m
>  CONFIG_NF_TABLES=m
>  CONFIG_NF_TABLES_IPV6=y
>  CONFIG_NF_TABLES_IPV4=y
> -CONFIG_NFT_CHAIN_NAT_IPV6=m
> -CONFIG_NFT_CHAIN_NAT_IPV4=m
> +CONFIG_NFT_NAT=m
>  CONFIG_NET_SCH_FQ=m
>  CONFIG_NET_SCH_ETF=m
>  CONFIG_NET_SCH_NETEM=y

Pablo, looks like netfilter business, I'm leaving this patch to you
unless you say otherwise.
