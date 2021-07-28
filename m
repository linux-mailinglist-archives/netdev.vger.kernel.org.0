Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8FF23D8851
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 08:55:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhG1Gzk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 02:55:40 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:54316 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbhG1Gzk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 02:55:40 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout2.secunet.com (Postfix) with ESMTP id 9CDB9800058;
        Wed, 28 Jul 2021 08:55:37 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 28 Jul 2021 08:55:37 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 28 Jul
 2021 08:55:37 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D3F7E3183CB7; Wed, 28 Jul 2021 08:55:36 +0200 (CEST)
Date:   Wed, 28 Jul 2021 08:55:36 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Harshvardhan Jha <harshvardhan.jha@oracle.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net] net: xfrm: Fix end of loop tests for
 list_for_each_entry
Message-ID: <20210728065536.GQ893739@gauss3.secunet.de>
References: <20210725175354.59137-1-harshvardhan.jha@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210725175354.59137-1-harshvardhan.jha@oracle.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 25, 2021 at 11:23:55PM +0530, Harshvardhan Jha wrote:
> The list_for_each_entry() iterator, "pos" in this code, can never be
> NULL so the warning will never be printed.
> 
> Signed-off-by: Harshvardhan Jha <harshvardhan.jha@oracle.com>

Applied, thanks!
