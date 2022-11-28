Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE06063B3F8
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 22:09:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234420AbiK1VJ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 16:09:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234421AbiK1VJN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 16:09:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 691BBF5D
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 13:09:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 114E6B80FEE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 21:09:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C5CBC433D6;
        Mon, 28 Nov 2022 21:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669669749;
        bh=+CXegsj1ZFItnR3XY5Zv7C+mrZ4KG8jBHq4g0xCxT4s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UCHIVXos8wYvM5eTIFFymQxIJEF7usipbVkajsnXSe3uAYYZKrqs/B7y8LEmhsZT3
         5VGWIo3JUV5B3uWzXosVVDI4CGhQ5K6EihwclTI8pSHNsDHxHxMaVbw4u1Wt9LLdY1
         AEhLG9Z9BHXhLnBD8I9PhalnqM6Q8L8axamEKBp8yrGZOTmRCCpXL6VQKm6JqNAOr6
         TBchHoH2RsUSgrh/3vBSEkIai/m1kNC0D0y3BlwXyGYm3OUVkDUpO0CkteFa7WLSm8
         qkmWT+vFRnSHUIhy46DVp6vOeA27fdazZHU7GWUSKU1T+Wcct+U3qjNpPwMH1n0ufu
         CHGmhPmZWbH5A==
Date:   Mon, 28 Nov 2022 13:09:08 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Piergiorgio Beruto <piergiorgio.beruto@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: stmmac compile error
Message-ID: <20221128130908.24bc058e@kernel.org>
In-Reply-To: <20221125105715.obo2vz6mkilmsva4@skbuf>
References: <Y4CK8n8AiwOOTRFJ@gvm01>
        <20221125105715.obo2vz6mkilmsva4@skbuf>
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

On Fri, 25 Nov 2022 12:57:15 +0200 Vladimir Oltean wrote:
> That's pretty sad. Something went terribly wrong with the review process of this patch.
> https://patchwork.kernel.org/project/netdevbpf/patch/202211222009239312149@zte.com.cn/

Do you mean that the build has passed? The code is under ifndef MODULE
and we build with allmodconfig :(
