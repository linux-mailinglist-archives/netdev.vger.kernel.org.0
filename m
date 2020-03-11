Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD609181D08
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 16:54:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730195AbgCKPyy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 11:54:54 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:58981 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730053AbgCKPyy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 11:54:54 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id C40B128008AFC;
        Wed, 11 Mar 2020 16:54:51 +0100 (CET)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 8B36DB1FCF; Wed, 11 Mar 2020 16:54:51 +0100 (CET)
Date:   Wed, 11 Mar 2020 16:54:51 +0100
From:   Lukas Wunner <lukas@wunner.de>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Martin Mares <mj@ucw.cz>,
        Dmitry Safonov <0x7f454c46@gmail.com>,
        Thomas Graf <tgraf@suug.ch>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next 3/3] netfilter: Introduce egress hook
Message-ID: <20200311155451.e3mtgrdvuiujgvs6@wunner.de>
References: <cover.1583927267.git.lukas@wunner.de>
 <14ab7e5af20124a34a50426fd570da7d3b0369ce.1583927267.git.lukas@wunner.de>
 <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a57687ae-2da6-ca2a-1c84-e4332a5e4556@iogearbox.net>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 03:05:16PM +0100, Daniel Borkmann wrote:
> no need to make the fast-path slower for exotic protocols
> which can be solved through other means.

As said the fast-path gets faster, not slower.

> > * Without this commit:
> >    Result: OK: 34240933(c34238375+d2558) usec, 100000000 (60byte,0frags)
> >    2920481pps 1401Mb/sec (1401830880bps) errors: 0
> > 
> > * With this commit:
> >    Result: OK: 33997299(c33994193+d3106) usec, 100000000 (60byte,0frags)
> >    2941410pps 1411Mb/sec (1411876800bps) errors: 0
> 
> So you are suggesting that we've just optimized the stack by adding more
> hooks to it ...?

Since I've provided numbers to disprove your allegation, I think the
onus is now on you to prove that your allegation holds any water.
Please reproduce the measurements and let's go from there.

This isn't much work, I've made it really easy by providing all the
steps necessary in the commit message.

Thanks,

Lukas
