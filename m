Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7D92626EA
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 07:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726111AbgIIFyj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 01:54:39 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:53682 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725807AbgIIFyi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 01:54:38 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E459220411;
        Wed,  9 Sep 2020 07:54:36 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id XJP1OedLaJC3; Wed,  9 Sep 2020 07:54:36 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 862242009B;
        Wed,  9 Sep 2020 07:54:36 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Wed, 9 Sep 2020 07:54:36 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Wed, 9 Sep 2020
 07:54:36 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CFAF0318064B; Wed,  9 Sep 2020 07:54:35 +0200 (CEST)
Date:   Wed, 9 Sep 2020 07:54:35 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Antony Antony <antony.antony@secunet.com>
CC:     <netdev@vger.kernel.org>, Herbert Xu <herbert@gondor.apana.org.au>,
        "Antony Antony" <antony@phenome.org>
Subject: Re: [PATCH v3 1/4] xfrm: clone XFRMA_SET_MARK in xfrm_do_migrate
Message-ID: <20200909055435.GN20687@gauss3.secunet.de>
References: <20200820181158.GA19658@moon.secunet.de>
 <20200904064938.GA21496@moon.secunet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200904064938.GA21496@moon.secunet.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 04, 2020 at 08:49:38AM +0200, Antony Antony wrote:
> XFRMA_SET_MARK and XFRMA_SET_MARK_MASK was not cloned from the old
> to the new. Migrate these two attributes during XFRMA_MSG_MIGRATE
> 
> Fixes: 9b42c1f179a6 ("xfrm: Extend the output_mark to support input direction and masking.")
> Signed-off-by: Antony Antony <antony.antony@secunet.com>

All applied, thanks Antony!
