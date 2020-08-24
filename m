Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2B124F249
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 08:00:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727050AbgHXGAr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 02:00:47 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:36364 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbgHXGAr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 02:00:47 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 2D4612019C;
        Mon, 24 Aug 2020 08:00:45 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id TeOai3UcWywU; Mon, 24 Aug 2020 08:00:44 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id C0880200A0;
        Mon, 24 Aug 2020 08:00:44 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 24 Aug 2020 08:00:44 +0200
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 24 Aug
 2020 08:00:44 +0200
Date:   Mon, 24 Aug 2020 08:00:38 +0200
From:   Antony Antony <antony.antony@secunet.com>
To:     David Miller <davem@davemloft.net>
CC:     <antony.antony@secunet.com>, <steffen.klassert@secunet.com>,
        <netdev@vger.kernel.org>, <herbert@gondor.apana.org.au>,
        <smueller@chronox.de>, <antony@phenome.org>
Subject: Re: [PATCH ipsec-next v3] xfrm: add
 /proc/sys/core/net/xfrm_redact_secret
Message-ID: <20200824060038.GA24035@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20200728154342.GA31835@moon.secunet.de>
 <20200820183549.GA823@moon.secunet.de>
 <20200820.154222.114300229292925699.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200820.154222.114300229292925699.davem@davemloft.net>
Organization: secunet
User-Agent: Mutt/1.10.1 (2018-07-13)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 20, 2020 at 15:42:22 -0700, David Miller wrote:
> From: Antony Antony <antony.antony@secunet.com>
> Date: Thu, 20 Aug 2020 20:35:49 +0200
> 
> > Redacting secret is a FIPS 140-2 requirement.
> 
> Why not control this via the kernel lockdown mode rather than making
> an ad-hoc API for this? 

Let me try to use kernel lockdown mode. thanks for the idea. 

From a quick googling I guess it would be part of "lockdown= confidentiality".
I wonder if kernel lockdown would allow disabling just this one feature independent of other lockdowns.

-antony
