Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105A862D8AB
	for <lists+netdev@lfdr.de>; Thu, 17 Nov 2022 12:00:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239477AbiKQLAH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 06:00:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbiKQK7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 05:59:36 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id C99C660363
        for <netdev@vger.kernel.org>; Thu, 17 Nov 2022 02:57:04 -0800 (PST)
Date:   Thu, 17 Nov 2022 11:57:00 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, kuba@kernel.org,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCH net-next 5/5] net: move the nat function to nf_nat_core
 for ovs and tc
Message-ID: <Y3YTfGZ9ZkXWUSOE@salvia>
References: <cover.1668527318.git.lucien.xin@gmail.com>
 <488fbfa082eb8a0ab81622a7c13c26b6fd8a0602.1668527318.git.lucien.xin@gmail.com>
 <Y3VcEiOlB5OG0XFS@salvia>
 <CADvbK_en1btAkbvOBm7+LuN7_G_mkU0==HD-GSTjAjhJPykPdQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CADvbK_en1btAkbvOBm7+LuN7_G_mkU0==HD-GSTjAjhJPykPdQ@mail.gmail.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 16, 2022 at 07:51:40PM -0500, Xin Long wrote:
> On Wed, Nov 16, 2022 at 4:54 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Tue, Nov 15, 2022 at 10:50:57AM -0500, Xin Long wrote:
[...]
> > I'd suggest you move this code to nf_nat_ovs.c or such so we remember
> > these symbols are used by act_ct.c and ovs.
>
> Good idea, do you think we should also create nf_conntrack_ovs.c
> to have nf_ct_helper() and nf_ct_add_helper()?
> which were added by:
> 
> https://lore.kernel.org/netdev/20221101150031.a6rtrgzwfd7kzknn@t14s.localdomain/T/

If it is used by ovs infra, I would suggest to move there too.

Thanks.
