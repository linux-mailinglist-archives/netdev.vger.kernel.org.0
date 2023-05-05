Return-Path: <netdev+bounces-569-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD1256F8380
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 15:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4E723280FC4
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 13:08:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32AB2BA31;
	Fri,  5 May 2023 13:08:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24A11FB3
	for <netdev@vger.kernel.org>; Fri,  5 May 2023 13:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26EE0C433EF;
	Fri,  5 May 2023 13:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683292100;
	bh=9c7Vz5IK8FlKc1ixls6ozwZqUCZkz+LKtCLr4XFgz4o=;
	h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
	b=Ly2mEHo/Fnl4oZ00haoj/eCR4VZ38Tmh3QmTlSbrG0I6euToDPFlDJ84kuWX2lbwh
	 /m33W5MRxiCmvuLkSkMnAIPGHaRRloKjZaQiVCNzvTPYRToEN9cMqDFLXIM2bK28xN
	 LkgPoknV/fMtwzcCnjxghUX/K+EHPwop6mAqWJxGwWH0yCQbGzpUoaeQlZaH+mvFyO
	 YwOzFpX+H7EOP20LZ0pPQBVIswo/jAdhql7UIigIVJFJw9X99fVajwjtufxrGKOXJB
	 DYcmtkTzw7CyVU7Ce+ZN947VuWQimZSfyJYAHai/Idx9QXFY5qBVq/nBnWMcLbOwaQ
	 6OJdjp3nA3V6Q==
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH net-next] wifi: ath11k: Use list_count_nodes()
From: Kalle Valo <kvalo@kernel.org>
In-Reply-To: 
 <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
References: 
 <941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr>
To: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
 kernel-janitors@vger.kernel.org,
 Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
 ath11k@lists.infradead.org, linux-wireless@vger.kernel.org,
 netdev@vger.kernel.org
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168329209643.10223.10625697791625657598.kvalo@kernel.org>
Date: Fri,  5 May 2023 13:08:17 +0000 (UTC)

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> ath11k_wmi_fw_stats_num_vdevs() and ath11k_wmi_fw_stats_num_bcn() really
> look the same as list_count_nodes(), so use the latter instead of hand
> writing it.
> 
> The first ones use list_for_each_entry() and the other list_for_each(), but
> they both count the number of nodes in the list.
> 
> While at it, also remove to prototypes of non-existent functions.
> Based on the names and prototypes, it is likely that they should be
> equivalent to list_count_nodes().
> 
> Compile tested only.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

91dce4091433 wifi: ath11k: Use list_count_nodes()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/941484caae24b89d20524b1a5661dd1fd7025492.1682542084.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches


