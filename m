Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D1E86A4AD2
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 20:26:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230049AbjB0T0D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 14:26:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229815AbjB0T0C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 14:26:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5C47252A0
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 11:25:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 417F560F08
        for <netdev@vger.kernel.org>; Mon, 27 Feb 2023 19:25:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 472CAC433EF;
        Mon, 27 Feb 2023 19:25:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677525954;
        bh=HEvJNXzlxvofkA+7yqM0U2PT5NVNPTD+hKvhCeOJcIY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AQd7YKP6GGSCSJyf1imGN5AXAAQDLxlOyuCwcHlDOE8JWHm+V3IGvvV1i8MIPeHdY
         /O7qCDLFaKGJtLF6yCViqB6lGmTAeDWlt1VmlN9ZYXq+b3xxo79eHTgq541W0aSVfX
         mRdG6Ifmw/QJRnEN3vO2OFT+bo+o8dO/DRQ6AF+5mE/C6KJX5agSOjmfZLCd/cDWRZ
         EhLE3e533A9NBDGkgAg2f2zlw097GeXsFt0aRETJzxj3GJIg+VwY7zJEuk6RYUDCLx
         2B84BJFqfCeNXpOz2+Hn5myRqdn2caawLSt779sD0ml0L19AUGnAcKglW2Bf0YNN1k
         lvnEowHQfG2Hw==
Date:   Mon, 27 Feb 2023 11:25:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pedro Tammela <pctammela@mojatatu.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, liuhangbin@gmail.com
Subject: Re: [PATCH] net/sched: act_api: move TCA_EXT_WARN_MSG to the
 correct hierarchy
Message-ID: <20230227112553.39df99fd@kernel.org>
In-Reply-To: <20230224175601.180102-1-pctammela@mojatatu.com>
References: <20230224175601.180102-1-pctammela@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Feb 2023 14:56:01 -0300 Pedro Tammela wrote:
> TCA_EXT_WARN_MSG is currently sitting outside of the expected hierarchy
> for the tc actions code. It should sit within TCA_ACT_TAB.
> 
> Fixes: 0349b8779cc9 ("sched: add new attr TCA_EXT_WARN_MSG to report tc extact message")
> Reviewed-by: Jamal Hadi Salim <jhs@mojatatu.com>
> Signed-off-by: Pedro Tammela <pctammela@mojatatu.com>

Applied, thanks!
