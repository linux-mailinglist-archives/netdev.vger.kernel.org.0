Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FC253871C
	for <lists+netdev@lfdr.de>; Mon, 30 May 2022 20:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242061AbiE3SKy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 May 2022 14:10:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235213AbiE3SKx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 May 2022 14:10:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A661A26DC;
        Mon, 30 May 2022 11:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F0C26119E;
        Mon, 30 May 2022 18:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7591C385B8;
        Mon, 30 May 2022 18:10:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653934250;
        bh=GMRBuCfZSVlPfeLJvPUNKQfnlaeimJNlXW6DlvONXXs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QbiEDWmM0Hw4RoH9U20qasNlvoiBwcFrZhQXgKGsofPncQ0OYEsIlcKCkmvaHLvmY
         acRZWG2fM6cnOmkhDAONLRQQvFFudCA7+tdW/XVlem7rPrVP5KXShgMKfLNoddpzs3
         lulSqOLlppNC8J3ebF6bOMfw9sZNWZsxiVB70BjVLvYFanPKADC5Nx9cufaDXovyMm
         UIcasTeaQgaKTMvAMnclxF7rFMcgzjpweuOwjeQMFhqvFVRf97aNuUPLIynWupMFWc
         wcm6HP/GRgj7WY6okplSPRbpmSyTDw7Yt3OUoNB0uL30vKn/j2bDedf4N6YGngoj+0
         YsvyHyL+4F16w==
Date:   Mon, 30 May 2022 11:10:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tonghao Zhang <xiangxia.m.yue@gmail.com>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Alexander Lobakin <alobakin@pm.me>,
        Paolo Abeni <pabeni@redhat.com>,
        Talal Ahmad <talalahmad@google.com>,
        Kevin Hao <haokexin@gmail.com>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>,
        Kees Cook <keescook@chromium.org>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Antoine Tenart <atenart@kernel.org>,
        Wei Wang <weiwan@google.com>, Arnd Bergmann <arnd@arndb.de>,
        idosch@nvidia.com, petrm@nvidia.com, bigeasy@linutronix.de,
        imagedong@tencent.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.18 040/159] net: sched: use queue_mapping to
 pick tx queue
Message-ID: <20220530111048.6120db70@kernel.org>
In-Reply-To: <20220530132425.1929512-40-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
        <20220530132425.1929512-40-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 30 May 2022 09:22:25 -0400 Sasha Levin wrote:
> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> [ Upstream commit 2f1e85b1aee459b7d0fd981839042c6a38ffaf0c ]

This is prep for a subsequent patch which was adding a feature.
