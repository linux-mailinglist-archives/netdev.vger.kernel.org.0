Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41B6858E667
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 06:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbiHJE1W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 00:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiHJE1V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 00:27:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFEB782F94;
        Tue,  9 Aug 2022 21:27:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C9F9CE1856;
        Wed, 10 Aug 2022 04:27:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53110C433C1;
        Wed, 10 Aug 2022 04:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660105635;
        bh=9FmiVRTko5aB/Q3pcYBD+9QwKvKuIEto00QWN20fvKE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=pkD09gkNTLMsC1jptgw9k64j/vPiICqlmXfB6PyxfoKmfgLuk03kh7Piv20uFaNNB
         Q+GARC3jjyobiMKzEai+OESCQiSLk6SLDQjgtbMhiHrTmM+x19gP74pu7nbwvOrGGJ
         d3b+PoJolSUyKOrzQI+x/29wfia1QqtcZFJRIWLL+KDEUnp0C0wtrSy8dk6QZPUQtM
         +jdxNy4a95MxoVsSkGYEEfzTKtsJtCdNLMXYNo3/cXfrv6dV2dk1su+tpWqXOnb4CT
         /5aEIMlvUEH8Qgrdds91lepw94hjfHsiM0L4L+3Y3PysQ6DR/C+6m/y551WgiCTcoy
         D3ZV7SIZ2/W0A==
Date:   Tue, 9 Aug 2022 21:27:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, pabeni@redhat.com, edumazet@google.com
Subject: Re: [PATCH net 0/8] Netfilter fixes for net
Message-ID: <20220809212714.2cfca6c9@kernel.org>
In-Reply-To: <20220809220532.130240-1-pablo@netfilter.org>
References: <20220809220532.130240-1-pablo@netfilter.org>
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

On Wed, 10 Aug 2022 00:05:24 +0200 Pablo Neira Ayuso wrote:
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git HEAD

That is not the tree you want me to pull from. Mumble, mumble.
