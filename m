Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF3755A0F7F
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 13:43:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240777AbiHYLno (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 07:43:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240635AbiHYLnk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 07:43:40 -0400
Received: from syslogsrv (unknown [217.20.186.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C9E581B11;
        Thu, 25 Aug 2022 04:43:40 -0700 (PDT)
Received: from fg200.ow.s ([172.20.254.44] helo=plvision.eu)
        by syslogsrv with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.90_1)
        (envelope-from <maksym.glubokiy@plvision.eu>)
        id 1oRBGg-0008Jo-QC; Thu, 25 Aug 2022 14:43:27 +0300
Date:   Thu, 25 Aug 2022 14:43:20 +0300
From:   Maksym Glubokiy <maksym.glubokiy@plvision.eu>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 1/3] net: prestera: acl: extract matchall logic
 into a separate file
Message-ID: <20220825114320.GA2420591@plvision.eu>
References: <20220823113958.2061401-1-maksym.glubokiy@plvision.eu>
 <20220823113958.2061401-2-maksym.glubokiy@plvision.eu>
 <200cb2f98ca159003ed4deb51163e5f8859d4f8b.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200cb2f98ca159003ed4deb51163e5f8859d4f8b.camel@redhat.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,FSL_HELO_NON_FQDN_1,
        HELO_NO_DOMAIN,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 25, 2022 at 01:11:35PM +0200, Paolo Abeni wrote:
> Hello,
> 
> On Tue, 2022-08-23 at 14:39 +0300, Maksym Glubokiy wrote:
> > From: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > 
> > This commit adds more clarity to handling of TC_CLSMATCHALL_REPLACE and
> > TC_CLSMATCHALL_DESTROY events by calling newly added *_mall_*() handlers
> > instead of directly calling SPAN API.
> > 
> > This also extracts matchall rules management out of SPAN API since SPAN
> > is a hardware module which is used to implement 'matchall egress mirred'
> > action only.
> > 
> > Signed-off-by: Taras Chornyi <tchornyi@marvell.com>
> > Signed-off-by: Serhiy Boiko <serhiy.boiko@plvision.eu>
> > Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> 
> This SoB chain is not clear to me. Did Taras co-developed the patch? In
> that case a Co-developed-by: tag is missing, as the first tag in the
> list. Otherwise why is Taras' SoB there?
There are new files being added with Marvel's copyright and my understanding is
that there must be someone from Marvel on SoB list in such a case.
