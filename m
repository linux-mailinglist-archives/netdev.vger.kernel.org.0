Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A2A4D9651
	for <lists+netdev@lfdr.de>; Tue, 15 Mar 2022 09:33:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345967AbiCOIdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Mar 2022 04:33:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346401AbiCOId2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Mar 2022 04:33:28 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7938A4C415
        for <netdev@vger.kernel.org>; Tue, 15 Mar 2022 01:32:16 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id 9A233205A9;
        Tue, 15 Mar 2022 09:32:14 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id Xbv5UAsGbOPY; Tue, 15 Mar 2022 09:32:14 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 0041120504;
        Tue, 15 Mar 2022 09:32:14 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id EEB7180004A;
        Tue, 15 Mar 2022 09:32:13 +0100 (CET)
Received: from mbx-essen-02.secunet.de (10.53.40.198) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.18; Tue, 15 Mar 2022 09:32:13 +0100
Received: from moon.secunet.de (172.18.149.2) by mbx-essen-02.secunet.de
 (10.53.40.198) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.18; Tue, 15 Mar
 2022 09:32:12 +0100
Date:   Tue, 15 Mar 2022 09:32:06 +0100
From:   Antony Antony <antony.antony@secunet.com>
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
CC:     <steffen.klassert@secunet.com>, <herbert@gondor.apana.org.au>,
        <antony.antony@secunet.com>, <leon@kernel.org>,
        <davem@davemloft.net>, <kuba@kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH ipsec-next v2] xfrm: rework default policy structure
Message-ID: <YjBPBnWb43S/VzyU@moon.secunet.de>
Reply-To: <antony.antony@secunet.com>
References: <YZpSlpVuE9G+Ebh4@unreal>
 <20220314103822.31720-1-nicolas.dichtel@6wind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20220314103822.31720-1-nicolas.dichtel@6wind.com>
Organization: secunet
X-ClientProxiedBy: cas-essen-01.secunet.de (10.53.40.201) To
 mbx-essen-02.secunet.de (10.53.40.198)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 14, 2022 at 11:38:22 +0100, Nicolas Dichtel wrote:
> This is a follow up of commit f8d858e607b2 ("xfrm: make user policy API
> complete"). The goal is to align userland API to the internal structures.
> 
> Signed-off-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>

Reviewed-by:  Antony Antony <antony.antony@secunet.com>

I also ran few quick tests and it looks good.
thanks Nicolas.
-antony
