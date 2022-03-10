Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 420434D4D45
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 16:43:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344011AbiCJPLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 10:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344074AbiCJPLF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 10:11:05 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A30381959FC;
        Thu, 10 Mar 2022 07:05:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id C0F4268AFE; Thu, 10 Mar 2022 16:05:06 +0100 (CET)
Date:   Thu, 10 Mar 2022 16:05:06 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mingbao Sun <sunmingbao@tom.com>
Cc:     Christoph Hellwig <hch@lst.de>, Eric Dumazet <edumazet@google.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tyler.sun@dell.com,
        ping.gan@dell.com, yanxiu.cai@dell.com, libin.zhang@dell.com,
        ao.sun@dell.com
Subject: Re: [PATCH] tcp: export symbol tcp_set_congestion_control
Message-ID: <20220310150506.GA1939@lst.de>
References: <20220310134830.130818-1-sunmingbao@tom.com> <20220310141135.GA750@lst.de> <20220310230300.00004612@tom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310230300.00004612@tom.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 10, 2022 at 11:03:00PM +0800, Mingbao Sun wrote:
> On Thu, 10 Mar 2022 15:11:35 +0100
> Christoph Hellwig <hch@lst.de> wrote:
> 
> > Please submit this together with the actual user(s) in a series.
> > Patches to just export random symbols are a no-go.
> 
> Got it.
> many thanks for informing.
> 
> BTW:
> could you give me the answer to the following questions?
> 1. Against which repo should I prepare and test this series of patches?
>    netdev or nvme?

I think for the initial RFC either is fine, just clearly state which.

> 2. what's the recipients for this series of patches?
>    netdev or nvme or both?

both.
