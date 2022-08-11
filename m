Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B430A5905C8
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235810AbiHKRXw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 13:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbiHKRXg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 13:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2BD5D6D
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 10:23:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AECF7B821AD
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 17:23:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D0AC433D6;
        Thu, 11 Aug 2022 17:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660238591;
        bh=l35eimNCqHrzCfY6lFspwF8Dszt3X0XExhhFE27jNto=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LfRjk+BIbh5FXhLvst06wIuzPFYVSrlmcA6vGkPlbwf08o8DuVyJ0AwIPxO2hzzQH
         7GXeLKXeNuCF+owdKHt2VvNVVdg87URecUE9FdlNUQPDGeRUt4FPXLTVTOtC/sRb67
         l68m0M1YWV703Mt0V8HaVijzXBHbr8vjsiL4cx3ydmMEwUtA4U1eOGEm9NUOqqyL72
         JQCHukx3aKd0gG1oaN5inZk/3ovJhcK7Y7pSu/hHJu56RTLc61JvpTz91P6TmkMRJ0
         9SatHUE+3zGO0yHG23vF/pxqkMNT7RX3N9uCU1L1X0FRB8ugLmxIcWanqQbXjQIffu
         4GaEH7fX7u5lQ==
Date:   Thu, 11 Aug 2022 10:23:10 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, kernel-team@cloudflare.com,
        van fantasy <g1042620637@gmail.com>
Subject: Re: [PATCH net] l2tp: Serialize access to sk_user_data with sock
 lock
Message-ID: <20220811102310.3577136d@kernel.org>
In-Reply-To: <20220810102848.282778-1-jakub@cloudflare.com>
References: <20220810102848.282778-1-jakub@cloudflare.com>
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

On Wed, 10 Aug 2022 12:28:48 +0200 Jakub Sitnicki wrote:
> Fixes: fd558d186df2 ("l2tp: Split pppol2tp patch into separate l2tp and ppp parts")

That tag immediately sets off red flags. Please find the commit where
to code originates, not where it was last moved.

> Reported-by: van fantasy <g1042620637@gmail.com>
> Tested-by: van fantasy <g1042620637@gmail.com>

Can we get real names? Otherwise let's just drop those tags.
I know that the legal name requirement is only for S-o-b tags,
technically, but it feels silly.
