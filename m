Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 499A36A4965
	for <lists+netdev@lfdr.de>; Mon, 27 Feb 2023 19:15:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231158AbjB0SPj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Feb 2023 13:15:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbjB0SPh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Feb 2023 13:15:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 796541F91F;
        Mon, 27 Feb 2023 10:15:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A7B4B80D6D;
        Mon, 27 Feb 2023 18:15:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 910BEC433D2;
        Mon, 27 Feb 2023 18:15:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677521734;
        bh=tuhFb9QMn6r+rliYClUcpTW9i8Qk9Z01jLxT/7l06Mw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oMtKAl1XtashgTyRYboildt/3wpmyykmXPq9KUuw1BIuIFsHvXG8bPQWdnzUDpgqP
         UV2jBo1grAmHIFall2+lg3lOiqUMRLtkh1geho79rccR96nMRqxJssM/H38QyDcWuP
         LNw12BYf8xBoEE2SLNVYGqc4J03tsRQR/cnlxuPCeOO88qsydUMrAS5eP47bEIpanZ
         yfgwDCG6dVA69Rs8dsaXxxWwqU9iDDVSC02ywXANuLlK0t7rRg2NmW141oncvK8SSW
         c27K9t5+j6U4Qx9O3iqWidoYBMFIsKRvWkBYgMVHukVv795yBcTDuosaAED9IzPIxX
         VrTVcS7v+BOYg==
Date:   Mon, 27 Feb 2023 10:15:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Breno Leitao <leitao@debian.org>,
        Michael van der Westhuizen <rmikey@meta.com>,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        wsa+renesas@sang-engineering.com, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.2 26/53] netpoll: Remove 4s sleep during
 carrier detection
Message-ID: <20230227101532.5bc82c09@kernel.org>
In-Reply-To: <20230226144446.824580-26-sashal@kernel.org>
References: <20230226144446.824580-1-sashal@kernel.org>
        <20230226144446.824580-26-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 26 Feb 2023 09:44:18 -0500 Sasha Levin wrote:
> From: Breno Leitao <leitao@debian.org>
> 
> [ Upstream commit d8afe2f8a92d2aac3df645772f6ee61b0b2fc147 ]
> 
> This patch removes the msleep(4s) during netpoll_setup() if the carrier
> appears instantly.
> 
> Here are some scenarios where this workaround is counter-productive in
> modern ages:

Potential behavior change, can we wait 4 weeks, until it's been 
in a couple of -rcs?
