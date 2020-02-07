Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A533B1554E8
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 10:41:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgBGJlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 04:41:31 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:34368 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726451AbgBGJlb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Feb 2020 04:41:31 -0500
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 04E3A204B4;
        Fri,  7 Feb 2020 10:41:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 99m13qu_TENk; Fri,  7 Feb 2020 10:41:27 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 95E0C2055E;
        Fri,  7 Feb 2020 10:41:27 +0100 (CET)
Received: from gauss2.secunet.de (10.182.7.193) by mail-essen-01.secunet.de
 (10.53.40.204) with Microsoft SMTP Server id 14.3.439.0; Fri, 7 Feb 2020
 10:41:27 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 4000C31803BE;
 Fri,  7 Feb 2020 10:41:27 +0100 (CET)
Date:   Fri, 7 Feb 2020 10:41:27 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Raed Salem <raeds@mellanox.com>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH net] xfrm: handle NETDEV_UNREGISTER for xfrm device
Message-ID: <20200207094127.GE3469@gauss3.secunet.de>
References: <1580642374-20942-1-git-send-email-raeds@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1580642374-20942-1-git-send-email-raeds@mellanox.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 02, 2020 at 01:19:34PM +0200, Raed Salem wrote:
> This patch to handle the asynchronous unregister
> device event so the device IPsec offload resources
> could be cleanly released.
> 
> Fixes: e4db5b61c572 ("xfrm: policy: remove pcpu policy cache")
> Signed-off-by: Raed Salem <raeds@mellanox.com>
> Reviewed-by: Boris Pismenny <borisp@mellanox.com>
> Reviewed-by: Saeed Mahameed <saeedm@mellanox.com>

Patch applied, thanks Raed!
