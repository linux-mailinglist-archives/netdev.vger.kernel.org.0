Return-Path: <netdev+bounces-9019-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6AE05726966
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 21:04:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8EF431C20E8A
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 19:04:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6979E1ACD3;
	Wed,  7 Jun 2023 19:04:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC5716410
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 19:04:06 +0000 (UTC)
Received: from mail-il1-f180.google.com (mail-il1-f180.google.com [209.85.166.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 487511BF5;
	Wed,  7 Jun 2023 12:04:05 -0700 (PDT)
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-33b1da9a8acso8010545ab.3;
        Wed, 07 Jun 2023 12:04:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686164644; x=1688756644;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2DWn/Ze0Ut4orMd0/mcdLsynCVi5Qtok/YstQsgHfNM=;
        b=PhIm70mR6s1/WapHKUFBpr+n3dUbEdCFRUzmXKtfEk/LTDRfdEJRuE6QWbO8b2Zzv6
         STqu9FWvf7B2RplF8TY055c3oXvP6HF3QZWLItzkMGcP/cdaoUdh+k2g41cnV3VfN/+c
         FrTE9TMEpfdp6UGPE0tj9R2ztCZcBMWyfEjpAV71Yws1RxslZlhHbF/C3fi9juR7PuIN
         DcKoIO1mLM9nnVSCRkeoQX31iHdO0+3R7FHxKqrpk0fTMghBc8d6/JJPVQbt39S2jJwJ
         +dBNb3Bft+DroglnznjwyJF1ZASnfTcBVgpayx8HPiHNsDyDVX0yV1OqUdSRzRH4z4KP
         3Luw==
X-Gm-Message-State: AC+VfDyZXlzizZmquXZpI4jLyBHeflpIrkotNXiH3ou8/zT5Z9q7Po/f
	dCJ2NYi5+Ntt+S/Xn/Tq4Q==
X-Google-Smtp-Source: ACHHUZ4LmyzEXnj/xRHWPuspG/WLerGfcXl235yaTAXTT0UAZR5KZoKSo+SSHLfTDzHl0HlaGOa1Gg==
X-Received: by 2002:a92:cf4e:0:b0:331:105c:81f9 with SMTP id c14-20020a92cf4e000000b00331105c81f9mr9944539ilr.29.1686164644451;
        Wed, 07 Jun 2023 12:04:04 -0700 (PDT)
Received: from robh_at_kernel.org ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id l9-20020a056e0205c900b0033568b32890sm3908892ils.24.2023.06.07.12.04.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jun 2023 12:04:03 -0700 (PDT)
Received: (nullmailer pid 3777477 invoked by uid 1000);
	Wed, 07 Jun 2023 19:04:01 -0000
Date: Wed, 7 Jun 2023 13:04:01 -0600
From: Rob Herring <robh@kernel.org>
To: Diederik de Haas <didi.debian@cknow.org>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, Eric Dumazet <edumazet@google.com>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>, "David S . Miller" <davem@davemloft.net>, Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>, Conor Dooley <conor+dt@kernel.org>, netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH v2] dt-bindings: net: realtek-bluetooth: Fix double
 RTL8723CS in desc
Message-ID: <168616464041.3777410.7010613597646626440.robh@kernel.org>
References: <20230509141500.275887-1-didi.debian@cknow.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230509141500.275887-1-didi.debian@cknow.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
	FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
	SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


On Tue, 09 May 2023 16:15:01 +0200, Diederik de Haas wrote:
> The description says 'RTL8723CS/RTL8723CS/...' whereas the title and
> other places reference 'RTL8723BS/RTL8723CS/...'.
> 
> Signed-off-by: Diederik de Haas <didi.debian@cknow.org>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> Changes since v1:
> - Rebased on top of 6.4-rc1
> - Added Acked-by from Krzysztof Kozlowski
> v1: https://lore.kernel.org/netdev/20230312155435.12334-1-didi.debian@cknow.org/
> 
>  Documentation/devicetree/bindings/net/realtek-bluetooth.yaml | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!


