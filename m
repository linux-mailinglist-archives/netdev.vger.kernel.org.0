Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CA0145D73B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 10:32:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354068AbhKYJfy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 04:35:54 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37152 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346753AbhKYJdy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 04:33:54 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id BCB5B20561;
        Thu, 25 Nov 2021 10:30:41 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 5AGH22_kGffP; Thu, 25 Nov 2021 10:30:41 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 3258B20189;
        Thu, 25 Nov 2021 10:30:41 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 2C9CB80004A;
        Thu, 25 Nov 2021 10:30:41 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 25 Nov 2021 10:30:41 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 25 Nov
 2021 10:30:40 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 8F61F3180F41; Thu, 25 Nov 2021 10:30:40 +0100 (CET)
Date:   Thu, 25 Nov 2021 10:30:40 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <davem@davemloft.net>, <herbert@gondor.apana.org.au>,
        <kuba@kernel.org>, <antony.antony@secunet.com>,
        <netdev@vger.kernel.org>, <stable@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: fix dflt policy check when there is no
 policy configured
Message-ID: <20211125093040.GD427717@gauss3.secunet.de>
References: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 22, 2021 at 11:33:13AM +0100, Nicolas Dichtel wrote:
> When there is no policy configured on the system, the default policy is
> checked in xfrm_route_forward. However, it was done with the wrong
> direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).
> The default policy for XFRM_POLICY_FWD was checked just before, with a call
> to xfrm[46]_policy_check().
> 
> CC: stable@vger.kernel.org
> Fixes: 2d151d39073a ("xfrm: Add possibility to set the default to block if we have no policy")
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks Nicolas!
