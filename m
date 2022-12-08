Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22FF2647210
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 15:43:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229915AbiLHOnn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 09:43:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbiLHOnj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 09:43:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FBBE005;
        Thu,  8 Dec 2022 06:43:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9532061F76;
        Thu,  8 Dec 2022 14:43:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BFD0C433B5;
        Thu,  8 Dec 2022 14:43:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670510618;
        bh=sD0s4IIdSrrNRlhHdPxHzyAWp+1KIvfPID1XtU0Xqio=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=bOzwrZUUnRGulB6xeNZh2ueB1liBkMB7lL+f/ntzIQ93EMrJ0PMnaqu9JLsJuZNVr
         yhG6hxjVbchQXHTAc9RVlvLrdv/y+DI5hlfD58u/t0Et4NLalKBnPWR4ht05fe6jJY
         INaSb7NDJWbvs5zQqjpJDlHmI/v2VaHPeN+yxTvq5IVqW9hH/4y+TCBmL6kAZ+N7rM
         Z/R95++k85JZG+XPZNAuJI7wJUtpwGOOikgopw17K6nCd+BGBovuy5VvoptdVNFAQC
         lHfIli48F+XjE7FX1Rbqpn2P0nUfJosff3kC7Gzulz4dq/nSLCSLpvqUhRd6WcuWor
         umxy/AjaNIPeA==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: wifi: ipw2x00: Remove some unused functions
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <20221129062407.83157-1-jiapeng.chong@linux.alibaba.com>
References: <20221129062407.83157-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     stas.yakovlev@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        Abaci Robot <abaci@linux.alibaba.com>
User-Agent: pwcli/0.1.1-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <167051061112.9839.16237027810191457541.kvalo@kernel.org>
Date:   Thu,  8 Dec 2022 14:43:35 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jiapeng Chong <jiapeng.chong@linux.alibaba.com> wrote:

> Functions write_nic_auto_inc_address() and write_nic_dword_auto_inc() are
> defined in the ipw2100.c file, but not called elsewhere, so remove these
> unused functions.
> 
> drivers/net/wireless/intel/ipw2x00/ipw2100.c:427:20: warning: unused function 'write_nic_dword_auto_inc'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3285
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Patch applied to wireless-next.git, thanks.

5107778d0061 wifi: ipw2x00: Remove some unused functions

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/20221129062407.83157-1-jiapeng.chong@linux.alibaba.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

