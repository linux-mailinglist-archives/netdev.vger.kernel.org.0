Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19DF14E1941
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 01:47:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244481AbiCTAsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 20:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237020AbiCTAsv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 20:48:51 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E25241A0A;
        Sat, 19 Mar 2022 17:47:29 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id bi12so23654201ejb.3;
        Sat, 19 Mar 2022 17:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0ifyIt4w3ru4kSUncv7WDTsjeoxWtuh4NygTEp+o10k=;
        b=JS2ve3DrBfAHO2P2Bv3CJUr8wZE1QGvOPf3jTnTHJlshxFiFtst86yTCxrkHvAo0Bq
         KlxwJAcYZ2SXlDA9dlY7yZrlhh2WBVmlsIECnw8BB1e+YwBzrOd6dsbDdd4Z2GxC1y5o
         /xgjlBb69i+8WBpXUyoSkGwTkIFOc5RR/8hobCPg7/XOwEq5zjwhMy5b+Z3Nr+NZjmvu
         kQXtsSROEsmu8Kb4bi6inmo7/AkIqY2kFvrrsjitEQuM5DtE14S0SnZly7dyjh+V3q5t
         p+jQ4KtUnTTzYioIR7Y3+jYpwde1h9Qibs/fM8dwLBMZajmwzBYrpxgeoFsyPQvY6HtI
         LpeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=0ifyIt4w3ru4kSUncv7WDTsjeoxWtuh4NygTEp+o10k=;
        b=sPx+82hO9ZX9qJkkzjSdk1Yz7rnMKB9NzwsmcHL4J6qSIQ9QdEgOtwaU1tambu3+D5
         eUI/KEVmYzmWy5+QlH8Yl4TfnuBKOBYNTTokfsYQliqZ4FGNVrEGLq33Dzf0iK36rgaQ
         0vQhUNDZKgFWznn1JdOvZCPrQ7bAVUy2rs5K1ipNKx7eBqskZYpm9ZExx8bPREHHpCtT
         KTatBEpEVnn2CROdbN0VUJTGL/gph4VrlM5WmxYUEd5jmf9PXdCVlXcI3vHI51f/ixvf
         GPAA/BVwyifeOnRRdqcuDuBo0UoQ/4SLFAMgdoQk5iV3lksmZeGmrtmEHrTL+kvdlkOg
         k72Q==
X-Gm-Message-State: AOAM530S6QPtkib7k+mB8T+efIo/h9sxjIKv5zrvC5dyLjpdl66ZnkA4
        gaT8D2GfqbabRmA+hBij1CM=
X-Google-Smtp-Source: ABdhPJwRZWqRBGortOGDtAQnykWS4EycPTH+HTz7A18lAY7FNnk+WBZhAEFGa6roBtwOKTHFFOB2qg==
X-Received: by 2002:a17:907:a42c:b0:6df:e64b:ed6e with SMTP id sg44-20020a170907a42c00b006dfe64bed6emr3082864ejc.284.1647737247965;
        Sat, 19 Mar 2022 17:47:27 -0700 (PDT)
Received: from smtpclient.apple (i130160.upc-i.chello.nl. [62.195.130.160])
        by smtp.gmail.com with ESMTPSA id fx3-20020a170906b74300b006daecedee44sm5301881ejb.220.2022.03.19.17.47.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 19 Mar 2022 17:47:27 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 15.0 \(3693.60.0.1.1\))
Subject: Re: [PATCH] cw1200: remove an unneeded NULL check on list iterator
From:   Jakob Koschel <jakobkoschel@gmail.com>
In-Reply-To: <20220319063800.28791-1-xiam0nd.tong@gmail.com>
Date:   Sun, 20 Mar 2022 01:47:26 +0100
Cc:     pizza@shaftnet.org, kvalo@kernel.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EFA8A102-59B2-4FC6-AB2E-CA8311E11635@gmail.com>
References: <20220319063800.28791-1-xiam0nd.tong@gmail.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
X-Mailer: Apple Mail (2.3693.60.0.1.1)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On 19. Mar 2022, at 07:38, Xiaomeng Tong <xiam0nd.tong@gmail.com> =
wrote:
>=20
> The list iterator 'item' is always non-NULL so it doesn't need to be
> checked. Thus just remove the unnecessary NULL check. Also remove the
> unnecessary initializer because the list iterator is always =
initialized.
>=20
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
> drivers/net/wireless/st/cw1200/queue.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/net/wireless/st/cw1200/queue.c =
b/drivers/net/wireless/st/cw1200/queue.c
> index 12952b1c29df..05392598e273 100644
> --- a/drivers/net/wireless/st/cw1200/queue.c
> +++ b/drivers/net/wireless/st/cw1200/queue.c
> @@ -90,7 +90,7 @@ static void __cw1200_queue_gc(struct cw1200_queue =
*queue,
> 			      bool unlock)
> {
> 	struct cw1200_queue_stats *stats =3D queue->stats;
> -	struct cw1200_queue_item *item =3D NULL, *tmp;
> +	struct cw1200_queue_item *item, *tmp;
> 	bool wakeup_stats =3D false;
>=20
> 	list_for_each_entry_safe(item, tmp, &queue->queue, head) {
> @@ -117,7 +117,7 @@ static void __cw1200_queue_gc(struct cw1200_queue =
*queue,
> 			queue->overfull =3D false;
> 			if (unlock)
> 				__cw1200_queue_unlock(queue);
> -		} else if (item) {
> +		} else {

I don't think this is fixing anything here. You are basically just =
removing
a check that was always true.

I'm pretty sure that this check is here to check if either the list is =
empty or no
element was found. If I'm not wrong, some time ago, lists where not =
circular but
actually pointed to NULL (or the head was NULL) so this check made sense =
but doesn't
anymore.

The appropriate fix would be only setting 'item' when a break is hit and =
keep
the original check.

> 			unsigned long tmo =3D item->queue_timestamp + =
queue->ttl;
> 			mod_timer(&queue->gc, tmo);
> 			cw1200_pm_stay_awake(&stats->priv->pm_state,
> --=20
> 2.17.1
>=20
>=20

I've made those changes already and I'm in the process of upstreaming =
them in an organized
way, so maybe it would make sense to synchronize, so we don't post =
duplicate patches.

        Jakob=
