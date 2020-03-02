Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 536E61763CC
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 20:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgCBTYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 14:24:41 -0500
Received: from correo.us.es ([193.147.175.20]:42998 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727126AbgCBTYl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 14:24:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D6C4E303D06
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 20:24:26 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C2366DA3AB
        for <netdev@vger.kernel.org>; Mon,  2 Mar 2020 20:24:26 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B2D14DA39F; Mon,  2 Mar 2020 20:24:26 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CF602DA38F;
        Mon,  2 Mar 2020 20:24:24 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 02 Mar 2020 20:24:24 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 93EAD426CCB9;
        Mon,  2 Mar 2020 20:24:24 +0100 (CET)
Date:   Mon, 2 Mar 2020 20:24:37 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, saeedm@mellanox.com,
        leon@kernel.org, michael.chan@broadcom.com, vishal@chelsio.com,
        jeffrey.t.kirsher@intel.com, idosch@mellanox.com,
        aelior@marvell.com, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, mlxsw@mellanox.com,
        netfilter-devel@vger.kernel.org
Subject: Re: [patch net-next v2 01/12] flow_offload: Introduce offload of HW
 stats type
Message-ID: <20200302192437.wtge3ze775thigzp@salvia>
References: <20200228172505.14386-1-jiri@resnulli.us>
 <20200228172505.14386-2-jiri@resnulli.us>
 <20200229192947.oaclokcpn4fjbhzr@salvia>
 <20200301084443.GQ26061@nanopsycho>
 <20200302132016.trhysqfkojgx2snt@salvia>
 <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1da092c0-3018-7107-78d3-4496098825a3@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 02, 2020 at 04:29:32PM +0000, Edward Cree wrote:
> On 02/03/2020 13:20, Pablo Neira Ayuso wrote:
> > 2) explicit counter action, in this case the user specifies explicitly
> >    that it needs a counter in a given position of the rule. This
> >    counter might come before or after the actual action.
>
> But the existing API can already do this, with a gact pipe.  Plus, Jiri's
>  new API will allow specifying a counter on any action (rather than only,
>  implicitly, those which have .stats_update()) should that prove to be
>  necessary.
> 
> I really think the 'explicit counter action' is a solution in search of a
>  problem, let's not add random orthogonality violations.  (Equally if the
>  counter action had been there first, I'd be against adding counters to
>  the other actions.)

It looks to me that you want to restrict the API to tc for no good
_technical_ reason.
