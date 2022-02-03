Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC5BB4A7F56
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 07:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242230AbiBCGir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 01:38:47 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:37532 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231539AbiBCGiq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Feb 2022 01:38:46 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 6CB9F20504;
        Thu,  3 Feb 2022 07:38:45 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ekn13XEsIt9S; Thu,  3 Feb 2022 07:38:45 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 044CF2049A;
        Thu,  3 Feb 2022 07:38:45 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id F10BE80004A;
        Thu,  3 Feb 2022 07:38:44 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Thu, 3 Feb 2022 07:38:44 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17; Thu, 3 Feb
 2022 07:38:44 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 05C993180F5E; Thu,  3 Feb 2022 07:38:43 +0100 (CET)
Date:   Thu, 3 Feb 2022 07:38:43 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Leon Romanovsky <leon@kernel.org>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S . Miller" <davem@davemloft.net>,
        Leon Romanovsky <leonro@nvidia.com>, <netdev@vger.kernel.org>,
        Shannon Nelson <shannon.nelson@oracle.com>
Subject: Re: [PATCH ipsec-next v1] xfrm: delete duplicated functions that
 calls same xfrm_api_check()
Message-ID: <20220203063843.GV1223722@gauss3.secunet.de>
References: <386b408e7a1b26b2c40719fe7c48902cd0000947.1643700764.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <386b408e7a1b26b2c40719fe7c48902cd0000947.1643700764.git.leonro@nvidia.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 01, 2022 at 09:35:28AM +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The xfrm_dev_register() and xfrm_dev_feat_change() have same
> implementation of one call to xfrm_api_check(). Instead of doing such
> indirection, call to xfrm_api_check() directly and delete duplicated
> functions.
> 
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Applied, thanks a lot Leon!
