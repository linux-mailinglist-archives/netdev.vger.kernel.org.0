Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A763F68BB8F
	for <lists+netdev@lfdr.de>; Mon,  6 Feb 2023 12:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbjBFLdW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Feb 2023 06:33:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbjBFLdQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Feb 2023 06:33:16 -0500
Received: from formenos.hmeau.com (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7997413D52;
        Mon,  6 Feb 2023 03:33:14 -0800 (PST)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1pOye6-007zks-J4; Mon, 06 Feb 2023 18:22:47 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 06 Feb 2023 18:22:46 +0800
From:   "Herbert Xu" <herbert@gondor.apana.org.au>
Date:   Mon, 06 Feb 2023 18:22:46 +0800
Subject: [PATCH 17/17] crypto: api - Remove completion function scaffolding
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
To:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Tyler Hicks <code@tyhicks.com>, ecryptfs@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        Boris Pismenny <borisp@nvidia.com>,
        John Fastabend <john.fastabend@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jarkko Sakkinen <jarkko@kernel.org>, keyrings@vger.kernel.org
Message-Id: <E1pOye6-007zks-J4@formenos.hmeau.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,PDS_RDNS_DYNAMIC_FP,
        RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch removes the temporary scaffolding now that the comletion
function signature has been converted.

Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
---

 include/linux/crypto.h |    6 ------
 1 file changed, 6 deletions(-)

diff --git a/include/linux/crypto.h b/include/linux/crypto.h
index 80f6350fb588..bb1d9b0e1647 100644
--- a/include/linux/crypto.h
+++ b/include/linux/crypto.h
@@ -176,7 +176,6 @@ struct crypto_async_request;
 struct crypto_tfm;
 struct crypto_type;
 
-typedef void crypto_completion_data_t;
 typedef void (*crypto_completion_t)(void *req, int err);
 
 /**
@@ -596,11 +595,6 @@ struct crypto_wait {
 /*
  * Async ops completion helper functioons
  */
-static inline void *crypto_get_completion_data(void *data)
-{
-	return data;
-}
-
 void crypto_req_done(void *req, int err);
 
 static inline int crypto_wait_req(int err, struct crypto_wait *wait)
