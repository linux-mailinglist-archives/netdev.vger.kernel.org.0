Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8AC47CCBF
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 06:58:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242628AbhLVF6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 00:58:35 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50776 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242626AbhLVF6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 00:58:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D3815B81A7A;
        Wed, 22 Dec 2021 05:58:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CA3C36AE5;
        Wed, 22 Dec 2021 05:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640152711;
        bh=wnlIft/x8MQVyWtEN2wWau7s4XRbDvMYu1vn3YB2FRM=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=o/SrgoS4/pTFvVm+Se4UuTH/1lbIIzvij/bYJZLa4Qy2dYpRGVcRVfjnf+5rYA5jC
         +lVzDXJ1NfgIYSxeeewAklW9oyI0NPkVBz7NVeH/aADuecgA7fzpTyEy2Xuc+snV+p
         CNQemUnHxWmq3V4Uc5Avj6SHKWET4BEFWtdhTUZ/+B7iS9XBqmZajH7iqi9A9FglKa
         bn1+9SnVzX5dS4NXZHCht5E/5pFHzvETXOImFyMwuHnYkadic7ApbLmpqAHSqQt2my
         Vyt/CMwitnkp7syivA0laXQefUAK+g6u5UHg3gdcWA4sl7dmUv4Wmq/9eNv38iEL14
         yJqAsP/1w7pDg==
From:   Kalle Valo <kvalo@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        luciano.coelho@intel.com, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com, ryder.lee@mediatek.com,
        shayne.chen@mediatek.com, sean.wang@mediatek.com,
        johannes.berg@intel.com, emmanuel.grumbach@intel.com,
        ath11k@lists.infradead.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH net-next 2/2] codel: remove unnecessary pkt_sched.h include
References: <20211221193941.3805147-1-kuba@kernel.org>
        <20211221193941.3805147-2-kuba@kernel.org>
Date:   Wed, 22 Dec 2021 07:58:26 +0200
In-Reply-To: <20211221193941.3805147-2-kuba@kernel.org> (Jakub Kicinski's
        message of "Tue, 21 Dec 2021 11:39:41 -0800")
Message-ID: <87o8592nb1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> writes:

> Commit d068ca2ae2e6 ("codel: split into multiple files") moved all
> Qdisc-related code to codel_qdisc.h, move the include of pkt_sched.h
> as well.
>
> This is similar to the previous commit, although we don't care as
> much about incremental builds after pkt_sched.h was touched itself
> it is included by net/sch_generic.h which is modified ~20 times
> a year.
>
> This decreases the incremental build size after touching pkt_sched.h
> from 1592 to 617 objects.
>
> Fix unmasked missing includes in WiFi drivers.
>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> CC: kvalo@kernel.org
> CC: luciano.coelho@intel.com
> CC: nbd@nbd.name
> CC: lorenzo.bianconi83@gmail.com
> CC: ryder.lee@mediatek.com
> CC: shayne.chen@mediatek.com
> CC: sean.wang@mediatek.com
> CC: johannes.berg@intel.com
> CC: emmanuel.grumbach@intel.com
> CC: ath11k@lists.infradead.org
> CC: linux-wireless@vger.kernel.org
> ---
>  drivers/net/wireless/ath/ath11k/reg.c               | 2 ++
>  drivers/net/wireless/intel/iwlwifi/mvm/ops.c        | 1 +
>  drivers/net/wireless/intel/iwlwifi/mvm/vendor-cmd.c | 1 +
>  drivers/net/wireless/mediatek/mt76/testmode.h       | 2 ++

Acked-by: Kalle Valo <kvalo@kernel.org>

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
