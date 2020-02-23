Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70724169A49
	for <lists+netdev@lfdr.de>; Sun, 23 Feb 2020 22:39:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727064AbgBWVjb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Feb 2020 16:39:31 -0500
Received: from correo.us.es ([193.147.175.20]:51212 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726302AbgBWVjb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Feb 2020 16:39:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A281FEBAC7
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 22:39:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 94597DA8E6
        for <netdev@vger.kernel.org>; Sun, 23 Feb 2020 22:39:22 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8962CDA736; Sun, 23 Feb 2020 22:39:22 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ABC69DA801;
        Sun, 23 Feb 2020 22:39:20 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Sun, 23 Feb 2020 22:39:20 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8417142EF4E0;
        Sun, 23 Feb 2020 22:39:20 +0100 (CET)
Date:   Sun, 23 Feb 2020 22:39:25 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: flowtable: Use nf_flow_offload_tuple
 for stats as well
Message-ID: <20200223213925.kfcrgdorlkh6uzoj@salvia>
References: <1580400918-9632-1-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1580400918-9632-1-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 30, 2020 at 06:15:18PM +0200, Paul Blakey wrote:
> This patch doesn't change any functionality.

Applied, thanks.
