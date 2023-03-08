Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A68036B02FF
	for <lists+netdev@lfdr.de>; Wed,  8 Mar 2023 10:34:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbjCHJee (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Mar 2023 04:34:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229605AbjCHJed (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Mar 2023 04:34:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id EE2FF99BCB;
        Wed,  8 Mar 2023 01:34:31 -0800 (PST)
Date:   Wed, 8 Mar 2023 10:34:27 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netfilter-devel@vger.kernel.org,
        davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com
Subject: Re: [PATCH net 0/3] Netfilter fixes for net
Message-ID: <ZAhWo8lHe7pMxuOw@salvia>
References: <20230307100424.2037-1-pablo@netfilter.org>
 <66e565ba357feb2b4411828c65624986eaefb393.camel@redhat.com>
 <20230307092604.52a3ce34@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20230307092604.52a3ce34@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 07, 2023 at 09:26:04AM -0800, Jakub Kicinski wrote:
> On Tue, 07 Mar 2023 13:57:07 +0100 Paolo Abeni wrote:
> > On Tue, 2023-03-07 at 11:04 +0100, Pablo Neira Ayuso wrote:
> > > The following changes since commit 528125268588a18a2f257002af051b62b14bb282:
> > > 
> > >   Merge branch 'nfp-ipsec-csum' (2023-03-03 08:28:44 +0000)
> > > 
> > > are available in the Git repository at:
> > > 
> > >   git://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf.git HEAD  
> > 
> > It's not clear to me the root cause, but pulling from the above ref.
> > yields nothing. I have to replace 'HEAD' with main to get the expected
> > patches.
> 
> Possibly netfilter folks did not update HEAD to point to main?
> 
> ssh git@gitolite.kernel.org symbolic-ref \
>     pub/scm/linux/kernel/git/netfilter/nf \
>     HEAD refs/heads/main

Fixed, thanks.

I will also review my pull request scripts to check if someone got
unadjusted after the switch to the main branch.
