Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 191664D8B5A
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 19:09:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241041AbiCNSKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 14:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231370AbiCNSKn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 14:10:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B8DDE007
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 11:09:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEB7061004
        for <netdev@vger.kernel.org>; Mon, 14 Mar 2022 18:09:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0101AC340E9;
        Mon, 14 Mar 2022 18:09:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647281371;
        bh=9CXcga0ksuOAHFJ0nD3uGmnrXyAzjbwTV8vAmmEXss4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=e1/BJrz/QQO5SbYuoumgAd51MEwY0Yns0vOBJqEqGwObl6hlKujqdqJKHMc7to+Q5
         AVeSrRvf89fkHTDo/mBUbt2ZcbjVTg0zonB1KYMD+bVpgEDLu9hVcLt3+QL+aSNYTs
         4Ln6i7/le+17kuzizG0t0Fwv25S86auZxPYCAlV4iMS52wJoktcZYUQmyFrI4uJlrl
         AwWbDoEHpCcEp5zG5ZHgq3EbMvi0kQMAtDsKlN0gCN3yt0FCkU70uOGU0UWtaM3upR
         WNocwj5lWudhw6N9o9BIpjPWnl0pIPL9Q/4g+EuScxchd9t8wFqDvrXJxD728Wq7B3
         mmCvDlTgCSoIQ==
Date:   Mon, 14 Mar 2022 19:09:26 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Jan =?UTF-8?B?QsSbdMOtaw==?= <hagrid@svine.us>
Subject: Re: [PATCH net] net: dsa: fix panic when port leaves a bridge
Message-ID: <20220314190926.687ac099@dellmb>
In-Reply-To: <20220314174700.56feb3da@dellmb>
References: <20220314153410.31744-1-kabel@kernel.org>
        <87tuc0lelc.fsf@waldekranz.com>
        <20220314174700.56feb3da@dellmb>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Mar 2022 17:47:00 +0100
Marek Beh=C3=BAn <kabel@kernel.org> wrote:

> Tobias, I can backport these patches to 5.4+ stable. Or have you
> already prepared backports?

OK the patches are prepared here

https://secure.nic.cz/files/mbehun/dsa-fix-queue/
