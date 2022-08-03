Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC12E58949A
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 01:01:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231713AbiHCXBy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Aug 2022 19:01:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229842AbiHCXBx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Aug 2022 19:01:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10AB34D4EA
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 16:01:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D34C61655
        for <netdev@vger.kernel.org>; Wed,  3 Aug 2022 23:01:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDBAC433D6;
        Wed,  3 Aug 2022 23:01:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659567711;
        bh=L27HubGV5Q2E7GlhwpBS8cT8K8zlJopoJ7kK4lTRA9A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dujplTk1k/bUdLSse2AQnAipmBvachcLdki7bWXK/7wYdtTpsxR3x7aLffqcWevDL
         QjZREVki5O9vJVhXtR5fnA5T4Pasd6QX0jzMCq0jkzrjhOG+nzCoZY4Va9zqe4oRxo
         Y0pEGztQZU1p839IZWBPD/OVejthQHvkvNRI4QoRUtjsUVh7XvrXl342DFmZhzfGTg
         Gp5BnGd6UbJ+3zJ55+4q//8JU3zTHsz/f28ku/AYvrIrBaPA1NdJw/1lRyt/S1/vvh
         UItamlqMrjXYH6c8R8cPrkXXoa+GB9YevIC66Le2Pqpln9Xk/parlev9TXg5U9wtbD
         N5rWoLakUNP0A==
Date:   Wed, 3 Aug 2022 16:01:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 0/6] tsnep: Various minor driver improvements
Message-ID: <20220803160150.6265b1b8@kernel.org>
In-Reply-To: <20220803204947.52789-1-gerhard@engleder-embedded.com>
References: <20220803204947.52789-1-gerhard@engleder-embedded.com>
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

On Wed,  3 Aug 2022 22:49:41 +0200 Gerhard Engleder wrote:
> During XDP development some general driver improvements has been done
> which I want to keep out of future patch series. Additionally, the
> kernel test robot told me to fix a warning.

# Form letter - net-next is closed

We have already sent the networking pull request for 6.0
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 6.0-rc1 is cut.

RFC patches sent for review only are obviously welcome at any time.
