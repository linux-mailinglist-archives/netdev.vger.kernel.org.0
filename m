Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A3AA6A6F59
	for <lists+netdev@lfdr.de>; Wed,  1 Mar 2023 16:25:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230000AbjCAPZU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Mar 2023 10:25:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230005AbjCAPZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Mar 2023 10:25:16 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 997A715884;
        Wed,  1 Mar 2023 07:25:11 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pXOKG-0002p6-CL; Wed, 01 Mar 2023 16:25:04 +0100
Date:   Wed, 1 Mar 2023 16:25:04 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Madhu Koriginja <madhu.koriginja@nxp.com>
Cc:     Florian Westphal <fw@strlen.de>,
        "gerrit@erg.abdn.ac.uk" <gerrit@erg.abdn.ac.uk>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "edumazet@google.com" <edumazet@google.com>,
        "dccp@vger.kernel.org" <dccp@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Vani Namala <vani.namala@nxp.com>
Subject: Re: [EXT] Re: [PATCH] [NETFILTER]: Keep conntrack reference until
 IPsecv6 policy checks are done
Message-ID: <20230301152504.GA9864@breakpoint.cc>
References: <20230301145534.421569-1-madhu.koriginja@nxp.com>
 <20230301150747.GB4691@breakpoint.cc>
 <DB9PR04MB9648F84755C9894D720F996FFCAD9@DB9PR04MB9648.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB9648F84755C9894D720F996FFCAD9@DB9PR04MB9648.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Madhu Koriginja <madhu.koriginja@nxp.com> wrote:
> Got it, it's typo mistake. I will update the patch.

Forgot to mention, please use 'net: ' or perhaps 'net: netfilter: ' as
prefix, not [NETFILTER].

Thanks.
