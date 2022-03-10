Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49D2D4D4E39
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 17:12:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240875AbiCJQM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 11:12:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238150AbiCJQM1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 11:12:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 743F418FAC0;
        Thu, 10 Mar 2022 08:11:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FFDCB82644;
        Thu, 10 Mar 2022 16:11:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3305C340E8;
        Thu, 10 Mar 2022 16:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646928684;
        bh=4gPhNW8LNss6l7NpCxFMRNPWBGkXwni/tXvJywJbgO8=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=NE9TlGERmCRRoF3OPNf3/pwyulJu97cN8/kI09fbmeuwLDtA+OhSLDXKdOMj+op+m
         hP6Th8JmMVlecCzipyGBO9OdgRvQOvTmNPlg3O5JPWg2SgA6jeZw5vo/QPFe6OcvmR
         0W7MKHgSyOu+cW8rLuFY/1tnTEKPPnXM1eUUQ1dgVSEoZIRYPLg25opK1wQ2xQFNXv
         9FRKEeNghOBAb13WTRBGsUbTdtJocu61daQ+AoeoUneMsBcdS748PgA2rShlhNNxO+
         ZrZAAv864XKdFfd1f5zlvqsE/sox3iPH6G6bEymYnCrXqchNKEZ19+Zzuv4HdLtdEB
         c3orFvfXrja2g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH] net: wireless: marvell: use time_is_before_jiffies()
 instead
 of open coding it
From:   Kalle Valo <kvalo@kernel.org>
In-Reply-To: <1646018045-61229-1-git-send-email-wangqing@vivo.com>
References: <1646018045-61229-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Ganapathi Bhat <ganapathi017@gmail.com>,
        Sharvari Harisangam <sharvari.harisangam@nxp.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Lennert Buytenhek <buytenh@wantstofly.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Wang Qing <wangqing@vivo.com>
User-Agent: pwcli/0.1.0-git (https://github.com/kvalo/pwcli/) Python/3.7.3
Message-ID: <164692867868.6056.1761594399458062556.kvalo@kernel.org>
Date:   Thu, 10 Mar 2022 16:11:20 +0000 (UTC)
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Qing Wang <wangqing@vivo.com> wrote:

> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

One patch per driver, please. One for mwifiex and another for mwl8k.

Patch set to Changes Requested.

-- 
https://patchwork.kernel.org/project/linux-wireless/patch/1646018045-61229-1-git-send-email-wangqing@vivo.com/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

