Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B660526C56
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 23:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378226AbiEMVd4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 17:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232968AbiEMVdy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 17:33:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3EF8BF42;
        Fri, 13 May 2022 14:33:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 10E2262328;
        Fri, 13 May 2022 21:33:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C11FC34100;
        Fri, 13 May 2022 21:33:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652477631;
        bh=VSnJXZ8+t+dZhN43aAd+oFkMmOxWgx8f608mCX7Qpxk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=f2y2Ri8QAGC6zXWCiKrh1aKBiD3mWKOFS2UQhb+teqMzdNPZ5p8MxOYPYtszZxcAO
         LyjGW6Bu61+gEB3FCoJJA8Xb5dPfrS9f6u7cNTc2dhZ0zL1P+ceplnbrOIcg42//px
         FAuKZEdup/uXNGlU5sKaoyEz7AZanWeCQQgMcxuuX6TGWMFhktE3Fc5MWY564ra+XW
         j/CAuU9NKKX4/87WURtYAbhIqvKLPMsJtryeOgfT2ZJcW2L7eqYKSmPx9HCHMDFStN
         TkxBan8ZpJewNDuG//A4WqWGD3CSXjLYp7t9vsjLTaXCZC9LwI0sn+NDXLX2W0ZT4s
         +8ZwbaOmmHtwg==
Date:   Fri, 13 May 2022 14:33:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <min.li.xe@renesas.com>
Cc:     "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "lee.jones@linaro.org" <lee.jones@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net v5 3/3] ptp: clockmatrix: miscellaneous cosmetic
 change
Message-ID: <20220513143349.1483fcf8@kernel.org>
In-Reply-To: <TYCPR01MB6608DC38FC74BB484E2B6079BACA9@TYCPR01MB6608.jpnprd01.prod.outlook.com>
References: <1652279114-25939-1-git-send-email-min.li.xe@renesas.com>
        <1652279114-25939-3-git-send-email-min.li.xe@renesas.com>
        <20220511173732.7988807e@kernel.org>
        <OS3PR01MB659312F189453925868225B2BACB9@OS3PR01MB6593.jpnprd01.prod.outlook.com>
        <20220512090300.162e5441@kernel.org>
        <TYCPR01MB6608DC38FC74BB484E2B6079BACA9@TYCPR01MB6608.jpnprd01.prod.outlook.com>
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

On Fri, 13 May 2022 19:57:26 +0000 Min Li wrote:
> There are multiple places where "no empty line between call and error
> check" and "return directly" like you pointed out before. Some are
> related to this change and some are not. Do you prefer to fix only
> the related ones in this patch or do them all in another patch to
> net-next

Let's forget cleaning up the code not touched by patches 1 and 2.

Within the lines of code patches 1 and 2 touch - by which I mean the
lines listed with a '+' at the start - please make sure there are
no instances of the formatting issues there.
