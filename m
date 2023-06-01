Return-Path: <netdev+bounces-7132-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E805271A348
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 17:54:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1A083281751
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 15:54:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E36322D79;
	Thu,  1 Jun 2023 15:54:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAC3BA2F
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 15:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4EEDC433EF;
	Thu,  1 Jun 2023 15:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685634843;
	bh=xeSn3E1qJvyf4etDPi5a+zgCrfqeEF4F7L6zPoddoHY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=g9WVNsUWn6yFnQvSiyKbqL8LE4DBDYs8lSq7I2Ur7WdD1MPG2aDCb9M9vJ6Nz/e2f
	 OHCNlQ1LzoOsAoM6sMHAewiNiQGaTuJErLaAngEBiNjQrclwutSJ/EyJgscMIvpF16
	 F4FHdZJe+b9LYNdvMMBOzI8+lr+IC/vNrwNypoXo+pkMvWYPDiKOZjIQTO2DIRyVlW
	 yLZBGiatu02MU9HAdoNTNnv6i8jwo6SjQEeHWjiwiV9E1DC1jE2aEXH2tBH5RFwmSI
	 6ppcjAn4FjD2STyp0VCwE3QP6nUQq1LLtXHcafnNvJfkzWg89QY+4WqeqEIoxpQV7K
	 2MVgjCzTGxk3A==
Date: Thu, 1 Jun 2023 08:54:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc: davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
 davthompson@nvidia.com, asmaa@nvidia.com, mkl@pengutronix.de,
 limings@nvidia.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mlxbf_gige: Add missing check for platform_get_irq
Message-ID: <20230601085402.01c2a385@kernel.org>
In-Reply-To: <20230601065808.1137-1-jiasheng@iscas.ac.cn>
References: <20230601065808.1137-1-jiasheng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu,  1 Jun 2023 14:58:08 +0800 Jiasheng Jiang wrote:
> According to the documentation of submitting patches
> (Link: https://docs.kernel.org/process/submitting-patches.html),
> I used "scripts/get_maintainer.pl" to gain the appropriate recipients
> for my patch.
> However, the "limings@nvidia.com" is not contained in the following list.

And I told you already to run the script on the _patch_ not on the file
path.

$ ./scripts/get_maintainer.pl 0001-mlxbf_gige-Add-missing-check-for-platform_get_irq.patch
"David S. Miller" <davem@davemloft.net> (maintainer:NETWORKING DRIVERS,blamed_fixes:1/1=100%)
Eric Dumazet <edumazet@google.com> (maintainer:NETWORKING DRIVERS)
Jakub Kicinski <kuba@kernel.org> (maintainer:NETWORKING DRIVERS,commit_signer:5/6=83%,authored:1/6=17%,removed_lines:1/20=5%)
Paolo Abeni <pabeni@redhat.com> (maintainer:NETWORKING DRIVERS)
Asmaa Mnebhi <asmaa@nvidia.com> (commit_signer:4/6=67%,blamed_fixes:1/1=100%)
David Thompson <davthompson@nvidia.com> (commit_signer:4/6=67%,authored:4/6=67%,added_lines:94/99=95%,removed_lines:19/20=95%,blamed_fixes:1/1=100%)
Marc Kleine-Budde <mkl@pengutronix.de> (commit_signer:1/6=17%)
Jiasheng Jiang <jiasheng@iscas.ac.cn> (commit_signer:1/6=17%,authored:1/6=17%)
vvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvvv
Liming Sun <limings@nvidia.com> (blamed_fixes:1/1=100%)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
linux-kernel@vger.kernel.org (open list)

