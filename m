Return-Path: <netdev+bounces-10545-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F80272EF22
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 00:27:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 51E0F1C209E4
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 22:27:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3491F3EDA4;
	Tue, 13 Jun 2023 22:27:12 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15788136A
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 22:27:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6108EC433C0;
	Tue, 13 Jun 2023 22:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686695230;
	bh=brGnLs+934H/8ne5PgFLPYRlSLef8jdP9/Ha5mJTNWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LP7gRQ8F3048l17hzFYP7yo65uFsKMKyVS+w4c2ZPfDmt55M5Di/DOAB7TMXY3q3Q
	 FMs4mTCCcgIKAUUsTsZ3BrtKE+4bpIMrsOR7o1yRPojKTjgzZpOwRuZX8WvhYQr00B
	 dB/CIaB+VIQTpSaZvYCrtYOEFnzX5zV6+EHtoYSQXzS8us0PisOwPQw2RjWA018Byc
	 0yzYiz/eLtYQLEUy6bWHiEB6r23QWBDbDl2huQHceGL6C5MbNc0T0qM6SuCCxdme/P
	 St4o82SHCxfBbg0Ay1y9vsypAp3U3cr/pAEFx3XouNTucCbQaGCdlUm3prBgcbtxW0
	 KeH65xtEsmc5A==
From: Bjorn Andersson <andersson@kernel.org>
To: Andrew Halaney <ahalaney@redhat.com>,
	linux-kernel@vger.kernel.org
Cc: bmasney@redhat.com,
	echanude@redhat.com,
	agross@kernel.org,
	robh+dt@kernel.org,
	linux-arm-msm@vger.kernel.org,
	richardcochran@gmail.com,
	krzysztof.kozlowski+dt@linaro.org,
	conor+dt@kernel.org,
	konrad.dybcio@linaro.org,
	devicetree@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] arm64: dts: qcom: sa8540p-ride: Specify ethernet phy OUI
Date: Tue, 13 Jun 2023 15:30:09 -0700
Message-Id: <168669542892.1315701.6882227491843598759.b4-ty@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230608201513.882950-1-ahalaney@redhat.com>
References: <20230608201513.882950-1-ahalaney@redhat.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit

On Thu, 8 Jun 2023 15:15:13 -0500, Andrew Halaney wrote:
> With wider usage on more boards, there have been reports of the
> following:
> 
>     [  315.016174] qcom-ethqos 20000.ethernet eth0: no phy at addr -1
>     [  315.016179] qcom-ethqos 20000.ethernet eth0: __stmmac_open: Cannot attach to PHY (error: -19)
> 
> which has been fairly random and isolated to specific boards.
> Early reports were written off as a hardware issue, but it has been
> prevalent enough on boards that theory seems unlikely.
> 
> [...]

Applied, thanks!

[1/1] arm64: dts: qcom: sa8540p-ride: Specify ethernet phy OUI
      commit: f04325e4d4d66e63fc4e474ff54835a28b3ff29e

Best regards,
-- 
Bjorn Andersson <andersson@kernel.org>

