Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25DC43A5F92
	for <lists+netdev@lfdr.de>; Mon, 14 Jun 2021 11:57:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232743AbhFNJ7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 05:59:45 -0400
Received: from mailout1.secunet.com ([62.96.220.44]:48268 "EHLO
        mailout1.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232718AbhFNJ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 05:59:44 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout1.secunet.com (Postfix) with ESMTP id 6BCDF800053;
        Mon, 14 Jun 2021 11:57:40 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 14 Jun 2021 11:57:40 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Mon, 14 Jun
 2021 11:57:40 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id C1CE13180609; Mon, 14 Jun 2021 11:57:39 +0200 (CEST)
Date:   Mon, 14 Jun 2021 11:57:39 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: delete xfrm4_output_finish xfrm6_output_finish
 declarations
Message-ID: <20210614095739.GW40979@gauss3.secunet.de>
References: <d65237e307458f84e33687bff5be9fd93d6b375b.1623332566.git.antony.antony@secunet.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <d65237e307458f84e33687bff5be9fd93d6b375b.1623332566.git.antony.antony@secunet.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 03:46:38PM +0200, Antony Antony wrote:
> These function declarations are not needed any more.
> The definitions wer deleted.
> 
> Fixes: 2ab6096db2f1 ("xfrm: remove output_finish indirection from xfrm_state_afinfo")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Your patch does not apply to ipsec-next, can you please rebase?

Thanks!
