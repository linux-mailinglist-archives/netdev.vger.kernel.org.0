Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F14574BC572
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 05:58:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241323AbiBSE64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 23:58:56 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241321AbiBSE6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 23:58:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBA625F259
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 20:58:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75429B82545
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 04:58:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E320DC004E1;
        Sat, 19 Feb 2022 04:58:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645246714;
        bh=saGmzTj9IX9+ieOIVHKsmNGBFyfpPvmmCCZz4F6HQUs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=L7PERKGmmz79oawaCrwYcBi4aQzhtmqvSjjb7JnvO9/q5f0cy14aK7Mejr3xCAZjA
         0j8u5pHXnvXJxTcOrrfM/75qAukaITi9OQT1ThIhvuadxihvMuSoFm1Qwh7fbr6y24
         09SKJGqfe4DOSNgUeY7hANh0GY8rwkYbfm403Ss0jjpYDqs2304PqVVi4vdrh3jkHn
         twxC0tKJK6ROujIH/OQUOFbdV9mQu320kg02ITXTUItwiWFd5YxRtZCrTca+HtImGS
         0InS1UEpESrVFNCW7689HleOh0E/wyyEG1nqpcHUFS+TTUTDeywcwnLHbeI5N01ADQ
         UvE8flCoqPyLQ==
Date:   Fri, 18 Feb 2022 20:58:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v7 0/8] new Fungible Ethernet driver
Message-ID: <20220218205833.0145f8c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220218234536.9810-1-dmichail@fungible.com>
References: <20220218234536.9810-1-dmichail@fungible.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Feb 2022 15:45:28 -0800 Dimitris Michailidis wrote:
> This patch series contains a new network driver for the Ethernet
> functionality of Fungible cards.
> 
> It contains two modules. The first one in patch 2 is a library module
> that implements some of the device setup, queue managenent, and support
> for operating an admin queue. These are placed in a separate module
> because the cards provide a number of PCI functions handled by different
> types of drivers and all use the same common means to interact with the
> device. Each of the drivers will be relying on this library module for
> them.

I'll review this after the long weekend. Please try to avoid dumping
large chunks of code on the reviewers on Friday afternoon.
