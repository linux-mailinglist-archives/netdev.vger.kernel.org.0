Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDE9C6D22DB
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 16:46:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232865AbjCaOqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 10:46:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232556AbjCaOqF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 10:46:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 901D15FEC;
        Fri, 31 Mar 2023 07:46:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 184FBB82768;
        Fri, 31 Mar 2023 14:46:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40293C433D2;
        Fri, 31 Mar 2023 14:45:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680273961;
        bh=z1G+0icOQK7/HIu9HyFNmbxaB5G6mdi+J7KItGHVfMo=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=lro5DceS/4SR03HV8dOA3/Aezxs870ykbpEI1vRe/utzdLRFsWd+QtPLGbJcMUIej
         XcOYyQIrQNCQ32Kar/aRSviAhevlDfiiDUM6/uxQSaH3Ka09vY/vS4jariu6apbsNW
         wQQnBMVgzkg/2WUH5D7vzSjorsKLhDqd5p4MDA6cNpeCMpmRL8PCOg5Z4NfV0XesiA
         9YgKuYo4u7QJYxBOClrbNPqf7R0g5F+DFs10qJub0xw4i3vjr9SRiWcukk2FDpj/8p
         IYrvwHtsW5zaGirBnn1RUOJkVvXxOlvDLWqQzJKgPmFHheXl0dVaFxYCZ0xbuajpZK
         jT9WE+9PyQ+Cg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [net-next] wifi: rsi: Slightly simplify rsi_set_channel()
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr>
References: <29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <168027395743.32751.10963485072704404337.kvalo@kernel.org>
Date:   Fri, 31 Mar 2023 14:45:59 +0000 (UTC)
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Christophe JAILLET <christophe.jaillet@wanadoo.fr> wrote:

> There is no point in allocating 'skb' and then freeing it if !channel.
> 
> Make the sanity check first to slightly simplify the code.
> 
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Patch applied to wireless-next.git, thanks.

8de7838acfa3 wifi: rsi: Slightly simplify rsi_set_channel()

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/29bf0296bd939e3f6952272bfdcc73b22edbc374.1679328588.git.christophe.jaillet@wanadoo.fr/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

