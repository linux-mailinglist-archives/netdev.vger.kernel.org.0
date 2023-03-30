Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750276CFAB2
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 07:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjC3FVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 01:21:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjC3FVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 01:21:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EE95266
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 22:21:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A5C6961EEE
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 05:21:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3A2C433EF;
        Thu, 30 Mar 2023 05:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680153677;
        bh=VXyTlioKePjgwIjnPApzhpIUIIgY6bK3mZXBr942vVw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TJQrbzt13CAZFfGPLRj39oQu/Nikq1a7N+JsMePmNiTEpf84+mmhoVYy07ZhFf30n
         cah4GylrK2K/yyqbYO3nNUyCGZ2JD56/R8lsYE5gNoIfXdiWG5PioBMYcyb8ItWGF4
         S682pHXrul+IsraZ26yJ0e537l7Zle2Cf8771pQv/k1qFhhumrwHr5VKnpTGrl1qnU
         i9VXw5oPYhc3FADkLaYmnHC/0nILRC9kL2Uwxn4hWCxmyGLZU643Klh6qUv0yOf9JL
         4vEdNeLtsKsgK+qXRzeG6xhiaukevMMa5Ae3n1fK6StQSVZ3cIBz0CPJDTm0eKYcA4
         T+3EBPraCExmw==
Date:   Wed, 29 Mar 2023 22:21:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Shay Agroskin <shayagr@amazon.com>,
        Arthur Kiyanovski <akiyano@amazon.com>,
        David Arinzon <darinzon@amazon.com>,
        Noam Dagan <ndagan@amazon.com>,
        Saeed Bishara <saeedb@amazon.com>, Tom Rix <trix@redhat.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: ena: removed unused tx_bytes variable
Message-ID: <20230329222115.5c58b99a@kernel.org>
In-Reply-To: <20230328151958.410687-1-horms@kernel.org>
References: <20230328151958.410687-1-horms@kernel.org>
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

On Tue, 28 Mar 2023 17:19:58 +0200 Simon Horman wrote:
> clang 16.0.0 with W=1 reports:
> 
> drivers/net/ethernet/amazon/ena/ena_netdev.c:1901:6: error: variable 'tx_bytes' set but not used [-Werror,-Wunused-but-set-variable]
>         u32 tx_bytes = 0;
> 
> The variable is not used so remove it.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>

Applied, thanks!
