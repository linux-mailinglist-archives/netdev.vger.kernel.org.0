Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 140246D0D06
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 19:42:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231590AbjC3Rmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 13:42:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230152AbjC3Rmx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 13:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 889ABE04A
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 10:42:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 427D3B8233F
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 17:42:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC84C433EF;
        Thu, 30 Mar 2023 17:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680198170;
        bh=qBx0GAkim+IFjAX/6NYCJev7vZtgfCSJSIfeUQlFSr8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W4NZ6B9SdHiPzMhf/VHQ6rHUsg/IwnPuCSZHbtfFh6MrRUag/DIcDMMlt4WCDqBwl
         zA6SvBn8vgjBVUroXh/aB21ixk6MLC7KZAbMkgPfzIpBsEFUpviyFf2NK38PCrgvwB
         RxrNRp3ITuf0S6Po8K7Qxzmn4GIkU6atDydcfky8/NwnnGvVAbGdlPUr5vgfjVJjbM
         ohSA8iwFMJdYpGjWEuHpN1OlW0Kb7qmaaonJqApRWSvUy0Qm2v9lftFnQ7RGDb5Gdo
         GU4qaoCzarhQnMZ1wtxI+rIz1CPSzOO29J8MiJexmE5cYoTMu07N3ZrtjP1tGGTyK6
         N0/m0Ls2o9noQ==
Date:   Thu, 30 Mar 2023 10:42:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     Leon Romanovsky <leon@kernel.org>, Emeel Hakim <ehakim@nvidia.com>,
        davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/4] vlan: Add MACsec offload operations for
 VLAN interface
Message-ID: <20230330104248.2c884f5c@kernel.org>
In-Reply-To: <ZCXEmUQgswOBoRqR@hog>
References: <20230329122107.22658-1-ehakim@nvidia.com>
        <20230329122107.22658-2-ehakim@nvidia.com>
        <ZCROr7DhsoRyU1qP@hog>
        <20230329184201.GB831478@unreal>
        <ZCXEmUQgswOBoRqR@hog>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Mar 2023 19:19:21 +0200 Sabrina Dubroca wrote:
> I don't think you should be reposting
> until the existing discussion has settled down.

Thanks for that note, very true, v3 discarded.
