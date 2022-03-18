Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 582204DD4B0
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 07:28:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbiCRG33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 02:29:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232716AbiCRG31 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 02:29:27 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B9241118
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 23:27:57 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 4D30E20621;
        Fri, 18 Mar 2022 07:27:54 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 71bF0qk3GyP2; Fri, 18 Mar 2022 07:27:53 +0100 (CET)
Received: from mailout1.secunet.com (mailout1.secunet.com [62.96.220.44])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id D5D1E2061E;
        Fri, 18 Mar 2022 07:27:53 +0100 (CET)
Received: from cas-essen-01.secunet.de (unknown [10.53.40.201])
        by mailout1.secunet.com (Postfix) with ESMTP id CE8A480004A;
        Fri, 18 Mar 2022 07:27:53 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-01.secunet.de (10.53.40.201) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 18 Mar 2022 07:27:53 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Fri, 18 Mar
 2022 07:27:53 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id 503AC3180625; Fri, 18 Mar 2022 07:27:53 +0100 (CET)
Date:   Fri, 18 Mar 2022 07:27:53 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <herbert@gondor.apana.org.au>, <antony.antony@secunet.com>,
        <leon@kernel.org>, <davem@davemloft.net>, <kuba@kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v2] xfrm: rework default policy structure
Message-ID: <20220318062753.GL90740@gauss3.secunet.de>
References: <YZpSlpVuE9G+Ebh4@unreal>
 <20220314103822.31720-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220314103822.31720-1-nicolas.dichtel@6wind.com>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:38:22AM +0100, Nicolas Dichtel wrote:
> This is a follow up of commit f8d858e607b2 ("xfrm: make user policy API
> complete"). The goal is to align userland API to the internal structures.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Applied, thanks a lot Nicolas!
