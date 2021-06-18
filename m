Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F373AC4F8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 09:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232282AbhFRH2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 03:28:00 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:55626 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231558AbhFRH17 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 03:27:59 -0400
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id 6D352800053;
        Fri, 18 Jun 2021 09:25:49 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 18 Jun 2021 09:25:49 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 18 Jun
 2021 09:25:49 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D42ED3180428; Fri, 18 Jun 2021 09:25:48 +0200 (CEST)
Date:   Fri, 18 Jun 2021 09:25:48 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: delete xfrm4_output_finish xfrm6_output_finish
 declarations
Message-ID: <20210618072548.GS40979@gauss3.secunet.de>
References: <d65237e307458f84e33687bff5be9fd93d6b375b.1623332566.git.antony.antony@secunet.com>
 <ff67f5acbb4060a3c89953687488e96cb40fa862.1623741174.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ff67f5acbb4060a3c89953687488e96cb40fa862.1623741174.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 15, 2021 at 09:20:08AM +0200, Antony Antony wrote:
> These function declarations are not needed any more.
> The definitions were deleted.
> 
> Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Applied to ipsec-next, thanks Antony!
