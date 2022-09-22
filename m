Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4C525E6DA5
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 23:06:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiIVVGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Sep 2022 17:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIVVGZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Sep 2022 17:06:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A1D710CA79
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 14:06:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28100B82A9B
        for <netdev@vger.kernel.org>; Thu, 22 Sep 2022 21:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82098C433D6;
        Thu, 22 Sep 2022 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663880781;
        bh=8gtcJMWsQucIUWVcWSDmdzHFYpreY6XVbXWHxg5QltM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ARizUFQ4axl36QfAZ2/KAI9E3Qnzwm9dE8J08icoYzXctSf7BMzjKKqlXJFIkiu8I
         45YL9czavPBF8mvNQ20PybdXnNNGktnxI40H9T0rRwWMYaAGeO09qxC8pKFzHdSYw8
         rh7cfIRbzyN2+W0bhxIo/TAkjSHtmt+1NJ7fUuqdiFHtTwWKSBL/vYunNSvj96mnRA
         kpW4nK6lU+pgCgMPAuCsDNeUPB0mnKhbvARYmHdHRi/Rus6CfwXhr/8RUHhI2Mwwyr
         hvg7bXK6dLIltqZinpbqHgfNNXL1oBTcQHcBRBGx73ox3iJluzcugyQB2rp4McqGb/
         OvNfLec+J5njQ==
Date:   Thu, 22 Sep 2022 14:06:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Paul Blakey <paulb@nvidia.com>, Vlad Buslov <vladbu@nvidia.com>,
        Oz Shlomo <ozsh@nvidia.com>, Roi Dayan <roid@nvidia.com>,
        netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net 1/1] net: Fix return value of qdisc ingress handling
 on success
Message-ID: <20220922140620.1c032401@kernel.org>
In-Reply-To: <20220922082349.18fb65d6@kernel.org>
References: <1663750248-20363-1-git-send-email-paulb@nvidia.com>
        <c322d8d6-8594-65a9-0514-3b6486d588fe@iogearbox.net>
        <20220921074854.48175d87@kernel.org>
        <2338579f-689f-4891-ec58-22ac4046dd5a@iogearbox.net>
        <20220922082349.18fb65d6@kernel.org>
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

On Thu, 22 Sep 2022 08:23:49 -0700 Jakub Kicinski wrote:
> What I meant is we don't merge fixes into net-next directly.
> Perhaps that's my personal view, not shared by other netdev maintainers.

FWIW I've seen Eric posting a fix against net-next today 
so I may indeed be the only one who thinks this way :)
