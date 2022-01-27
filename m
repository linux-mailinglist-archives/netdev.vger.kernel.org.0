Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E0449DA87
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 07:20:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbiA0GUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 01:20:51 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57282 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233650AbiA0GUv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jan 2022 01:20:51 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B222B2057A;
        Thu, 27 Jan 2022 07:20:49 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 6O5qxejiMxxu; Thu, 27 Jan 2022 07:20:49 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 4390D20539;
        Thu, 27 Jan 2022 07:20:49 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 329EB80004A;
        Thu, 27 Jan 2022 07:20:49 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 27 Jan 2022 07:20:48 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 27 Jan
 2022 07:20:48 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 2E37731805DC; Thu, 27 Jan 2022 07:20:48 +0100 (CET)
Date:   Thu, 27 Jan 2022 07:20:48 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yan Yan <evitayan@google.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, <lorenzo@google.com>,
        <maze@google.com>, <nharold@google.com>, <benedictwong@google.com>
Subject: Re: [PATCH v2 0/2] Fix issues in xfrm_migrate
Message-ID: <20220127062048.GP1223722@gauss3.secunet.de>
References: <20220119000014.1745223-1-evitayan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220119000014.1745223-1-evitayan@google.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 18, 2022 at 04:00:12PM -0800, Yan Yan wrote:
> This patch series include two patches to fix two issues in xfrm_migrate.
> 
> PATCH 1/2 enables distinguishing SAs and SPs based on if_id during the
> xfrm_migrate flow. It fixes the problem that when there are multiple
> existing SPs with the same direction, the same xfrm_selector and
> different endpoint addresses, xfrm_migrate might fail.
> 
> PATCH 2/2 enables xfrm_migrate to handle address family change by
> breaking the original xfrm_state_clone method into two steps so as to
> update the props.family before running xfrm_init_state.
> 
> V1 -> V2:
> - Move xfrm_init_state() out of xfrm_state_clone()
> and called it after updating the address family
> 
> Yan Yan (2):
>   xfrm: Check if_id in xfrm_migrate
>   xfrm: Fix xfrm migrate issues when address family changes

Applied, thanks a lot Yan!
