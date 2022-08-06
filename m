Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC62958B313
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 02:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235559AbiHFAr2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 20:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiHFAr2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 20:47:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FA94E84F;
        Fri,  5 Aug 2022 17:47:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4AE3A61534;
        Sat,  6 Aug 2022 00:47:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F35FC433D7;
        Sat,  6 Aug 2022 00:47:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659746845;
        bh=qKU0mIScsE+LVLPs1Bh8e3avqNXPQla9noA2Agdi1js=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oDFhR+WeCAGLNSbjodm23a1aw60izAuN9M4Q49mLnWs5FecrOKJTUlwjmEIvQc9kB
         qvmIwf7t7yqpWOB4riRH8sIwW1hcneSeWbehHvIRw6t0duoFv6N/m1vMa6qqLyKKFE
         1b0Cct7n22rf5pGeGUFLXGazw8pTsVTDOCWpxjSDlgzAS6tIHhbvMbTFdv3rdj+d1k
         sZE0UPZrLJGkZ1nbHxrbyTOtQ924yxA4/HwvmgifaU2CUyxTW09nbOGQcH1ZJ9mkL7
         ImJ+J/6ccQ6DsPuaIPcetC2JrzefcxoHI7Zq59Upfzmi8tYVW9qEl6ZG0moRhWaqIE
         rDYdwTn3eekZw==
Date:   Fri, 5 Aug 2022 17:47:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, linux-bluetooth@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull request: bluetooth 2022-08-05
Message-ID: <20220805174724.12fcb86a@kernel.org>
In-Reply-To: <20220805232834.4024091-1-luiz.dentz@gmail.com>
References: <20220805232834.4024091-1-luiz.dentz@gmail.com>
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

On Fri,  5 Aug 2022 16:28:34 -0700 Luiz Augusto von Dentz wrote:
> The following changes since commit 2e64fe4624d19bc71212aae434c54874e5c49c5a:
> 
>   selftests: add few test cases for tap driver (2022-08-05 08:59:15 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-08-05
> 
> for you to fetch changes up to 118862122fcb298548ddadf4a3b6c8511b3345b7:
> 
>   Bluetooth: ISO: Fix not using the correct QoS (2022-08-05 16:16:54 -0700)

Hi Luiz! 

Did you end up switching to the no-rebase/pull-back model or are you
still rebasing? 
