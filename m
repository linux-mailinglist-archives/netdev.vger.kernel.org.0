Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CADC27ADBB
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 14:27:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726613AbgI1M1S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 08:27:18 -0400
Received: from bmailout1.hostsharing.net ([83.223.95.100]:45293 "EHLO
        bmailout1.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726420AbgI1M1S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 08:27:18 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Sep 2020 08:27:17 EDT
Received: from h08.hostsharing.net (h08.hostsharing.net [IPv6:2a01:37:1000::53df:5f1c:0])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (not verified))
        by bmailout1.hostsharing.net (Postfix) with ESMTPS id 3D6F8300069E1;
        Mon, 28 Sep 2020 14:20:36 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id 202F91529B1; Mon, 28 Sep 2020 14:20:36 +0200 (CEST)
Date:   Mon, 28 Sep 2020 14:20:36 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        Thomas Graf <tgraf@suug.ch>, Laura Garcia <nevola@gmail.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH nf-next v3 3/3] netfilter: Introduce egress hook
Message-ID: <20200928122036.GA3017@wunner.de>
References: <cover.1598517739.git.lukas@wunner.de>
 <d2256c451876583bbbf8f0e82a5a43ce35c5cf2f.1598517740.git.lukas@wunner.de>
 <20200919155405.GA28410@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200919155405.GA28410@salvia>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 05:54:05PM +0200, Pablo Neira Ayuso wrote:
> Would you redo these numbers using this ruleset to address Daniel's
> comments regarding performance?
> 
> Moreover, Daniel also suggested dev_direct_xmit() path from AF_PACKET
> allows packets to escape from policy, it seems this also needs to be
> extended to add a hook there too.
> 
> Could you work on this and send a v2?

Sure, will do.

Thanks,

Lukas
