Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EA2752E664
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 09:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346573AbiETHkF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 03:40:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346571AbiETHkC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 03:40:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 162C814B67B;
        Fri, 20 May 2022 00:39:59 -0700 (PDT)
Date:   Fri, 20 May 2022 09:39:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
Message-ID: <YodFzAu0gSSMdJIz@salvia>
References: <20220520145957.1ec50e44@canb.auug.org.au>
 <20220519222044.1106dbd7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220519222044.1106dbd7@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 19, 2022 at 10:20:44PM -0700, Jakub Kicinski wrote:
> On Fri, 20 May 2022 14:59:57 +1000 Stephen Rothwell wrote:
> > Hi all,
> > 
> > After merging the net-next tree, today's linux-next build (x86_64
> > allmodconfig) failed like this:
> 
> FWIW just merged the fix, if you pull again you'll get this and a fix
> for the netfilter warning about ctnetlink_dump_one_entry().

Thanks.

Felix forgot to include the update for the mtk driver in his batch it
seems.
