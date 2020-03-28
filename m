Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 452031965B3
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 12:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726325AbgC1LXF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Mar 2020 07:23:05 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:33316 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725973AbgC1LXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Mar 2020 07:23:05 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id D0B382026E;
        Sat, 28 Mar 2020 12:23:03 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id oQgVZv6pDhUT; Sat, 28 Mar 2020 12:23:03 +0100 (CET)
Received: from mail-essen-01.secunet.de (mail-essen-01.secunet.de [10.53.40.204])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 68F54201E4;
        Sat, 28 Mar 2020 12:23:03 +0100 (CET)
Received: from mbx-dresden-01.secunet.de (10.53.40.199) by
 MAIL-ESSEN-01.secunet.de (10.53.40.204) with Microsoft SMTP Server (TLS) id
 14.3.487.0; Sat, 28 Mar 2020 12:23:03 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-dresden-01.secunet.de
 (10.53.40.199) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Sat, 28 Mar
 2020 12:23:02 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)      id 1433931801E6;
 Sat, 28 Mar 2020 12:23:02 +0100 (CET)
Date:   Sat, 28 Mar 2020 12:23:02 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     YueHaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] xfrm: policy: Remove obsolete WARN while xfrm
 policy inserting
Message-ID: <20200328112302.GA13121@gauss3.secunet.de>
References: <20200327123443.12408-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20200327123443.12408-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-dresden-01.secunet.de (10.53.40.199)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 08:34:43PM +0800, YueHaibing wrote:
> Since commit 7cb8a93968e3 ("xfrm: Allow inserting policies with matching
> mark and different priorities"), we allow duplicate policies with
> different priority, this WARN is not needed any more.

Can you please describe a bit more detailed why this warning
can't trigger anymore?

Thanks!
