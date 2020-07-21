Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85417227896
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 08:07:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726074AbgGUGGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 02:06:23 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:35182 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726003AbgGUGGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 21 Jul 2020 02:06:22 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 3DE262051F;
        Tue, 21 Jul 2020 08:06:21 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id kWVG21K86vQA; Tue, 21 Jul 2020 08:06:20 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id CA6142018D;
        Tue, 21 Jul 2020 08:06:20 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 mail-essen-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Tue, 21 Jul 2020 08:06:20 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 21 Jul
 2020 08:06:20 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 238A731801E1;
 Tue, 21 Jul 2020 08:06:20 +0200 (CEST)
Date:   Tue, 21 Jul 2020 08:06:20 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec 0/3] xfrm: a few fixes for espintcp
Message-ID: <20200721060620.GH20687@gauss3.secunet.de>
References: <cover.1594287359.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cover.1594287359.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 16, 2020 at 10:09:00AM +0200, Sabrina Dubroca wrote:
> Andrew Cagney reported some issues when trying to use async operations
> on the encapsulation socket. Patches 1 and 2 take care of these bugs.
> 
> In addition, I missed a spot when adding IPv6 support and converting
> to the common config option.
> 
> Sabrina Dubroca (3):
>   espintcp: support non-blocking sends
>   espintcp: recv() should return 0 when the peer socket is closed
>   xfrm: policy: fix IPv6-only espintcp

All applied, thanks a lot Sabrina!
