Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9CF6D9F20
	for <lists+netdev@lfdr.de>; Thu,  6 Apr 2023 19:45:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbjDFRo7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Apr 2023 13:44:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240009AbjDFRo5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Apr 2023 13:44:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8658DE;
        Thu,  6 Apr 2023 10:44:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8534060ECD;
        Thu,  6 Apr 2023 17:44:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D6AC433D2;
        Thu,  6 Apr 2023 17:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680803095;
        bh=aNrAPQwpmtdG/zMW/r6ym9rY9Cxi3FIvvKxFl3ubfQo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UY6dvpwSBR3zKxgef3Y7P3aRpADw6Swi1Q+HdI9htshxM55ZtMuul7mxDtVcour83
         4By4oAFJYBZ6eiEiY/7rHSFfwKrjaILBF9RZqpXBi7ctNB0wV4ztUETQ5LVUn8QXnN
         JoZehPzGz9qxq+Y1YhJYvHLpcSetrm2tVtdooFhKkl+7ZGsDt7sf2h85zk4vI2YHxd
         Mu4k1dPygywMNto9I+YzFGp307eqFZWSHlIoNLIPRH/i9LzLfzJHcPVs079FfOTjMR
         V0ap7DVtXlJbiFMG4oihl29jPY0Z7PH4RpB4NF94MMwmobpGYNvDQW0PLMEcvWxqHA
         kl5dpHo10qb5A==
Date:   Thu, 6 Apr 2023 10:44:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <horms@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Tom Rix <trix@redhat.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH net-next 2/3] ksz884x: remove unused #defines
Message-ID: <20230406104453.3bc86676@kernel.org>
In-Reply-To: <ZC7vgRFmqAjGQyss@kernel.org>
References: <20230405-ksz884x-unused-code-v1-0-a3349811d5ef@kernel.org>
        <20230405-ksz884x-unused-code-v1-2-a3349811d5ef@kernel.org>
        <454a61709e442f717fbde4b0ebb8b4c3fdfb515e.camel@redhat.com>
        <20230406090017.0fc0ae34@kernel.org>
        <ZC7vgRFmqAjGQyss@kernel.org>
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

On Thu, 6 Apr 2023 18:12:49 +0200 Simon Horman wrote:
> I guess that it two down-votes for removing the #defines.
> 
> Would it be acceptable if I reworked the series to only remove
> the dead code - which would leave only subset of patch 3/3 ?

No preference in either direction on my side :(
