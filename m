Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A47404FE2D7
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 15:38:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352274AbiDLNkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 09:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234919AbiDLNkQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 09:40:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED0CE2DD66;
        Tue, 12 Apr 2022 06:37:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8822161AB2;
        Tue, 12 Apr 2022 13:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3058DC385A5;
        Tue, 12 Apr 2022 13:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649770677;
        bh=WU7Zz13KbGEiSCrTwZGReYOqbMBpyPSKUG1GNJKkz8c=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=iHesB0XV42gPxXUCfNNPArPeE6m+LJCrmh5FGgY1xGXNhCKQj4DGcqxGaoFGMe2a6
         uoKNTQXhtdnyldiMjFL5+aNzjRJXXdX8KlwM8NDQA8UKz1mLdT1+y1bluUB0f8kpXK
         DT+SrFSdDORF7eqwdUGI5EIaOwOZi6Tl0eoyUT8klSxAFKvf0mYY/qCPASHrC4cuFF
         ztLXJLvMtF2RjgJlrBXUkd/XzCcaf5Of2+ps7iEaZtvKxwCQ5i0YjGTXPxdqveDNzF
         jUmVGVp/mm0kwJdgr9D1YjSWDyjOZ00/sbvb+sMcDPekOLeVa4xxYHdKHAuD2q7+tk
         Tuly76KayoFOg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] rtw89: rtw89_ser: add const to struct state_ent and
 event_ent
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com>
References: <2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com>
To:     Joe Perches <joe@perches.com>
Cc:     Ping-Ke Shih <pkshih@realtek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164977067440.31115.9442852945406484108.kvalo@kernel.org>
Date:   Tue, 12 Apr 2022 13:37:56 +0000 (UTC)
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Joe Perches <joe@perches.com> wrote:

> Change the struct and the uses to const to reduce data.
> 
> $ size drivers/net/wireless/realtek/rtw89/ser.o* (x86-64 defconfig w/ rtw89)
>    text	   data	    bss	    dec	    hex	filename
>    3741	      8	      0	   3749	    ea5	drivers/net/wireless/realtek/rtw89/ser.o.new
>    3437	    312	      0	   3749	    ea5	drivers/net/wireless/realtek/rtw89/ser.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

Patch applied to wireless-next.git, thanks.

af5175acc8e2 rtw89: rtw89_ser: add const to struct state_ent and event_ent

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/2fd88e6119f62b968477ef9781abb1832d399fd6.camel@perches.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

