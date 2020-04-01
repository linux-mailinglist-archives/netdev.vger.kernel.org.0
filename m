Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 598A219A8B8
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 11:34:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732143AbgDAJeM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 05:34:12 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51000 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726205AbgDAJeL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 05:34:11 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B8A9C2051F;
        Wed,  1 Apr 2020 11:34:10 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id JvRFFgboYyac; Wed,  1 Apr 2020 11:34:10 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 5EA32200A0;
        Wed,  1 Apr 2020 11:34:10 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by cas-essen-02.secunet.de
 (10.53.40.202) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 1 Apr 2020
 11:34:10 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D97E131800A4; Wed,  1 Apr 2020 11:34:09 +0200 (CEST)
Date:   Wed, 1 Apr 2020 11:34:09 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Xin Long <lucien.xin@gmail.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sabrina Dubroca <sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 0/5] xfrm: support ipv6 nexthdrs process in
 transport and beet modes
Message-ID: <20200401093409.GV13121@gauss3.secunet.de>
References: <cover.1585731430.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1585731430.git.lucien.xin@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 cas-essen-02.secunet.de (10.53.40.202)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 01, 2020 at 04:59:20PM +0800, Xin Long wrote:
> For esp transport and beet modes, when the inner ipv6 nexthdrs
> are set, the 'proto' and 'transport_header' are needed to fix
> in some places, so that the packet can be sent and received
> properly, and no panicks are caused.

Please separate the fixes and send them for inclusion
into the ipsec tree. Everything else has to wait until
after the merge window. net-next is closed and so is
ipsec-next.

Thanks!

