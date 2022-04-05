Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC8A34F231C
	for <lists+netdev@lfdr.de>; Tue,  5 Apr 2022 08:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230201AbiDEGbf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Apr 2022 02:31:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiDEGbc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Apr 2022 02:31:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 849B433A3D;
        Mon,  4 Apr 2022 23:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A150B81B98;
        Tue,  5 Apr 2022 06:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89032C340F3;
        Tue,  5 Apr 2022 06:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649140171;
        bh=kcD8piI7TjLNSLlS5U7+xwCT0pyjngczKZUKaVKe62g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SXWR9MZJVas509w7bdMer/rdOmzJObKxWjVaxkDzLQaMoTDQ68FT6/vU8KcTIv8Kx
         ggyeVL29ksUI1Rz+ntwzQTX6SY6xK0379tgjk3bNjkQl2GJ+ULgGbT/sLXhGhGZC1Q
         Nz/OdxeaU/NpOfLiIyqcJ4gSr3mGKUuBVeHmpSeV78lanr2Vk7lwquL+Ma9/hGgL45
         slYvnN+H2hOa3jzGTdXFejHfOU/5v11pTb2mujoVvX5/WZ7sYbv1JilbUBqMmgVOYM
         jvZu3N4mOh2/180R6AlD5v62WkTW0sW8G6Rfmohag6EkkIIPtx5JpeTaqK0YV7aWkq
         AC3rE717h7hCg==
Date:   Mon, 4 Apr 2022 23:29:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     =?UTF-8?B?SsOpcsO0bWU=?= Pouiller <jerome.pouiller@silabs.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH v10 0/1] wfx: get out from the staging area
Message-ID: <20220404232930.05dd49cf@kernel.org>
In-Reply-To: <20220404232247.01cc6567@kernel.org>
References: <20220226092142.10164-1-Jerome.Pouiller@silabs.com>
        <YhojjHGp4EfsTpnG@kroah.com>
        <87wnhhsr9m.fsf@kernel.org>
        <5830958.DvuYhMxLoT@pc-42>
        <878rslt975.fsf@tynnyri.adurom.net>
        <20220404232247.01cc6567@kernel.org>
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

On Mon, 4 Apr 2022 23:22:47 -0700 Jakub Kicinski wrote:
> On Mon, 04 Apr 2022 13:49:18 +0300 Kalle Valo wrote:
> > Dave&Jakub, once you guys open net-next will it be based on -rc1?  
> 
> Not normally. We usually let net feed net-next so it'd get -rc1 this
> Thursday. But we should be able to fast-forward, let me confirm with
> Dave.

Wait, why is -rc1 magic? If you based the branch on whatever
the merge-base of net-next and staging-next is, would that be
an aberration?
