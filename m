Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDD724AC723
	for <lists+netdev@lfdr.de>; Mon,  7 Feb 2022 18:21:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380262AbiBGRSN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 12:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1392223AbiBGRMe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 12:12:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1CB4C03FED7;
        Mon,  7 Feb 2022 09:12:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7F84B611B3;
        Mon,  7 Feb 2022 17:12:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73DFDC004E1;
        Mon,  7 Feb 2022 17:12:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644253933;
        bh=Mfq+NKDvKmIavHgmM98+eLkiR+ISFyLuc7r9Q1vKuM8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=hh/hPvuisS1Sn080BXZGrUqoKNi5YT5Ww9OqzwH0wDrXfgMLK9NudTSx3CaKMYact
         Q3MLchoQvj9uSkV9Ilgwy0idOYucdBoIrABk4YMy30GSAgYzhLgb4ovMC8HCYKt4kp
         wnfzkCMSwJ6i0lLVuMJRyGaW1PNumyalZmrubDwb0mZq2bIHUVM6CGvSCjFmDdoRNq
         BntMU++8IPKV71XW/82E2rqS/BIfyNWF91SqLx+hICwUUM1PGXI9tVtX1MJQTr9Zlk
         iFTZRY2Jc61gi/OdeFRI3Z3YuQwHT7rA30HZqRDzcjCgx4jqcDA4LEABo5eF+S5WBz
         Ne/+pHW3gaXhw==
Date:   Mon, 7 Feb 2022 09:12:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Haiyang Zhang <haiyangz@microsoft.com>
Cc:     "linux-hyperv@vger.kernel.org" <linux-hyperv@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Dexuan Cui <decui@microsoft.com>,
        KY Srinivasan <kys@microsoft.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        Paul Rosswurm <paulros@microsoft.com>,
        Shachar Raindel <shacharr@microsoft.com>,
        "olaf@aepfle.de" <olaf@aepfle.de>, vkuznets <vkuznets@redhat.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next, 1/2] net: mana: Add handling of
 CQE_RX_TRUNCATED
Message-ID: <20220207091212.0ccccde7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
References: <1644014745-22261-1-git-send-email-haiyangz@microsoft.com>
        <1644014745-22261-2-git-send-email-haiyangz@microsoft.com>
        <MN2PR21MB12957F8F10E4B152E26421BBCA2A9@MN2PR21MB1295.namprd21.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 5 Feb 2022 22:32:41 +0000 Haiyang Zhang wrote:
> Since the proper handling of CQE_RX_TRUNCATED type is important, could any
> of you backport this patch to the stable branches: 5.16 & 5.15?

Only patches which are in Linus's tree can be backported to stable.
You sent this change for -next so no, it can't be backported now.
You need to wait until 5.17 final is released and then ask Greg KH 
to backport it.
