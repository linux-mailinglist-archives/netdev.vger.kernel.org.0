Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6ADC253EA2
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 09:08:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727930AbgH0HIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 03:08:50 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:51924 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726123AbgH0HIt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Aug 2020 03:08:49 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id B9DC62054D;
        Thu, 27 Aug 2020 09:08:48 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 75Luh-0ETqtC; Thu, 27 Aug 2020 09:08:48 +0200 (CEST)
Received: from cas-essen-01.secunet.de (201.40.53.10.in-addr.arpa [10.53.40.201])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 57C89201E2;
        Thu, 27 Aug 2020 09:08:48 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 27 Aug 2020 09:08:48 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 27 Aug
 2020 09:08:48 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id ACECA31803E0; Thu, 27 Aug 2020 09:08:47 +0200 (CEST)
Date:   Thu, 27 Aug 2020 09:08:47 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>, Xiumei Mu <xmu@redhat.com>
Subject: Re: [PATCH ipsec] xfrmi: drop ignore_df check before updating pmtu
Message-ID: <20200827070847.GB20687@gauss3.secunet.de>
References: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <70e7c2a65afed5de117dbc16082def459bd39d93.1596531053.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:37:29AM +0200, Sabrina Dubroca wrote:
> xfrm interfaces currently test for !skb->ignore_df when deciding
> whether to update the pmtu on the skb's dst. Because of this, no pmtu
> exception is created when we do something like:
> 
>     ping -s 1438 <dest>
> 
> By dropping this check, the pmtu exception will be created and the
> next ping attempt will work.
> 
> Fixes: f203b76d7809 ("xfrm: Add virtual xfrm interfaces")
> Reported-by: Xiumei Mu <xmu@redhat.com>
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Patch applied, thanks Sabrina!
