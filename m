Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD006F4A0
	for <lists+netdev@lfdr.de>; Sun, 21 Jul 2019 20:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727290AbfGUS0Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 21 Jul 2019 14:26:16 -0400
Received: from mail.us.es ([193.147.175.20]:41530 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726830AbfGUS0Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 21 Jul 2019 14:26:16 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D58D2C3304
        for <netdev@vger.kernel.org>; Sun, 21 Jul 2019 20:26:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C7355909AF
        for <netdev@vger.kernel.org>; Sun, 21 Jul 2019 20:26:12 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B9E6C6DA95; Sun, 21 Jul 2019 20:26:12 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AEB68DA4D1;
        Sun, 21 Jul 2019 20:26:10 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 21 Jul 2019 20:26:10 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.214.120])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 70D0E4265A32;
        Sun, 21 Jul 2019 20:26:10 +0200 (CEST)
Date:   Sun, 21 Jul 2019 20:26:08 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jeremy Sowden <jeremy@azazel.net>
Cc:     Netdev <netdev@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
Subject: Re: [PATCH net] kbuild: add net/netfilter/nf_tables_offload.h to
 header-test blacklist.
Message-ID: <20190721182608.mmn2p6jyazqmmvix@salvia>
References: <20190719100743.2ea14575@cakuba.netronome.com>
 <20190721113105.19301-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190721113105.19301-1-jeremy@azazel.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 21, 2019 at 12:31:05PM +0100, Jeremy Sowden wrote:
> net/netfilter/nf_tables_offload.h includes net/netfilter/nf_tables.h
> which is itself on the blacklist.
> 
> Reported-by: Jakub Kicinski <jakub.kicinski@netronome.com>
> Signed-off-by: Jeremy Sowden <jeremy@azazel.net>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

Thanks, I think it would be good later on to review all of the
netfilter headers and make them compile via this new
CONFIG_HEADER_TEST Kconfig knob.
