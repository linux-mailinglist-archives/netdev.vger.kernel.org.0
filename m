Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBA918C078
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 20:35:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725747AbgCSTfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 15:35:41 -0400
Received: from correo.us.es ([193.147.175.20]:34204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgCSTfk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 15:35:40 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 53415E8624
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 20:35:07 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 43DDDFEFAA
        for <netdev@vger.kernel.org>; Thu, 19 Mar 2020 20:35:07 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 397FBDA736; Thu, 19 Mar 2020 20:35:07 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 935E5FEFAF;
        Thu, 19 Mar 2020 20:35:04 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 19 Mar 2020 20:35:04 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 72BD442EFB80;
        Thu, 19 Mar 2020 20:35:04 +0100 (CET)
Date:   Thu, 19 Mar 2020 20:35:34 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Edward Cree <ecree@solarflare.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, wenxu@ucloud.cn
Subject: Re: [PATCH 13/29] netfilter: flowtable: add tunnel match offload
 support
Message-ID: <20200319193534.7s6aw2xn5xzoebjn@salvia>
References: <20200318003956.73573-1-pablo@netfilter.org>
 <20200318003956.73573-14-pablo@netfilter.org>
 <72f9e0d8-56ac-aa01-63d1-9ffdab8c13c4@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <72f9e0d8-56ac-aa01-63d1-9ffdab8c13c4@solarflare.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 07:02:23PM +0000, Edward Cree wrote:
> On 18/03/2020 00:39, Pablo Neira Ayuso wrote:
> > From: wenxu <wenxu@ucloud.cn>
> >
> > This patch support both ipv4 and ipv6 tunnel_id, tunnel_src and
> > tunnel_dst match for flowtable offload
> >
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> <snip>
[...]
> From matching up the Code: line, it appears that %rax is other_dst;
>  the faulting instruction is "mov 0x50(%rax),%rcx".
> IOW other_dst == NULL.

Would this test this patch?

https://patchwork.ozlabs.org/patch/1257949/

Thank you.
