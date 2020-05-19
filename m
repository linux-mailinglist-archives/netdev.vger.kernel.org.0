Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B6AD1D9299
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 10:54:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727987AbgESIx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 04:53:57 -0400
Received: from a.mx.secunet.com ([62.96.220.36]:57844 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726369AbgESIx5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 May 2020 04:53:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 0FB212052E;
        Tue, 19 May 2020 10:53:55 +0200 (CEST)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id LO34DyIrttZN; Tue, 19 May 2020 10:53:54 +0200 (CEST)
Received: from cas-essen-02.secunet.de (202.40.53.10.in-addr.arpa [10.53.40.202])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id AA08B200A3;
        Tue, 19 May 2020 10:53:54 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 19 May 2020 10:53:54 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Tue, 19 May
 2020 10:53:54 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id CAC3A3180167; Tue, 19 May 2020 10:53:53 +0200 (CEST)
Date:   Tue, 19 May 2020 10:53:53 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Yuehaibing <yuehaibing@huawei.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lucien.xin@gmail.com>
Subject: Re: [PATCH v2] xfrm: policy: Fix xfrm policy match
Message-ID: <20200519085353.GE13121@gauss3.secunet.de>
References: <20200421143149.45108-1-yuehaibing@huawei.com>
 <20200422125346.27756-1-yuehaibing@huawei.com>
 <0015ec4c-0e9c-a9d2-eb03-4d51c5fbbe86@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <0015ec4c-0e9c-a9d2-eb03-4d51c5fbbe86@huawei.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 15, 2020 at 04:39:57PM +0800, Yuehaibing wrote:
> 
> Friendly ping...
> 
> Any plan for this issue?

There was still no consensus between you and Xin on how
to fix this issue. Once this happens, I consider applying
a fix.

