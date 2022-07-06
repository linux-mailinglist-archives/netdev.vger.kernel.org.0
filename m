Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3565569425
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 23:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233754AbiGFVSp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 17:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232890AbiGFVSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 17:18:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F02F1659A
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 14:18:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC631B81E8E
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 21:18:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A887C3411C;
        Wed,  6 Jul 2022 21:18:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657142320;
        bh=mRfca7fLV+uXOxjUgfTt0zkQIpLjqCWzfthlDGKatJ0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bim+E/6R+6qfUrUVx0zbRqUp6CZzLKww7UrTE7DAcJpelCzB/WGLXsN7GfVLjUWdR
         aL0tbMZVGBCAEfVB+xQmfm3uUjqH2CnGihIfZPq3KlYThNOSxUFzsmZ4wBZjxFSIwe
         7yf8pyX5NV7j67PT7cmCXaZ6+swI/6lFGbF8Uu1eOqdMezqF8jRC0AhYTpitotE3cW
         D/mxPdRdyr7XQXhduvvq5eDucLCvew+rAYgN0UA+z88LRaCGmQxuAeVP1wgTa38qyb
         8kjMf6gc8xepfIKItfnWnX8uzJ56FtgDV6f9+H1JxQ6bmc3tyfypHR6IndnPrTguIm
         3K3ZPTisdEncQ==
Date:   Wed, 6 Jul 2022 14:18:39 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] Documentation: add a description for
 net.core.high_order_alloc_disable
Message-ID: <20220706141839.469986f5@kernel.org>
In-Reply-To: <CANn89iKjr=3CVtAiJN_SLUYj5pLta5E1HxR6pEwHcNqwY3BAKA@mail.gmail.com>
References: <20220706085320.17581-1-atenart@kernel.org>
        <CANn89iKjr=3CVtAiJN_SLUYj5pLta5E1HxR6pEwHcNqwY3BAKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Jul 2022 15:24:58 +0200 Eric Dumazet wrote:
> linux-5.14 allowed high-order pages to be stored on the per-cpu lists.
> 
> I ran again the benchmark cited in commit ce27ec60648d to confirm that
> the slowdown we had before 5.14 for
> high number of alloc/frees per second is no more.

Sounds useful to know - Antoine, do you reckon we can include a mention
of this knob being mostly of historical importance?
