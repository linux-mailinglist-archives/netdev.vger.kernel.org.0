Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5D115241B8
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 02:54:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233888AbiELAy3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 20:54:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiELAy2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 20:54:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E237060AAB
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 17:54:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A0B061E2B
        for <netdev@vger.kernel.org>; Thu, 12 May 2022 00:54:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B45EEC340EE;
        Thu, 12 May 2022 00:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652316866;
        bh=yQJf3L9aSDPG782zOU560QtLBoRgpxP1C6EHTO4Qi9Y=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MvCLXBR/SDQUAiGRFhPpDtAV4SNGOaK7ioq8Hfe5r+N+8kFYXlqIA7QuwIj7m3IYl
         /yY1D6c6IW9d3APB+DU4v7IvTgxDXMPv+3RNvgT3UehJhU/Ypl0eCDh7cLse9jhqCo
         TDyI4m//UmsMIB8Kf3/LI7tl7qlTmNj1bcjX4Vg9yrS3PeURofJ7B3H/IgupdcbPxY
         EmKZFJpHUL8qSSf0QnajucKeGCtP7sb8sG7aJgLDewzty0dXbPfAQ8EIUQ/c8fJ6DZ
         Wm1HnuMq5gymRVaN3KclN6ZNyieXpS2C0D6v5ULRrYscQaPnI+q6RKkzoaEN1dOosr
         wj6aW9/8n02gQ==
Date:   Wed, 11 May 2022 17:54:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] Wangxun 10 Gigabit Ethernet Driver
Message-ID: <20220511175425.67968b76@kernel.org>
In-Reply-To: <20220511032659.641834-1-jiawenwu@trustnetic.com>
References: <20220511032659.641834-1-jiawenwu@trustnetic.com>
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

On Wed, 11 May 2022 11:26:45 +0800 Jiawen Wu wrote:
>  22 files changed, 22839 insertions(+)

Cut it up more, please. Expecting folks to review 23kLoC in one sitting
is unrealistic. Upstream a minimal driver first then start adding
features.
