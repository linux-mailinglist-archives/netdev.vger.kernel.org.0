Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F12E54F2301
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbiDEGYu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:24:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229687AbiDEGYr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:24:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9F3C205CA;
        Mon,  4 Apr 2022 23:22:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45F9B61532;
        Tue,  5 Apr 2022 06:22:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFBFC340F3;
        Tue,  5 Apr 2022 06:22:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649139768;
        bh=xXEL+YknXtKDAX6XRHo39ncmyrqoFzRAaSwV+tKIxe8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aD1FdEE+PjeEtJnBg650OCYILre8OzP8v40FdDy5cbvhCWRYDc2pvgHvux4cM8u5i
         p5gREJM62TQ3fD2H+gI1hJQq3ecP+YK3wxJI/RxD4/t1VQ+NkickrYY6HtCCaZJXEJ
         spfT+oxfgtqZYNDKj3FtpuqovlVqgOyIZSCIwR6zm+n8JuujG7HHbhLmKW6V9G7Qrf
         twEEdkNdTOhHpur5LyeAiFrZEi116H7FQntis3ZgnIEFrLfH1hWaQZDkh8M77pZCcN
         FqAmSeAZozOCRTKF/DRcUJesJPKwmfvzi0h9L8eezmKrYIZlfMZbFtPFuFkhvYNH/F
         biMWWEiasMK4w==
Date:   Mon, 4 Apr 2022 23:22:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
Message-ID: <20220404232247.01cc6567@kernel.org>
In-Reply-To: <878rslt975.fsf@tynnyri.adurom.net>
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com>
        <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42>
        <878rslt975.fsf@tynnyri.adurom.net>
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

On Mon, 04 Apr 2022 13:49:18 +0300 Kalle Valo wrote:
> Dave&Jakub, once you guys open net-next will it be based on -rc1?

Not normally. We usually let net feed net-next so it'd get -rc1 this
Thursday. But we should be able to fast-forward, let me confirm with
Dave.

> That would make it easier for me to create an immutable branch between
> staging-next and wireless-next.
