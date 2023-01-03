Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 561EE65C86A
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 21:52:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238959AbjACUwP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Jan 2023 15:52:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbjACUvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Jan 2023 15:51:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3F41C745
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 12:51:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 572FD614B4
        for <netdev@vger.kernel.org>; Tue,  3 Jan 2023 20:51:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DDB9C433EF;
        Tue,  3 Jan 2023 20:51:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672779113;
        bh=PAmPwntmybjQPkJNoPlieB2KOaE2i8E+qtXxAYOrFXo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qFPFDemYrPI/7qc98kcOArO1xf5KpYmi94jNn6JZwmc/oxGBGPiFHN4vdGgXOvZ+i
         bJpmwbfamHSEh4YX0/q7EMtc9MJrKm98RwlsR2hO17ORg2S5BlHfzCZfrY2MuC2nhR
         UXclvVsKuiflDzJwhHeZcoCNl/aMyeefkaiEsh477j1mHIWUyohtziVHf2JibgDQ2I
         b7gu0FvQXVetgCdEcvY1FGgR+5pH4SG3hw34lkY+KefQi5U/WKgrnjd/6Fp0W3WpO/
         WaLe+fC99mGr2R20FpyFKisrQOkxKsWtcPXdG56H6gYen9EgrQlmF+SQBgQ/3J5YdR
         jrMR56DVyM0Sg==
Date:   Tue, 3 Jan 2023 12:51:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Emeel Hakim <ehakim@nvidia.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Raed Salem <raeds@nvidia.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "edumazet@google.com" <edumazet@google.com>,
        "pabeni@redhat.com" <pabeni@redhat.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "atenart@kernel.org" <atenart@kernel.org>
Subject: Re: [PATCH net-next 1/2] macsec: add support for
 IFLA_MACSEC_OFFLOAD in macsec_changelink
Message-ID: <20230103125152.17c5c440@kernel.org>
In-Reply-To: <IA1PR12MB6353281A503DF0337FE98655ABF49@IA1PR12MB6353.namprd12.prod.outlook.com>
References: <20221227082517.8675-1-ehakim@nvidia.com>
        <IA1PR12MB6353281A503DF0337FE98655ABF49@IA1PR12MB6353.namprd12.prod.outlook.com>
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

On Tue, 3 Jan 2023 08:55:56 +0000 Emeel Hakim wrote:
> I see in Patchwork that this patch status is "Deferred" , I was asked to send
> a fix for accessing a net device prior to holding a lock and that is done (fix is accepted).
> Is there a reason of the deferred status , is it pending anything from my side?

net-next was closed, please resend now.
