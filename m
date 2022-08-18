Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFE4C598C42
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 20:59:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344871AbiHRS6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 14:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231651AbiHRS6V (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 14:58:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 438B9275CD;
        Thu, 18 Aug 2022 11:58:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E49EEB8235B;
        Thu, 18 Aug 2022 18:58:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E96C433D7;
        Thu, 18 Aug 2022 18:58:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660849096;
        bh=ouppfBFaujjzUdExtVMjtCUZgagFAFokFfGF8rO54vI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QVo7iHOzM6VR8VI2pixt+xUoG0J6hALP8CiYFWzfmsnW9Rs+gofy3Sze7FmXQLca9
         a/CwB7r/1sN4Wntiv37ppDK+Ih9oH7asFA7lR7r8qsqKB4j8ic4WQlZGpD7tncJXS7
         tOAnrr4qfWw1t8lCqJ7OABl7iXbmNL7rjaSiESLprVd/IfTuZN1AnutCCpRt41Avno
         5Ojh19hAeZtWUX80yKYg2CWUJhuZWMlE0gW7theEZBpX4JXJ98tiFC8/SxNLU7M8zt
         PRhnSyJ5o7ZC8WGz6QrREa6jZcBbQmQQqjgTtNyNlPDvS+Rejf31VVWotzlMCT96Nx
         Ih9OgreeQ7IiQ==
Date:   Thu, 18 Aug 2022 11:58:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Camelia Groza <camelia.groza@nxp.com>,
        open list <linux-kernel@vger.kernel.org>,
        Madalin Bucur <madalin.bucur@nxp.com>,
        linuxppc-dev@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Li Yang <leoyang.li@nxp.com>, Rob Herring <robh+dt@kernel.org>,
        devicetree@vger.kernel.org
Subject: Re: [RESEND PATCH net-next v4 00/25] net: dpaa: Cleanups in
 preparation for phylink conversion
Message-ID: <20220818115815.72809e33@kernel.org>
In-Reply-To: <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
        <20220818112054.29cd77fb@kernel.org>
        <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
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

On Thu, 18 Aug 2022 14:37:23 -0400 Sean Anderson wrote:
> On 8/18/22 2:20 PM, Jakub Kicinski wrote:
> > On Thu, 18 Aug 2022 12:16:24 -0400 Sean Anderson wrote:  
> >> This series contains several cleanup patches for dpaa/fman. While they
> >> are intended to prepare for a phylink conversion, they stand on their
> >> own. This series was originally submitted as part of [1].  
> > 
> > Still over the limit of patches in a patch series, and looks pretty
> > easy to chunk up. We review and apply patches in netdev in 1-3 days,
> > it really is more efficient to post smaller series.   
> 
> Last time I offered to arbitrarily chunk things [1], but I did not receive
> a response for 3 weeks.

I sent you the link to the rules. Admittedly not the most polite and
clear feedback to put it mildly but that was the reason.

> > And with the other series you sent to the list we have nearly 50
> > patches from you queued for review. I don't think this is reasonable,
> > people reviewing this code are all volunteers trying to get their
> > work done as well :(  
> 
> These patches have been sent to the list in one form or another since
> I first sent out an RFC for DPAA conversion back in June [2]. I have not
> substantially modified any of them (although I did add a few more
> since v2). It's not like I came up with these just now; I have been
> seeking feedback on these series for 2-3 months so far. The only
> reviews I have gotten were from Camelia Groza, who has provided some
> helpful feedback.

Ack, no question. I'm trying to tell you got to actually get stuff in.
It's the first week after the merge window and people are dumping code
the had written over the dead time on the list, while some reviewers
and maintainers are still on their summer vacation. So being
considerate is even more important than normally.
