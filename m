Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01694609F86
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 12:58:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiJXK6e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 06:58:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiJXK5h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 06:57:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2965961B29;
        Mon, 24 Oct 2022 03:57:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D9E3A60FEA;
        Mon, 24 Oct 2022 10:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F88C433C1;
        Mon, 24 Oct 2022 10:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666608988;
        bh=PWi0iSkmko6w5zd/maFDS9dVCt3fXX8xqAbZ9C5FNDA=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=RU8HUMzJSmltpliKxMI2QA5O9//iCzSwxjEyA+wJR18Xd78VEhpuDioTqszmIu01T
         9l/mZDvxCrjt4RMtCzzqxEyYQhUVfN1Iq+V+EahvjtUSBZslZIZlxDZhZkXbl70GtU
         sRLmwULb2KDsvXRGoE1sD4I/yfkxBxixJD0oE7j3H/mp2r2XhuiQBE5v14EpKqzCQg
         9mOpAHykDKZ6piBsPuiXpBkm7bHg2lTwfMxyLWPA8ZQqXnTU3t76JGaAnaGIX019Zl
         Y2cvUjzTkfa+P3hwn2K/zn+TPyFhLYpOyvEZeZ2dYzYndbpTplxgQ8OBpTF9gL+Ta8
         XL+P8iLZl2SDQ==
From:   Kalle Valo <kvalo@kernel.org>
To:     wangjianli <wangjianli@cdjrlc.com>
Cc:     gregory.greenman@intel.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] intel/iwlwifi: fix repeated words in comments
In-Reply-To: <20221022053934.28668-1-wangjianli@cdjrlc.com> (wangjianli's
        message of "Sat, 22 Oct 2022 13:39:34 +0800")
References: <20221022053934.28668-1-wangjianli@cdjrlc.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
Date:   Mon, 24 Oct 2022 13:56:23 +0300
Message-ID: <877d0pij6w.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wangjianli <wangjianli@cdjrlc.com> writes:

> Delete the redundant word 'the'.
>
> Signed-off-by: wangjianli <wangjianli@cdjrlc.com>
> ---
>  drivers/net/wireless/intel/iwlwifi/iwl-trans.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

The title should be:

wifi: iwlwifi: fix repeated words in comments in iwl-trans.h

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
