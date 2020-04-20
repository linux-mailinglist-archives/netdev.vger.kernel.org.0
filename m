Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC171B06B7
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:39:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDTKj1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:39:27 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33628 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTKj1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:39:27 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C18202058E;
        Mon, 20 Apr 2020 12:39:25 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id dDGBqaVWbeSI; Mon, 20 Apr 2020 12:39:25 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 615AD20491;
        Mon, 20 Apr 2020 12:39:25 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 20 Apr 2020 12:39:25 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:39:24 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 91AFE31800B3; Mon, 20 Apr 2020 12:39:24 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:39:24 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec] xfrm: remove the xfrm_state_put call becofe going
 to out_reset
Message-ID: <20200420103924.GH13121@gauss3.secunet.de>
References: <f0609f4a5b90fa6cdfffc5b3b68b9f9014770ea0.1586509704.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <f0609f4a5b90fa6cdfffc5b3b68b9f9014770ea0.1586509704.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 10, 2020 at 05:08:24PM +0800, Xin Long wrote:
> This xfrm_state_put call in esp4/6_gro_receive() will cause
> double put for state, as in out_reset path secpath_reset()
> will put all states set in skb sec_path.
> 
> So fix it by simply remove the xfrm_state_put call.
> 
> Fixes: 6ed69184ed9c ("xfrm: Reset secpath in xfrm failure")
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Also applied, thanks a lot Xin!
