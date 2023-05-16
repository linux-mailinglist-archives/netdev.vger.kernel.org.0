Return-Path: <netdev+bounces-3110-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D42E8705856
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 22:07:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 872981C20C14
	for <lists+netdev@lfdr.de>; Tue, 16 May 2023 20:07:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0CF720984;
	Tue, 16 May 2023 20:07:37 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73573847E
	for <netdev@vger.kernel.org>; Tue, 16 May 2023 20:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EFE2C433EF;
	Tue, 16 May 2023 20:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684267656;
	bh=16Ajf8dbF2bMqR9xAnJNfQQppCltvwAmztd//a2+4qY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OuGC/wP2fFQR8Kjr7bR6WJeDDiR1Ltx9QZf3orUiCsvvOy+oZV9Y2fQfDJ0AW1q9C
	 e6Gy0lMeYhvt6ll3MpT9yub1aT5v8DZ0ql7UgL3sC2qATwz2TEA+mYuCEfVLXR+c9q
	 k6DLliNH9L+WvyaWPs1UX2Axg+nk5qrC5ext7rBOdhCZ5yam098w1p8h9crQpOHFVi
	 GPLjAutwIF7nu5XBAnfvKXgCi84DhlhztC+Jc9fnUzkMGMJNflHwT1Ps/3xgocez0N
	 SeS2CyqBmtZsibZza+nYG5Z4IzkLmCU4bAWR9T7jDc40VZN7s3Kl3sySGiHBTlFEV/
	 zWFL6IOSclmiw==
Date: Tue, 16 May 2023 13:07:35 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Bernd Buschinski <b.buschinski@googlemail.com>
Cc: netdev@vger.kernel.org
Subject: Re: https://bugzilla.kernel.org/show_bug.cgi?id=217399
Message-ID: <20230516130735.145ca5ac@kernel.org>
In-Reply-To: <CACN-hLXbKQ8HYH5G05-t12tx++EmiY2J6VZvj_MzbLAVwayjRA@mail.gmail.com>
References: <CACN-hLXbKQ8HYH5G05-t12tx++EmiY2J6VZvj_MzbLAVwayjRA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 16 May 2023 21:53:25 +0200 Bernd Buschinski wrote:
> I am sorry that I contact you directly, but I could not figure out how
> to reply to the Kernel Mailing list thread.
> https://lore.kernel.org/regressions/ec4be122-e213-ca5b-f5d6-e8f9c3fd3bee@leemhuis.info/
> 
> I tried your suggested patch and reported my results to the Bugzilla
> https://bugzilla.kernel.org/show_bug.cgi?id=217399
> 
> It works fine! Thanks for your work!
> 
> But is there anything else that I can help you with? Anything else to test?

The fix should be part of -rc3.  Here it is queued:

https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git/commit/?id=e1505c1cc8d527fcc5bcaf9c1ad82eed817e3e10

