Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 415EB117123
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 17:06:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfLIQGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 11:06:31 -0500
Received: from correo.us.es ([193.147.175.20]:53572 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726230AbfLIQGa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 11:06:30 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 2929311772E
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1BAA8DA702
        for <netdev@vger.kernel.org>; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 11342DA707; Mon,  9 Dec 2019 17:06:28 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1A21FDA702;
        Mon,  9 Dec 2019 17:06:26 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 09 Dec 2019 17:06:26 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E71934265A5A;
        Mon,  9 Dec 2019 17:06:25 +0100 (CET)
Date:   Mon, 9 Dec 2019 17:06:26 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netdev@vger.kernel.org
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        geert@linux-m68k.org, jiri@mellanox.com
Subject: Re: [PATCH net] net: flow_dissector: fix tcp flags dissection on
 big-endian
Message-ID: <20191209160626.npmosk2ehmiuthya@salvia>
References: <20191209155530.3050-1-pablo@netfilter.org>
 <20191209160430.owxiyydj57mnjw2l@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209160430.owxiyydj57mnjw2l@salvia>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 09, 2019 at 05:04:30PM +0100, Pablo Neira Ayuso wrote:
> Hi,
> 
> Please, withdraw this patch.
>
> I can fix this by using TCPHDR_* definitions.

Oh actually, that's only true for my nf_flow_table_offload code.

But not for the flow dissector code, which is using tcp_flag_word().

I will revamp and send v2.
