Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4111324F4A8
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 10:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728606AbgHXIjJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 04:39:09 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:43742 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728594AbgHXIjE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 04:39:04 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4CCD42019C;
        Mon, 24 Aug 2020 10:39:02 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q6w4bC1Uc_WN; Mon, 24 Aug 2020 10:39:01 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E12B12006F;
        Mon, 24 Aug 2020 10:39:01 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Mon, 24 Aug 2020 10:39:01 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 24 Aug
 2020 10:39:01 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 3E67C3180449; Mon, 24 Aug 2020 10:39:01 +0200 (CEST)
Date:   Mon, 24 Aug 2020 10:39:01 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH 1/3] xfrm: clone XFRMA_SET_MARK during xfrm_do_migrate
Message-ID: <20200824083901.GN20687@gauss3.secunet.de>
References: <20200820181158.GA19658@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200820181158.GA19658@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 08:11:58PM +0200, Antony Antony wrote:
> XFRMA_SET_MARK and XFRMA_SET_MARK_MASK was not cloned from the old
> to the new. Migrate these two attributes during XFRMA_MSG_MIGRATE
> 
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

Please add a 'Fixes' tag so that this can be backported
properly to the stable trees.
