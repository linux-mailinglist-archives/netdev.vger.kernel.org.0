Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B2BA399C63
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 10:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229950AbhFCIUE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 04:20:04 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:56776 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229913AbhFCIUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 04:20:03 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 10DE1800057;
        Thu,  3 Jun 2021 10:18:17 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 3 Jun 2021 10:18:16 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Thu, 3 Jun 2021
 10:18:16 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 6F05331801F6; Thu,  3 Jun 2021 10:18:16 +0200 (CEST)
Date:   Thu, 3 Jun 2021 10:18:16 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, <kuba@kernel.org>,
        Sabrina Dubroca <sd@queasysnail.net>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH ipsec] xfrm: remove the fragment check for ipv6 beet mode
Message-ID: <20210603081816.GY40979@gauss3.secunet.de>
References: <8099f9355ff059dbcbde40ae0b2a1c377844706f.1622319798.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <8099f9355ff059dbcbde40ae0b2a1c377844706f.1622319798.git.lucien.xin@gmail.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 29, 2021 at 04:23:18PM -0400, Xin Long wrote:
> In commit 68dc022d04eb ("xfrm: BEET mode doesn't support fragments
> for inner packets"), it tried to fix the issue that in TX side the
> packet is fragmented before the ESP encapping while in the RX side
> the fragments always get reassembled before decapping with ESP.
> 
> This is not true for IPv6. IPv6 is different, and it's using exthdr
> to save fragment info, as well as the ESP info. Exthdrs are added
> in TX and processed in RX both in order. So in the above case, the
> ESP decapping will be done earlier than the fragment reassembling
> in TX side.
> 
> Here just remove the fragment check for the IPv6 inner packets to
> recover the fragments support for BEET mode.
> 
> Fixes: 68dc022d04eb ("xfrm: BEET mode doesn't support fragments for inner packets")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Applied, thanks Xin!
