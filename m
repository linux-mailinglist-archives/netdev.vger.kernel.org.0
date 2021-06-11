Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B8CE3A3B7C
	for <lists+netdev@lfdr.de>; Fri, 11 Jun 2021 07:48:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230467AbhFKFuM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 01:50:12 -0400
Received: from mailout2.secunet.com ([62.96.220.49]:39000 "EHLO
        mailout2.secunet.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230001AbhFKFuL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 01:50:11 -0400
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 0F025800050;
        Fri, 11 Jun 2021 07:48:13 +0200 (CEST)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Fri, 11 Jun 2021 07:48:12 +0200
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Fri, 11 Jun
 2021 07:48:12 +0200
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 7835C3180609; Fri, 11 Jun 2021 07:48:12 +0200 (CEST)
Date:   Fri, 11 Jun 2021 07:48:12 +0200
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     <13145886936@163.com>
CC:     <herbert@gondor.apana.org.au>, <davem@davemloft.net>,
        <kuba@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        gushengxian <gushengxian@yulong.com>
Subject: Re: [PATCH] xfrm: policy: fix a spelling mistake
Message-ID: <20210611054812.GH1081744@gauss3.secunet.de>
References: <20210611004113.3373-1-13145886936@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20210611004113.3373-1-13145886936@163.com>
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 10, 2021 at 05:41:13PM -0700, 13145886936@163.com wrote:
> From: gushengxian <gushengxian@yulong.com>
> 
> Fix a spelling mistake.
> 
> Signed-off-by: gushengxian <gushengxian@yulong.com>

How often you want to submit that patch? You sent it already
three times in the last three days. It takes some days until
it gets applied, please be patient and wait.

Now applied to ipsec-next, thanks!
