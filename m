Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0038666288
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 19:10:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235478AbjAKSKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:10:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235547AbjAKSKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:10:41 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 323B31C939;
        Wed, 11 Jan 2023 10:10:39 -0800 (PST)
Date:   Wed, 11 Jan 2023 19:10:35 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lvc-project@linuxtesting.org" <lvc-project@linuxtesting.org>
Subject: Re: [PATCH v2] netfilter: ipset: Fix overflow before widen in the
 bitmap_ip_create() function.
Message-ID: <Y777m3reT6s1sCnD@salvia>
References: <Y76NQ7tQVB7kE0dG@corigine.com>
 <20230111115741.3347031-1-Ilia.Gavrilov@infotecs.ru>
 <Y76k9QxybRtf9aG6@corigine.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y76k9QxybRtf9aG6@corigine.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 01:00:53PM +0100, Simon Horman wrote:
> On Wed, Jan 11, 2023 at 11:57:39AM +0000, Gavrilov Ilia wrote:
> > [You don't often get email from ilia.gavrilov@infotecs.ru. Learn why this is important at https://aka.ms/LearnAboutSenderIdentification ]
> > 
> > When first_ip is 0, last_ip is 0xFFFFFFFF, and netmask is 31, the value of
> > an arithmetic expression 2 << (netmask - mask_bits - 1) is subject
> > to overflow due to a failure casting operands to a larger data type
> > before performing the arithmetic.
> > 
> > Note that it's harmless since the value will be checked at the next step.
> > 
> > Found by InfoTeCS on behalf of Linux Verification Center
> > (linuxtesting.org) with SVACE.
> > 
> > Fixes: b9fed748185a ("netfilter: ipset: Check and reject crazy /0 input parameters")
> > Signed-off-by: Ilia.Gavrilov <Ilia.Gavrilov@infotecs.ru>
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>

Applied, thanks
