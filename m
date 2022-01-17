Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19CAE4908D5
	for <lists+netdev@lfdr.de>; Mon, 17 Jan 2022 13:42:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237074AbiAQMmA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jan 2022 07:42:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234166AbiAQMmA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jan 2022 07:42:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAFF0C061574;
        Mon, 17 Jan 2022 04:41:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77858611B5;
        Mon, 17 Jan 2022 12:41:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28955C36AE3;
        Mon, 17 Jan 2022 12:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642423318;
        bh=GpsA3cbs+BIbsadEtt95gl6TWxIcj8Lx14iqogGceHc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=SLgRxz0jYUozJHlYpOvrK5lXePGyEUShn5V3MEMWjvF68cQ1jJikHw5FFddlprM1h
         KxH+T3knOufWzZNA0nF/D5hoSnjf3ma5gqAtd4+8kedEcfGm54gHYikanjBq2DNaGD
         TUnMbcqR1dtT61CU8d4NUpkP0+JtxS/PNmuq/Li/vaPDPLTOBZSQae6A0Kcb00P/Xo
         Xzcs4gnPVtj365qmViZ2qY23RgyowYBSFSnPgL/mUk46y+iqWowLB5/MJTGm0UHhXe
         RQiY0EjPkZymfRbenbk8yMkXdj9uzMnfdNmIrNZhCt5bXmRgR6QafJgJpIk5iWN0Xt
         3neOnVofSjmbQ==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] ath: dfs_pattern_detector: Avoid open coded arithmetic in
 memory allocation
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <0fbcd32a0384ac1f87c5a3549e505e4becc60226.1640624216.git.christophe.jaillet@wanadoo.fr>
References: <0fbcd32a0384ac1f87c5a3549e505e4becc60226.1640624216.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164242331548.27899.9932446295681799332.kvalo@kernel.org>
Date:   Mon, 17 Jan 2022 12:41:56 +0000 (UTC)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> kmalloc_array()/kcalloc() should be used to avoid potential overflow when
> a multiplication is needed to compute the size of the requested memory.
> 
> kmalloc_array() can be used here instead of kcalloc() because the array is
> fully initialized in the next 'for' loop.
> 
> Finally, 'cd->detectors' is defined as 'struct pri_detector **detectors;'.
> So 'cd->detectors' and '*cd->detectors' are both some pointer.
> So use a more logical 'sizeof(*cd->detectors)'.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>

Patch applied to ath-next branch of ath.git, thanks.

a063b650ce5d ath: dfs_pattern_detector: Avoid open coded arithmetic in memory allocation

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/0fbcd32a0384ac1f87c5a3549e505e4becc60226.1640624216.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

