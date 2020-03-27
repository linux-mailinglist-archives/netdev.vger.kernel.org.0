Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD0E8195B00
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 17:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727731AbgC0QXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 12:23:50 -0400
Received: from correo.us.es ([193.147.175.20]:37748 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727652AbgC0QXt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 12:23:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 19FFAE8E90
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 17:23:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F0B37DA3A1
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 17:23:47 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id DA2E3DA72F; Fri, 27 Mar 2020 17:23:47 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 076DFDA736;
        Fri, 27 Mar 2020 17:23:46 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Mar 2020 17:23:46 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E00F742EE38E;
        Fri, 27 Mar 2020 17:23:45 +0100 (CET)
Date:   Fri, 27 Mar 2020 17:23:45 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     David Miller <davem@davemloft.net>
Cc:     wenxu@ucloud.cn, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2] netfilter: Fix incorrect tc_setup_type type
 for flowtable offload
Message-ID: <20200327162345.jcas4dez5ximalvn@salvia>
References: <1585006465-27664-1-git-send-email-wenxu@ucloud.cn>
 <20200326.200409.835123184765124238.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326.200409.835123184765124238.davem@davemloft.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 26, 2020 at 08:04:09PM -0700, David Miller wrote:
> From: wenxu@ucloud.cn
> Date: Tue, 24 Mar 2020 07:34:25 +0800
> 
> > From: wenxu <wenxu@ucloud.cn>
> > 
> > Flowtable offload setup flow_offlod_block in TC_SETP_FT. The indr block
> > offload of flowtable also should setup in TC_SETUP_FT.
> > But flow_indr_block_call always sets the tc_set_up_type as TC_SETUP_BLOCK.
> > So function flow_indr_block_call should expose a parameters to set
> > the tc_setup_type for each offload subsystem.
> > 
> > Fixes: b5140a36da78 ("netfilter: flowtable: add indr block setup support")
> > Signed-off-by: wenxu <wenxu@ucloud.cn>
> > ---
> > v2: modify the comments
> 
> Do the netfilter folks want to take this or should I apply it directly?

We'll take care of this patch, thank you.
