Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 623E9195256
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 08:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726193AbgC0HvK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 03:51:10 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53826 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725946AbgC0HvJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 03:51:09 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7E9152052E;
        Fri, 27 Mar 2020 08:51:08 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id eS3T-P7v1Z3G; Fri, 27 Mar 2020 08:51:08 +0100 (CET)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 1A40B20519;
        Fri, 27 Mar 2020 08:51:08 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Fri, 27 Mar
 2020 08:51:07 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id B039D31801D2; Fri, 27 Mar 2020 08:51:07 +0100 (CET)
Date:   Fri, 27 Mar 2020 08:51:07 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Westphal <fw@strlen.de>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 0/3] xfrm: add offload support for esp beet
 mode
Message-ID: <20200327075107.GZ13121@gauss3.secunet.de>
References: <cover.1585213292.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1585213292.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 05:02:28PM +0800, Xin Long wrote:
> This patchset is to add gso_segment functions for esp4 and esp6
> beet mode, and prep function for both, and tested with 6 cases:
> 
>   1. IPv4 INNER ADDRESSES
>      - OUTER v4 ADDRESSES
>      - OUTER v6 ADDRESSES
> 
>   2. IPv4 INNER ADDRESSES with options
>      - OUTER v4 ADDRESSES
>      - OUTER v6 ADDRESSES
> 
>   3. IPv6 INNER ADDRESSES
>      - OUTER v4 ADDRESSES
>      - OUTER v6 ADDRESSES
> 
> With this patchset, an esp beet mode skb would be segmented and
> encryped until it arrives in dev_queue_xmit()/validate_xmit_skb().
> 
> Xin Long (3):
>   esp4: add gso_segment for esp4 beet mode
>   esp6: add gso_segment for esp6 beet mode
>   xfrm: add prep for esp beet mode offload

Series applied to ipsec-next, thanks a lot Xin!
