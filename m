Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB94691CEB
	for <lists+netdev@lfdr.de>; Fri, 10 Feb 2023 11:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232088AbjBJKgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 05:36:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232075AbjBJKgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 05:36:08 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 569097072A
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 02:35:38 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pQQkh-0005RI-38; Fri, 10 Feb 2023 11:35:35 +0100
Date:   Fri, 10 Feb 2023 11:35:35 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>, dev@openvswitch.org,
        davem@davemloft.net, Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Pravin B Shelar <pshelar@ovn.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>, Florian Westphal <fw@strlen.de>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Ilya Maximets <i.maximets@ovn.org>,
        Aaron Conole <aconole@redhat.com>
Subject: Re: [PATCHv2 net-next 0/5] net: move more duplicate code of ovs and
 tc conntrack into nf_conntrack_ovs
Message-ID: <20230210103535.GD17303@breakpoint.cc>
References: <cover.1675810210.git.lucien.xin@gmail.com>
 <20230209222144.38640609@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209222144.38640609@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jakub Kicinski <kuba@kernel.org> wrote:
> On Tue,  7 Feb 2023 17:52:05 -0500 Xin Long wrote:
> > We've moved some duplicate code into nf_nat_ovs in:
> > 
> >   "net: eliminate the duplicate code in the ct nat functions of ovs and tc"
> > 
> > This patchset addresses more code duplication in the conntrack of ovs
> > and tc then creates nf_conntrack_ovs for them, and four functions will
> > be extracted and moved into it:
> > 
> >   nf_ct_handle_fragments()
> >   nf_ct_skb_network_trim()
> >   nf_ct_helper()
> >   nf_ct_add_helper()
> 
> Hi Pablo, do you prefer to take this or should we?

Looks like Pablo is very busy atm, I have no objections
if this is applied to net-next.

You may add
Acked-by: Florian Westphal <fw@strlen.de>

if you like.
