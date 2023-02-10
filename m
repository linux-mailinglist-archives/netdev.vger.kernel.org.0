Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABEEB6915F3
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 01:58:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbjBJA6n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Feb 2023 19:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230507AbjBJA6a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Feb 2023 19:58:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366D26F21E;
        Thu,  9 Feb 2023 16:56:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0409B82396;
        Fri, 10 Feb 2023 00:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12C5DC433D2;
        Fri, 10 Feb 2023 00:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675990596;
        bh=UTrvq3REz/kAUwMAFaCstHYw0tMPg3KnvPd0o9YJkLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HV8CEHr46UOCKci7nGYdKPM/QYm9v/XyrqpLW8/mHRwM9AEk7A3DKLCityqv3U3oF
         T7F2DL12j2lN4buNSTjzMieLxmMx1wT3S+/4hV5m3pO2gw+peyj9mkpYnfEoJudvkm
         nZIAs0ycm1EmVMdd/I7WZIhIX8TdjfycB3Iq8yeQIFbZAK97h3Z93DSHedZ6fYeATD
         5w8CojJysiR0LaUjw8zPH4dj5Elyj9bRvYnxsOjBRa0FHN8Ow0mg1Mev144pGARBDl
         z3g09QORCTaxPT82xqTNBPw5pYe3qq6352wXnK+JInqbg4D4R25CnHecGKr+dInt1V
         QMJyeuh6dN5EA==
Date:   Fri, 10 Feb 2023 02:56:34 +0200
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
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
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Subject: Re: [PATCH 17/17] crypto: api - Remove completion function
 scaffolding
Message-ID: <Y+WWQgP/qTmLN42m@kernel.org>
References: <Y+DUkqe1sagWaErA@gondor.apana.org.au>
 <E1pOye6-007zks-J4@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1pOye6-007zks-J4@formenos.hmeau.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 06, 2023 at 06:22:46PM +0800, Herbert Xu wrote:
> This patch removes the temporary scaffolding now that the comletion
> function signature has been converted.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

For the 1-17:

Acked-by: Jarkko Sakkinen <jarkko@kernel.org>

(nit applies tho to all of them but use your own judgement i guess)

> ---
> 
>  include/linux/crypto.h |    6 ------
>  1 file changed, 6 deletions(-)
> 
> diff --git a/include/linux/crypto.h b/include/linux/crypto.h
> index 80f6350fb588..bb1d9b0e1647 100644
> --- a/include/linux/crypto.h
> +++ b/include/linux/crypto.h
> @@ -176,7 +176,6 @@ struct crypto_async_request;
>  struct crypto_tfm;
>  struct crypto_type;
>  
> -typedef void crypto_completion_data_t;
>  typedef void (*crypto_completion_t)(void *req, int err);
>  
>  /**
> @@ -596,11 +595,6 @@ struct crypto_wait {
>  /*
>   * Async ops completion helper functioons
>   */
> -static inline void *crypto_get_completion_data(void *data)
> -{
> -	return data;
> -}
> -
>  void crypto_req_done(void *req, int err);
>  
>  static inline int crypto_wait_req(int err, struct crypto_wait *wait)

BR, Jarkko
