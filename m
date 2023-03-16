Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DE566BCB55
	for <lists+netdev@lfdr.de>; Thu, 16 Mar 2023 10:47:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229926AbjCPJrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Mar 2023 05:47:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbjCPJrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Mar 2023 05:47:51 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0241AFB8C;
        Thu, 16 Mar 2023 02:47:46 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1pckD2-0005rM-77; Thu, 16 Mar 2023 10:47:44 +0100
Date:   Thu, 16 Mar 2023 10:47:44 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Madhu Koriginja <madhu.koriginja@nxp.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Vani Namala <vani.namala@nxp.com>
Subject: Re: [PATCH net-next] net: netfilter: Keep conntrack reference until
 IPsecv6 policy checks are done
Message-ID: <20230316094744.GH4072@breakpoint.cc>
References: <20230303094221.1501961-1-madhu.koriginja@nxp.com>
 <DB9PR04MB964855E6E7E29C333282170EFCBC9@DB9PR04MB9648.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB9PR04MB964855E6E7E29C333282170EFCBC9@DB9PR04MB9648.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Madhu Koriginja <madhu.koriginja@nxp.com> wrote:

[ Trimming ccs ]

> Hi David,
> May I know the status of this patch, does this patch need any changes or it is ready to go into Linux. Please let me know if it needs any changes.
> This patch is already reviewed by Florian Westphal <fw@strlen.de>.

This patch doesn't apply to net-next or nf-next or nf trees.

net-next maintainers flagged this patch as 'awaiting upstream' which i'd
interpret as 'netfilter maintainers will handle it'. So please make a patch
that will build and apply cleanly to the nf-next tree
(https://git.kernel.org/pub/scm/linux/kernel/git/netfilter/nf-next.git/)
and submit it to netfilter-devel@vger.kernel.org.  You can CC netdev as
well.

Thanks.
