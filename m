Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 192B92F0DE1
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 09:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727841AbhAKIWK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 03:22:10 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:57892 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727716AbhAKIWJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 03:22:09 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9A687201D5;
        Mon, 11 Jan 2021 09:21:28 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 2L34vPh9_krO; Mon, 11 Jan 2021 09:21:28 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 69E262027C;
        Mon, 11 Jan 2021 09:21:08 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 11 Jan 2021 09:21:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Mon, 11 Jan
 2021 09:21:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id BB0D2318028B; Mon, 11 Jan 2021 09:21:01 +0100 (CET)
Date:   Mon, 11 Jan 2021 09:21:01 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Eyal Birger <eyal.birger@gmail.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <shmulik.ladkani@gmail.com>
Subject: Re: [PATCH ipsec-next] xfrm: interface: enable TSO on xfrm interfaces
Message-ID: <20210111082101.GA3576117@gauss3.secunet.de>
References: <20210106061046.3226495-1-eyal.birger@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210106061046.3226495-1-eyal.birger@gmail.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 06, 2021 at 08:10:46AM +0200, Eyal Birger wrote:
> Underlying xfrm output supports gso packets.
> Declare support in hw_features and adapt the xmit MTU check to pass GSO
> packets.
> 
> Signed-off-by: Eyal Birger <eyal.birger@gmail.com>

Applied, thanks a lot Eyal!
