Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28F4611BF82
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 22:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbfLKVzp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 16:55:45 -0500
Received: from correo.us.es ([193.147.175.20]:60142 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726368AbfLKVzp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Dec 2019 16:55:45 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 751DB3066C4
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:55:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 67C6ADA701
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 22:55:42 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 67361DA70D; Wed, 11 Dec 2019 22:55:42 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 61294DA701;
        Wed, 11 Dec 2019 22:55:40 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 11 Dec 2019 22:55:40 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 3D0E34265A5A;
        Wed, 11 Dec 2019 22:55:40 +0100 (CET)
Date:   Wed, 11 Dec 2019 22:55:40 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     network dev <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH nf-next 5/7] netfilter: nft_tunnel: also dump
 OPTS_ERSPAN/VXLAN
Message-ID: <20191211215540.l3ahzuocsuj5dzux@salvia>
References: <cover.1575779993.git.lucien.xin@gmail.com>
 <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <396287a2b2d8797dae70c5740084c4d0cb225a08.1575779993.git.lucien.xin@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Dec 08, 2019 at 12:41:35PM +0800, Xin Long wrote:
> This patch is to add the nest attr OPTS_ERSPAN/VXLAN when dumping
> KEY_OPTS, and it would be helpful when parsing in userpace. Also,
> this is needed for supporting multiple geneve opts in the future
> patches.
> 
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
