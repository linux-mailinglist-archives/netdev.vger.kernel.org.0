Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE31245D52B
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 08:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353224AbhKYHMW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 02:12:22 -0500
Received: from a.mx.secunet.com ([62.96.220.36]:55736 "EHLO a.mx.secunet.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1349807AbhKYHKW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 02:10:22 -0500
X-Greylist: delayed 554 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Nov 2021 02:10:21 EST
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 7163E201A0;
        Thu, 25 Nov 2021 07:57:55 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ZyB1Td4YeDTv; Thu, 25 Nov 2021 07:57:54 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id DF09420185;
        Thu, 25 Nov 2021 07:57:54 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id CEA9180004A;
        Thu, 25 Nov 2021 07:57:54 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Thu, 25 Nov 2021 07:57:54 +0100
Received: from moon.secunet.de (172.18.26.122) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.14; Thu, 25 Nov
 2021 07:57:54 +0100
Date:   Thu, 25 Nov 2021 07:57:52 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <steffen.klassert@secunet.com>, <davem@davemloft.net>,
        <herbert@gondor.apana.org.au>, <kuba@kernel.org>,
        <antony.antony@secunet.com>, <netdev@vger.kernel.org>,
        <stable@vger.kernel.org>
Subject: Re: [PATCH ipsec] xfrm: fix dflt policy check when there is no
 policy configured
Message-ID: <YZ8z8KPXZyiPLahh@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20211122103313.1331-1-nicolas.dichtel@6wind.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Nicolas,

On Mon, Nov 22, 2021 at 11:33:13 +0100, Nicolas Dichtel wrote:
> When there is no policy configured on the system, the default policy is
> checked in xfrm_route_forward. However, it was done with the wrong
> direction (XFRM_POLICY_FWD instead of XFRM_POLICY_OUT).

How can I reproduce this? 
I tried adding fwd block and no policy and that blocked the forwarded traffic.
I ran into another issue with fwd block and and tunnel. I will double check. Next week.
