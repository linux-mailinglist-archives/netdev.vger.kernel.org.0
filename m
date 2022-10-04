Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 113A95F3A6C
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 02:13:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbiJDANY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Oct 2022 20:13:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiJDANX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Oct 2022 20:13:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058FE10EB;
        Mon,  3 Oct 2022 17:13:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B85561227;
        Tue,  4 Oct 2022 00:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94936C433D6;
        Tue,  4 Oct 2022 00:13:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664842401;
        bh=rEyBoMnRdLySDb0TCiNgLvexuokCg0u5ncq0WrmAa34=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vFGrqLybBhEuQ2Mt16pcwLSPxX1hqmOM8ORsx0cxLKHDUUcrsPdzbEkpSZMWxukV/
         CMJVM6vC6ZQPWmnEgAdFxSuEUfXmH+MRevW37wYQDMBrOao2kYAJm9QKbfjz0LuvZs
         oY9rCbRiOYyMgdIM/Au+ynv22KirQ/2iDFh8rQQyaDD3wwcZtejP1vWGGFIP1068hz
         f9RRzslya+JqH7AX0+1L2sA1Bxc9GDXucaDR/1lVhLs8o+gs8HXhOK2j8jy6apiZ2s
         SrA6wJhbq7V4dq7vuoMyZNORxvowyIu/MKAxOOEAoPGrq/kL2Rn8HzmpsCeL/jkdV7
         /Dqjmc+nOxxOA==
Date:   Mon, 3 Oct 2022 17:13:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Yang <mmyangfl@gmail.com>
Cc:     Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for
 Kirkwood
Message-ID: <20221003171320.23201c56@kernel.org>
In-Reply-To: <20221001174524.2007912-1-mmyangfl@gmail.com>
References: <202210020108.UlXaYP3c-lkp@intel.com>
        <20221001174524.2007912-1-mmyangfl@gmail.com>
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

On Sun,  2 Oct 2022 01:45:23 +0800 David Yang wrote:
> Subject: [PATCH v6] net: mv643xx_eth: support MII/GMII/RGMII modes for Kirkwood
> Date: Sun,  2 Oct 2022 01:45:23 +0800
> X-Mailer: git-send-email 2.35.1
> 
> Support mode switch properly, which is not available before.
> 
> If SoC has two Ethernet controllers, by setting both of them into MII
> mode, the first controller enters GMII mode, while the second
> controller is effectively disabled. This requires configuring (and
> maybe enabling) the second controller in the device tree, even though
> it cannot be used.
> 
> Signed-off-by: David Yang <mmyangfl@gmail.com>
> ---
> v2: clarify modes work on controllers, read default value from PSC1
> v3: Kirkwood only
> v4: cleanup
> v5: test on 88f6282

I don't see any of the versions before v5, you should restart numbering
when you post something to the list for the first time.

Regardless, the merge window has now started (after Linus tagged 6.0)
and will last until he tags 6.1-rc1 (two weeks from now). During this
time we'll not be taking any patches adding new features/support so
please repost in around 2 weeks.

Thanks!
