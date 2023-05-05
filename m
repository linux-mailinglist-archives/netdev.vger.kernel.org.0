Return-Path: <netdev+bounces-625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 622D46F89D5
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 21:51:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8FD631C219B1
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 19:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7BD6C8FE;
	Fri,  5 May 2023 19:51:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66444C99
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 19:51:03 +0000 (UTC)
Received: from mail-oa1-f53.google.com (mail-oa1-f53.google.com [209.85.160.53])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45470138;
	Fri,  5 May 2023 12:51:02 -0700 (PDT)
Received: by mail-oa1-f53.google.com with SMTP id 586e51a60fabf-192814aa343so1848090fac.1;
        Fri, 05 May 2023 12:51:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683316261; x=1685908261;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dguMNfMk4wcW3nSZUAYy0tuJ0r9bBR9l9tF40g9fY7I=;
        b=H32MLflslUzjFmRaKQ9PT9wGDVM76NV1o0IyFvk9wwBBfG4zp8jEB00Cmt30fTti0F
         okkAiYVWB662fS/qFCXwo5kMMxyBu3jsw+9ZiuCO1Jwi14dxRenshYHKg+KazFKClrk/
         wWkCKrF/dxRszwDyAhhpuMzzubsr9TrSh70Or/t4cFI6Pr3h0eeQDjNDhkFLj7dfIw5y
         jmqphdXoVpE2UXKdIvVuwF3pj6JOLL8i3p2Wd3cGDOpaw8Rw66Ddc/mHQQCulaJZ+nAb
         qeZvBF7gyRk6L1+hF6AI3hU/xyeMoiXG11Wm02l2GHImIjFxbM38VgUtVEbSCJGaabVy
         Sjkw==
X-Gm-Message-State: AC+VfDyOYOFp1yDiEAq2Xdfov+sQi24vnH3H3LxI9J0EjzX6qeD/OEoQ
	NnTFC9Gtdw6hQ9kxzqNUlA==
X-Google-Smtp-Source: ACHHUZ7b1sGcz+WaT+MXyYJMCCmoh/Da9MtxtY9aquw0oa5YHEQhZYwLP6Ds8cyve+AMTX6K19GXTw==
X-Received: by 2002:a05:6870:304:b0:187:85c1:8075 with SMTP id m4-20020a056870030400b0018785c18075mr1432649oaf.15.1683316261202;
        Fri, 05 May 2023 12:51:01 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e1-20020a056870c34100b0018449ae08cesm2222138oak.13.2023.05.05.12.50.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 May 2023 12:51:00 -0700 (PDT)
Received: (nullmailer pid 3459191 invoked by uid 1000);
	Fri, 05 May 2023 19:50:58 -0000
Date: Fri, 5 May 2023 14:50:58 -0500
From: Rob Herring <robh@kernel.org>
To: Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc: Wolfgang Grandegger <wg@grandegger.com>, Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org, devicetree@vger.kernel.org, Amarula patchwork <linux-amarula@amarulasolutions.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, Jakub Kicinski <kuba@kernel.org>, linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org, michael@amarulasolutions.com, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet <edumazet@google.com>, Marc Kleine-Budde <mkl@pengutronix.de>, Maxime Coquelin <mcoquelin.stm32@gmail.com>, "David S. Miller" <davem@davemloft.net>, linux-stm32@st-md-mailman.stormreply.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/5] dt-bindings: net: can: add "st,can-secondary"
 property
Message-ID: <168331625833.3459132.18047945812995754036.robh@kernel.org>
References: <20230427204540.3126234-1-dario.binacchi@amarulasolutions.com>
 <20230427204540.3126234-2-dario.binacchi@amarulasolutions.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230427204540.3126234-2-dario.binacchi@amarulasolutions.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
	RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
	autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Thu, 27 Apr 2023 22:45:36 +0200, Dario Binacchi wrote:
> On the stm32f7 Socs the can peripheral can be in single or dual
> configuration. In the dual configuration, in turn, it can be in primary
> or secondary mode. The addition of the 'st,can-secondary' property allows
> you to specify this mode in the dual configuration.
> 
> CAN peripheral nodes in single configuration contain neither
> "st,can-primary" nor "st,can-secondary".
> 
> Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>
> ---
> 
> (no changes since v1)
> 
>  .../bindings/net/can/st,stm32-bxcan.yaml      | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 

Reviewed-by: Rob Herring <robh@kernel.org>


