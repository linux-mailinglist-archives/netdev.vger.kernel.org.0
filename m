Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BA90598C82
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 21:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240483AbiHRT2K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 15:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344244AbiHRT2I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 15:28:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69244CAC54;
        Thu, 18 Aug 2022 12:28:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29C78B82403;
        Thu, 18 Aug 2022 19:28:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0ADC433D7;
        Thu, 18 Aug 2022 19:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660850884;
        bh=VYr1cXw3LttyNg8S5eNSk0+UacR8DxuCWqi7NjshbRU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FM9byKd6qcfcDmD0eBSzpaDPPzMZAEUB7JouthTYlFxb/LXF6qvLMk+6ScwYtoAIj
         eJv5DzbLQLA7DejgW/cSZYCJ3qaQVC8ABS2l6RrWf43xLYUJbfb1pzakRb9TsZ6fVp
         nsmt51ZFDx6HVXas4b+7sCEw+o1WLWqjO0WuszBrDguRd4w+7P+0Hvdk/yF8r/yOFv
         Hst78VM1/T/u9PPBlU+o3qDx2N8zSLJ4hdEs1prvWrh+8uTN/hde/HP3ZcPflD4GJ4
         MjRN6iFOLp0guhclFzd2JcoCfKHjHI0gTInXHVxqy2jugTil3/gRglspGNGMZpOX55
         khUap8XBuMrtA==
Date:   Thu, 18 Aug 2022 12:28:03 -0700
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
Message-ID: <20220818122803.21f7294d@kernel.org>
In-Reply-To: <583c7997-fb01-63ad-775e-b6a8a8e93566@seco.com>
References: <20220818161649.2058728-1-sean.anderson@seco.com>
        <20220818112054.29cd77fb@kernel.org>
        <f085609c-24c9-a9fb-e714-18ba7f3ef48a@seco.com>
        <20220818115815.72809e33@kernel.org>
        <583c7997-fb01-63ad-775e-b6a8a8e93566@seco.com>
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

On Thu, 18 Aug 2022 15:14:04 -0400 Sean Anderson wrote:
> > Ack, no question. I'm trying to tell you got to actually get stuff in.
> > It's the first week after the merge window and people are dumping code
> > the had written over the dead time on the list, while some reviewers
> > and maintainers are still on their summer vacation. So being
> > considerate is even more important than normally.  
> 
> OK, so perhaps a nice place to split the series is after patch 11. If
> you would like to review/apply a set of <15 patches, that is the place
> to break things. I can of course resend again with just those, if that's
> what I need to do to get these applied.

Mm, okay, let's give folks the customary 24h to object, otherwise I'll
pull in the first 11 tomorrow.

> That said, I specifically broke this series up into many small patches
> to make it easier to review. Each patch does exactly one thing. Had I
> known about these limits based on patch size, I would have just squashed
> everything into 15 patches. I think an arbitrary limit such as this has
> a perverse incentive.

Practically speaking I think it works out fairly nicely, IDK.
There's trade offs like always. Takes a bit of getting used to.
