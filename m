Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BE7D569B77
	for <lists+netdev@lfdr.de>; Thu,  7 Jul 2022 09:23:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbiGGHXI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 03:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230334AbiGGHXH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 03:23:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0F8F2FFEB
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 00:23:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 974F0B81F52
        for <netdev@vger.kernel.org>; Thu,  7 Jul 2022 07:23:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3267C341CA;
        Thu,  7 Jul 2022 07:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657178584;
        bh=XESb5mCUTtVQi0gs76izCLT0yfetDelIM1FU+iA8ctk=;
        h=In-Reply-To:References:Subject:Cc:From:To:Date:From;
        b=mrIb6kphTykUHFHlvemVI65dYpT/ktpbniHX5r6SDXpixtldblJUsPcHQGpRB6+Ft
         GA1OmS/b3+cJa8iXXFoHoelzbpt5milE1c/Sk4vXSTv7h3+umpAminW8dLlhdmGyal
         aPOqyxvR9Gv4CGxXx9rctSaPTnOMdAo07VqlT8NkhhrGnyi5UgULQgfgt479pkjMQJ
         9c97fX4doH6iJZUugxPSgwUba/1WqU0QPxWbc3ELJuDvh3T2ov7OoRemCr8GL+iU+u
         N5N/Gs2zlJkmjJpMT+3i/Rb15DfKFMeTBSOFK3CM1+kcKvx9QN0xtlKLclYLasKrcE
         NHOHx0xgQ12Tg==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20220706141839.469986f5@kernel.org>
References: <20220706085320.17581-1-atenart@kernel.org> <CANn89iKjr=3CVtAiJN_SLUYj5pLta5E1HxR6pEwHcNqwY3BAKA@mail.gmail.com> <20220706141839.469986f5@kernel.org>
Subject: Re: [PATCH net-next] Documentation: add a description for net.core.high_order_alloc_disable
Cc:     Eric Dumazet <edumazet@google.com>,
        David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        netdev <netdev@vger.kernel.org>
From:   Antoine Tenart <atenart@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Message-ID: <165717858103.4591.2264661991917194467@kwain>
Date:   Thu, 07 Jul 2022 09:23:01 +0200
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2022-07-06 23:18:39)
> On Wed, 6 Jul 2022 15:24:58 +0200 Eric Dumazet wrote:
> > linux-5.14 allowed high-order pages to be stored on the per-cpu lists.
> >=20
> > I ran again the benchmark cited in commit ce27ec60648d to confirm that
> > the slowdown we had before 5.14 for
> > high number of alloc/frees per second is no more.
>=20
> Sounds useful to know - Antoine, do you reckon we can include a mention
> of this knob being mostly of historical importance?

Sure, I'll send a v2 with that.

Thanks!
Antoine
