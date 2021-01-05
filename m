Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1C542EA659
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 09:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727288AbhAEINA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 03:13:00 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:39444 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726889AbhAEIM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Jan 2021 03:12:59 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 5E48220299;
        Tue,  5 Jan 2021 09:12:18 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id MAd403n-vpAI; Tue,  5 Jan 2021 09:12:03 +0100 (CET)
Received: from mail-essen-02.secunet.de (unknown [10.53.40.205])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 2229B20270;
        Tue,  5 Jan 2021 09:12:03 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 mail-essen-02.secunet.de (10.53.40.205) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 5 Jan 2021 09:11:57 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2044.4; Tue, 5 Jan 2021
 09:11:57 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id A3ED73180C94;
 Tue,  5 Jan 2021 09:11:56 +0100 (CET)
Date:   Tue, 5 Jan 2021 09:11:56 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Visa Hankala <visa@hankala.org>
CC:     Florian Westphal <fw@strlen.de>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v2] xfrm: Fix wraparound in xfrm_policy_addr_delta()
Message-ID: <20210105081156.GJ3576117@gauss3.secunet.de>
References: <20201230160902.sYeDeDSVSPay2WBC@hankala.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20201230160902.sYeDeDSVSPay2WBC@hankala.org>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 30, 2020 at 04:15:53PM +0000, Visa Hankala wrote:
> Use three-way comparison for address components to avoid integer
> wraparound in the result of xfrm_policy_addr_delta(). This ensures
> that the search trees are built and traversed correctly.
> 
> Treat IPv4 and IPv6 similarly by returning 0 when prefixlen == 0.
> Prefix /0 has only one equivalence class.
> 
> Fixes: 9cf545ebd591d ("xfrm: policy: store inexact policies in a tree ordered by destination address")
> Signed-off-by: Visa Hankala <visa@hankala.org>

Applied, thanks a lot!
