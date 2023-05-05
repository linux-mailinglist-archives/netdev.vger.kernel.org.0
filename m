Return-Path: <netdev+bounces-519-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B5676F7E06
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 09:38:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8E482280E7A
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 07:38:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5719C4C8D;
	Fri,  5 May 2023 07:38:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D97ED20E7
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 07:38:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B21C433EF;
	Fri,  5 May 2023 07:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683272306;
	bh=Pw3z/wSPton4j3lNLrHMugPK+GlT51qJrffU70l3EZ0=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=C1/ydpdinmi/GrtJJ0vsKhISDEEVcNA8iEONGU11bwz25hwix5IZMYYJg8lfnUK7N
	 nKcmR6lxOJPPst1pMh5miDsd8PP5Ea5tZ/Wq9zNBBdekpqsd5WiszUQhqfJFnEs2OY
	 duzKLsiKZ5pYZAxvSIety3CAQ+JSmw9TaapH3p49Q4AJuYkhXkTfkWMWBhkbp+8PmZ
	 YqAsAbYAkghk1T7B2foI2Tsu7zu7hzEYWT5xYjtKwacAGFvIW8YZxT7Yrx/SVQbwGK
	 jZkq30G0Qp38istRCVFLToSfa0xnfAsgxBQWOYzRByPtX+CaAzdOJXLCFwP42d/jkb
	 MVh0twUDY0A9A==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 1/2] wifi: rtw88: fix incorrect error codes in
 rtw_debugfs_copy_from_user
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: <tencent_D2EB102CC7435C0110154E62ECA6A7D67505@qq.com>
References: <tencent_D2EB102CC7435C0110154E62ECA6A7D67505@qq.com>
To: Zhang Shurong <zhang_shurong@foxmail.com>
Cc: pkshih@realtek.com, tony0620emma@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, Zhang Shurong <zhang_shurong@foxmail.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168327230065.10202.16584084872255391845.kvalo@kernel.org>
Date: Fri,  5 May 2023 07:38:24 +0000 (UTC)

Zhang Shurong <zhang_shurong@foxmail.com> wrote:

> If there is a failure during copy_from_user or user-provided data
> buffer is invalid, rtw_debugfs_copy_from_user should return negative
> error code instead of a positive value count.
> 
> Fix this bug by returning correct error code. Moreover, the check
> of buffer against null is removed since it will be handled by
> copy_from_user.
> 
> Signed-off-by: Zhang Shurong <zhang_shurong@foxmail.com>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

2 patches applied to wireless-next.git, thanks.

225622256b1b wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
770055337772 wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/tencent_D2EB102CC7435C0110154E62ECA6A7D67505@qq.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


