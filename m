Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEC172D154
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 00:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728074AbfE1WFZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 18:05:25 -0400
Received: from ja.ssi.bg ([178.16.129.10]:55672 "EHLO ja.ssi.bg"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726576AbfE1WFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 18:05:25 -0400
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.15.2/8.15.2) with ESMTP id x4SM4E6G010937;
        Wed, 29 May 2019 01:04:14 +0300
Date:   Wed, 29 May 2019 01:04:14 +0300 (EEST)
From:   Julian Anastasov <ja@ssi.bg>
To:     Jacky Hu <hengqing.hu@gmail.com>
cc:     jacky.hu@walmart.com, jason.niesz@walmart.com,
        Wensong Zhang <wensong@linux-vs.org>,
        Simon Horman <horms@verge.net.au>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>, netdev@vger.kernel.org,
        lvs-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Subject: Re: [PATCH v2] ipvs: add checksum support for gue encapsulation
In-Reply-To: <20190526064819.16420-1-hengqing.hu@gmail.com>
Message-ID: <alpine.LFD.2.21.1905290059380.4284@ja.home.ssi.bg>
References: <20190526064819.16420-1-hengqing.hu@gmail.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


	Hello,

On Sun, 26 May 2019, Jacky Hu wrote:

> +/* Tunnel encapsulation flags */
> +#define IP_VS_TUNNEL_ENCAP_FLAG_NOCSUM		(0)
> +#define IP_VS_TUNNEL_ENCAP_FLAG_CSUM		(1<<0)
> +#define IP_VS_TUNNEL_ENCAP_FLAG_REMCSUM		(1<<1)

	scripts/checkpatch.pl --strict file.patch
reports for some issues you should resolve for v3.
Otherwise, the patch looks good to me.

Regards

--
Julian Anastasov <ja@ssi.bg>
