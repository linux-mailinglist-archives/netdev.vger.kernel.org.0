Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45E7C34E0A6
	for <lists+netdev@lfdr.de>; Tue, 30 Mar 2021 07:28:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbhC3F2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 01:28:13 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:45808 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229479AbhC3F1n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 01:27:43 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BE93920582;
        Tue, 30 Mar 2021 07:27:42 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id aRXucJyQcfOr; Tue, 30 Mar 2021 07:27:42 +0200 (CEST)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 519D3200A7;
        Tue, 30 Mar 2021 07:27:42 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Tue, 30 Mar 2021 07:27:42 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 30 Mar
 2021 07:27:41 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 492973180186; Tue, 30 Mar 2021 07:27:41 +0200 (CEST)
Date:   Tue, 30 Mar 2021 07:27:41 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <netdev@vger.kernel.org>
CC:     Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH ipsec v2] xfrm: Provide private skb extensions for
 segmented and hw offloaded ESP packets
Message-ID: <20210330052741.GD62598@gauss3.secunet.de>
References: <20210326084448.GA62598@gauss3.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210326084448.GA62598@gauss3.secunet.de>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 26, 2021 at 09:44:48AM +0100, Steffen Klassert wrote:
> Commit 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec
> crypto offload.") added a XFRM_XMIT flag to avoid duplicate ESP trailer
> insertion on HW offload. This flag is set on the secpath that is shared
> amongst segments. This lead to a situation where some segments are
> not transformed correctly when segmentation happens at layer 3.
> 
> Fix this by using private skb extensions for segmented and hw offloaded
> ESP packets.
> 
> Fixes: 94579ac3f6d0 ("xfrm: Fix double ESP trailer insertion in IPsec crypto offload.")
> Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>

Now applied to the ipsec tree.
