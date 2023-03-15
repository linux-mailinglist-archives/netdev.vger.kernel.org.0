Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA956BAE8F
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 12:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjCOLGy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 07:06:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230522AbjCOLGj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 07:06:39 -0400
Received: from a.mx.secunet.com (a.mx.secunet.com [62.96.220.36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719E682343
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 04:06:31 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by a.mx.secunet.com (Postfix) with ESMTP id E3E0620539;
        Wed, 15 Mar 2023 12:06:29 +0100 (CET)
X-Virus-Scanned: by secunet
Received: from a.mx.secunet.com ([127.0.0.1])
        by localhost (a.mx.secunet.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 8E7xxjKhuhBN; Wed, 15 Mar 2023 12:06:29 +0100 (CET)
Received: from mailout2.secunet.com (mailout2.secunet.com [62.96.220.49])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by a.mx.secunet.com (Postfix) with ESMTPS id 72A2C20533;
        Wed, 15 Mar 2023 12:06:29 +0100 (CET)
Received: from cas-essen-02.secunet.de (unknown [10.53.40.202])
        by mailout2.secunet.com (Postfix) with ESMTP id 63D4180004A;
        Wed, 15 Mar 2023 12:06:29 +0100 (CET)
Received: from mbx-essen-01.secunet.de (10.53.40.197) by
 cas-essen-02.secunet.de (10.53.40.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Wed, 15 Mar 2023 12:06:29 +0100
Received: from gauss2.secunet.de (10.182.7.193) by mbx-essen-01.secunet.de
 (10.53.40.197) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.17; Wed, 15 Mar
 2023 12:06:29 +0100
Received: by gauss2.secunet.de (Postfix, from userid 1000)
        id D0C4F3183BF1; Wed, 15 Mar 2023 12:06:28 +0100 (CET)
Date:   Wed, 15 Mar 2023 12:06:28 +0100
From:   Steffen Klassert <steffen.klassert@secunet.com>
To:     Herbert Xu <herbert@gondor.apana.org.au>
CC:     <netdev@vger.kernel.org>
Subject: Re: [PATCH] xfrm: Remove inner/outer modes from output path
Message-ID: <ZBGmtKFTYbQJSgEy@gauss3.secunet.de>
References: <ZAr7EHeGkqVUr+z5@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <ZAr7EHeGkqVUr+z5@gondor.apana.org.au>
X-ClientProxiedBy: cas-essen-02.secunet.de (10.53.40.202) To
 mbx-essen-01.secunet.de (10.53.40.197)
X-EXCLAIMER-MD-CONFIG: 2c86f778-e09b-4440-8b15-867914633a10
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 10, 2023 at 05:40:32PM +0800, Herbert Xu wrote:
> The inner/outer modes were added to abstract out common code that
> were once duplicated between IPv4 and IPv6.  As time went on the
> abstractions have been removed and we are now left with empty
> shells that only contain duplicate information.  These can be
> removed one-by-one as the same information is already present
> elsewhere in the xfrm_state object.
> 
> Just like the input-side, removing this from the output code
> makes it possible to use transport-mode SAs underneath an
> inter-family tunnel mode SA.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

Also applied to ipsec-next, thanks a lot!
