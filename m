Return-Path: <netdev+bounces-9161-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 25F77727A68
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 10:49:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5F4A2815B8
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 08:49:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09DA58F4E;
	Thu,  8 Jun 2023 08:49:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFEA46FC4
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 08:49:19 +0000 (UTC)
Received: from gloria.sntech.de (gloria.sntech.de [185.11.138.130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 801F330CB;
	Thu,  8 Jun 2023 01:48:57 -0700 (PDT)
Received: from ip5b412278.dynamic.kabel-deutschland.de ([91.65.34.120] helo=phil.lan)
	by gloria.sntech.de with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <heiko@sntech.de>)
	id 1q7BJm-0004qi-Tn; Thu, 08 Jun 2023 10:48:31 +0200
From: Heiko Stuebner <heiko@sntech.de>
To: devicetree@vger.kernel.org,
	Chris Morgan <macroalpha82@gmail.com>
Cc: Heiko Stuebner <heiko@sntech.de>,
	davem@davemloft.net,
	netdev@vger.kernel.org,
	Chris Morgan <macromorgan@hotmail.com>,
	anarsoul@gmail.com,
	kuba@kernel.org,
	conor+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org,
	pabeni@redhat.com,
	edumazet@google.com,
	robh+dt@kernel.org,
	alistair@alistair23.me,
	linux-rockchip@lists.infradead.org
Subject: Re: (subset) [PATCH 0/2] Correct fallback compatible for rtl8821cs bluetooth
Date: Thu,  8 Jun 2023 10:48:29 +0200
Message-Id: <168621409737.1496691.2824759891410885435.b4-ty@sntech.de>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230508160811.3568213-1-macroalpha82@gmail.com>
References: <20230508160811.3568213-1-macroalpha82@gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,T_SPF_HELO_TEMPERROR autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, 8 May 2023 11:08:09 -0500, Chris Morgan wrote:
> From: Chris Morgan <macromorgan@hotmail.com>
> 
> The realtek 8821cs bluetooth module is functionally very similar to the
> 8822cs and 8723bs modules, however unlike the 8822 module it seems to
> struggle when power management features are enabled. By switching the
> fallback string from realtek,rtl8822cs-bt to realtek,rtl8723bs-bt we
> can instruct the driver to not enable advanced power management
> features that cause the issues.
> 
> [...]

Applied, thanks!

[2/2] arm64: dts: rockchip: Fix compatible for Bluetooth
      commit: a325956fa7048906e26a4535ac2e87e111788fe8

Best regards,
-- 
Heiko Stuebner <heiko@sntech.de>

