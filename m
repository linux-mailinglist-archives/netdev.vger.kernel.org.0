Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8843ADB3C8
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:46:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440795AbfJQRqJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:46:09 -0400
Received: from correo.us.es ([193.147.175.20]:58098 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440778AbfJQRqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Oct 2019 13:46:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 8F21BA1A33A
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 19:46:03 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81846DA8E8
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 19:46:03 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 6D358B7FFE; Thu, 17 Oct 2019 19:46:03 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 81F7A202B7;
        Thu, 17 Oct 2019 19:46:01 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 19:46:01 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 4E87242EF4E2;
        Thu, 17 Oct 2019 19:46:01 +0200 (CEST)
Date:   Thu, 17 Oct 2019 19:46:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jiri@resnulli.us, saeedm@mellanox.com,
        vishal@chelsio.com, vladbu@mellanox.com, ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at byte
 level
Message-ID: <20191017174603.m3riooywbgy2r5hr@salvia>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-4-pablo@netfilter.org>
 <20191016163651.230b60e1@cakuba.netronome.com>
 <20191017161157.rr4lrolsjbnmk3ke@salvia>
 <20191017103059.3b7ff828@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017103059.3b7ff828@cakuba.netronome.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On Thu, Oct 17, 2019 at 10:30:59AM -0700, Jakub Kicinski wrote:
[...]
> Ed requested this was a opt-in/helper the driver can call if they
> choose to. Please do that. Please provide selftests.

I will follow up to support for mangling two ports with one single u32
word, no problem.

Making this opt-in will just leave things as bad as they are right
now, with drivers that are very much hard to read.
