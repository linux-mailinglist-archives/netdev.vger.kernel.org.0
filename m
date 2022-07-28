Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19D34583744
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 05:03:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234665AbiG1DDe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 23:03:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233580AbiG1DDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 23:03:33 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 670125B058;
        Wed, 27 Jul 2022 20:03:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D835B82313;
        Thu, 28 Jul 2022 03:03:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FFFBC433D6;
        Thu, 28 Jul 2022 03:03:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658977409;
        bh=yjVbuDpxK/8ZdG8Poc6EVBdJl9jsQ75NKjn56Pu+uVQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DfIZw4Ojpiez9qcP+S9aC+wSzBtTDZjK67t0JFtGK/7MXKUt7ohtfEvHIry+iGwhW
         Yav4gecUXfhGkYy/JSNFoOewKJk7CPueV8xaZBRkLbjUG9gMWQTf++ChwlF0W9ROMU
         vqNzES76A5SUZuJRW79Jrdvr/3vzPrTDdJ9MuTQ/nPFCoR1LiZso33AvP8FOmENiF1
         awy+tQ9C/xhNDTVnI1+1pZu9reMdinG0hh/PqkNE7W5Huhd8m/AvYtfp2GLvjH/T3C
         JAojPngKryqNOVkWeSIIEwumqGkUyS961rbs0xUTLIUvzLAatN5wlMtfWGAmlRVf0J
         WWerUxA7l5+FA==
Date:   Wed, 27 Jul 2022 20:03:28 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     RuffaloLavoisier <ruffalolavoisier@gmail.com>
Cc:     Taehee Yoo <ap420073@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/net/amt.c : fix typo
Message-ID: <20220727200328.42a0f678@kernel.org>
In-Reply-To: <20220727165640.132955-1-RuffaloLavoisier@gmail.com>
References: <20220727165640.132955-1-RuffaloLavoisier@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 Jul 2022 01:56:40 +0900 RuffaloLavoisier wrote:
> Signed-off-by: RuffaloLavoisier <RuffaloLavoisier@gmail.com>

And please add a space between your name and surname in the author line
and the sign-off tag.
