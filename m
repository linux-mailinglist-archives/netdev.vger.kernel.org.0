Return-Path: <netdev+bounces-2349-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EDB957015FD
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 12:06:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BE0D21C2113D
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 10:06:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7CB191865;
	Sat, 13 May 2023 10:06:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1711846
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 10:06:25 +0000 (UTC)
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8262B10DD;
	Sat, 13 May 2023 03:06:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1683972383; x=1715508383;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zjh28MwfF3C0uOdrttJk49uOuEsVBFk8cWdFA8EfpKw=;
  b=qSTnHix/cZwVvnuUNRQMO3Xr24POtDixsJH1u2us7tjelcmQHLl3q+hC
   RBP4mN69mR7onb+GO0DA76T6fm2q5eg8M9cp3skelSDN/SbLFju+BlJjF
   AxQoyZQQyKq/cUr+l20arua5EIjeVWHV3STmT/MemCZ+WPBw/YJ9ls1sE
   MZ83MGcIu61ddH00p6bO0ut5P+xBBKL0yQD0Uwtq31KxzQIZoVVzEF4kY
   dSbjW0TfcOaFwbNjRkAaodrMLJYqLxM0KadKuZN5dbAGiSK3Ikl90/Cn3
   +3DoT32DgIzRrf8GnPYFmqUknM+Pc8PEsGPPnLgqp9Hng8R/f3kndHEzw
   A==;
X-IronPort-AV: E=Sophos;i="5.99,272,1677567600"; 
   d="scan'208";a="211081481"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 May 2023 03:06:22 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Sat, 13 May 2023 03:06:21 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Sat, 13 May 2023 03:06:20 -0700
Date: Sat, 13 May 2023 12:06:20 +0200
From: Horatiu Vultur <horatiu.vultur@microchip.com>
To: Anup Sharma <anupnewsmail@gmail.com>
CC: Lars Povlsen <lars.povlsen@microchip.com>, Steen Hegelund
	<Steen.Hegelund@microchip.com>, Daniel Machon <daniel.machon@microchip.com>,
	<UNGLinuxDriver@microchip.com>, "David S. Miller" <davem@davemloft.net>,
	"Eric Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, <linux-arm-kernel@lists.infradead.org>,
	<netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: ethernet: microchip: vcap: Remove extra semicolon
Message-ID: <20230513100620.us2rpjmkmxkcreup@soft-dev3-1>
References: <ZF5761tc1B32elgb@yoga>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <ZF5761tc1B32elgb@yoga>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

The 05/12/2023 23:18, Anup Sharma wrote:
> [Some people who received this message don't often get email from anupnewsmail@gmail.com. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> 
> Remove the extra semicolon at end. Issue identified using
> semicolon.cocci Coccinelle semantic patch.
> 
> drivers/net/ethernet/microchip/vcap/vcap_api.c:1124:3-4: Unneeded semicolon
> drivers/net/ethernet/microchip/vcap/vcap_api.c:1165:3-4: Unneeded semicolon
> drivers/net/ethernet/microchip/vcap/vcap_api.c:1239:3-4: Unneeded semicolon
> drivers/net/ethernet/microchip/vcap/vcap_api.c:1287:3-4: Unneeded semicolon

You have forgotten to add the target tree inside the subject. In this
case, it needs to be net-next. You can do that using:
git format-patch ... --subject-prefix "PATCH net-next" ...

Reviewed-by: Horatiu Vultur <horatiu.vultur@microchip.com>

> 
> Signed-off-by: Anup Sharma <anupnewsmail@gmail.com>
> ---
>  drivers/net/ethernet/microchip/vcap/vcap_api.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/net/ethernet/microchip/vcap/vcap_api.c b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> index 5675b0962bc3..a418ad8e8770 100644
> --- a/drivers/net/ethernet/microchip/vcap/vcap_api.c
> +++ b/drivers/net/ethernet/microchip/vcap/vcap_api.c
> @@ -1121,7 +1121,7 @@ static void vcap_copy_to_client_actionfield(struct vcap_rule_internal *ri,
>                         vcap_copy_from_w32be(field->data.u128.value, value,
>                                              field_size, width);
>                         break;
> -               };
> +               }
>         } else {
>                 switch (field->ctrl.type) {
>                 case VCAP_FIELD_BIT:
> @@ -1162,7 +1162,7 @@ static void vcap_copy_to_client_actionfield(struct vcap_rule_internal *ri,
>                                                       value,
>                                                       width, field_size);
>                         break;
> -               };
> +               }
>         }
>  }
> 
> @@ -1236,7 +1236,7 @@ static void vcap_copy_to_client_keyfield(struct vcap_rule_internal *ri,
>                         vcap_copy_from_w32be(field->data.u128.mask,  mask,
>                                              field_size, width);
>                         break;
> -               };
> +               }
>         } else {
>                 switch (field->ctrl.type) {
>                 case VCAP_FIELD_BIT:
> @@ -1284,7 +1284,7 @@ static void vcap_copy_to_client_keyfield(struct vcap_rule_internal *ri,
>                                                    value, mask,
>                                                    width, field_size);
>                         break;
> -               };
> +               }
>         }
>  }
> 
> --
> 2.34.1
> 

-- 
/Horatiu

