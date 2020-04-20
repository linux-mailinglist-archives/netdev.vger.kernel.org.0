Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3EFA1B06BE
	for <lists+netdev@lfdr.de>; Mon, 20 Apr 2020 12:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725971AbgDTKlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Apr 2020 06:41:17 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33736 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725773AbgDTKlQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 20 Apr 2020 06:41:16 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id C76EE205B5;
        Mon, 20 Apr 2020 12:41:15 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id GcvEOdvyev8r; Mon, 20 Apr 2020 12:41:15 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 631732058E;
        Mon, 20 Apr 2020 12:41:15 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Mon, 20 Apr 2020 12:41:15 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Apr
 2020 12:41:14 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 8B25431800B3;
 Mon, 20 Apr 2020 12:41:14 +0200 (CEST)
Date:   Mon, 20 Apr 2020 12:41:14 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Sabrina Dubroca <sd@queasysnail.net>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: espintcp: save and call old ->sk_destruct
Message-ID: <20200420104114.GJ13121@gauss3.secunet.de>
References: <bb90145107e53739544bd7f2190eac26fdd4cd3c.1587050109.git.sd@queasysnail.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <bb90145107e53739544bd7f2190eac26fdd4cd3c.1587050109.git.sd@queasysnail.net>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 16, 2020 at 05:45:44PM +0200, Sabrina Dubroca wrote:
> When ESP encapsulation is enabled on a TCP socket, I'm replacing the
> existing ->sk_destruct callback with espintcp_destruct. We still need to
> call the old callback to perform the other cleanups when the socket is
> destroyed. Save the old callback, and call it from espintcp_destruct.
> 
> Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
> Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>

Applied, thanks Sabrina!
