Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8837A5C9A5
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 09:00:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726105AbfGBHAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 03:00:21 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:42778 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725775AbfGBHAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 2 Jul 2019 03:00:19 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 57658201C1;
        Tue,  2 Jul 2019 09:00:18 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id nCP9yRAEWKps; Tue,  2 Jul 2019 09:00:17 +0200 (CEST)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id E78F5201AA;
        Tue,  2 Jul 2019 09:00:17 +0200 (CEST)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Tue, 2 Jul 2019
 09:00:17 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 84D713180529;
 Tue,  2 Jul 2019 09:00:17 +0200 (CEST)
Date:   Tue, 2 Jul 2019 09:00:17 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Florian Westphal <fw@strlen.de>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next] xfrm: remove get_mtu indirection from
 xfrm_type
Message-ID: <20190702070017.GH17989@gauss3.secunet.de>
References: <20190624200448.8753-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20190624200448.8753-1-fw@strlen.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 10:04:48PM +0200, Florian Westphal wrote:
> esp4_get_mtu and esp6_get_mtu are exactly the same, the only difference
> is a single sizeof() (ipv4 vs. ipv6 header).
> 
> Merge both into xfrm_state_mtu() and remove the indirection.
> 
> Signed-off-by: Florian Westphal <fw@strlen.de>

Applied, thanks a lot!
