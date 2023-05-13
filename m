Return-Path: <netdev+bounces-2367-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE23570183B
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 18:46:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E60AF281A31
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 16:46:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0EF016ADB;
	Sat, 13 May 2023 16:46:06 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F36C64C6B
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 16:46:05 +0000 (UTC)
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0242D6D;
	Sat, 13 May 2023 09:46:03 -0700 (PDT)
Received: from p508fce4f.dip0.t-ipconnect.de ([80.143.206.79] helo=phil.localnet)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1pxsNb-0000Un-KP; Sat, 13 May 2023 18:45:59 +0200
From: Heiko Stuebner <heiko@sntech.de>
To: devicetree@vger.kernel.org, Chris Morgan <macroalpha82@gmail.com>
Cc: linux-rockchip@lists.infradead.org, netdev@vger.kernel.org,
 anarsoul@gmail.com, alistair@alistair23.me, conor+dt@kernel.org,
 krzysztof.kozlowski+dt@linaro.org, robh+dt@kernel.org, pabeni@redhat.com,
 kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 Chris Morgan <macromorgan@hotmail.com>
Subject:
 Re: [PATCH 1/2] dt-bindings: net: realtek-bluetooth: Fix RTL8821CS binding
Date: Sat, 13 May 2023 18:45:58 +0200
Message-ID: <4827925.31r3eYUQgx@phil>
In-Reply-To: <20230508160811.3568213-2-macroalpha82@gmail.com>
References:
 <20230508160811.3568213-1-macroalpha82@gmail.com>
 <20230508160811.3568213-2-macroalpha82@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Am Montag, 8. Mai 2023, 18:08:10 CEST schrieb Chris Morgan:
> From: Chris Morgan <macromorgan@hotmail.com>
> 
> Update the fallback string for the RTL8821CS from realtek,rtl8822cs-bt
> to realtek,rtl8723bs-bt. The difference between these two strings is
> that the 8822cs enables power saving features that the 8723bs does not,
> and in testing the 8821cs seems to have issues with these power saving
> modes enabled.
> 
> Fixes: 95ee3a93239e ("dt-bindings: net: realtek-bluetooth: Add RTL8821CS")
> Signed-off-by: Chris Morgan <macromorgan@hotmail.com>

Acked-by: Heiko Stuebner <heiko@sntech.de>




