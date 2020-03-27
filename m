Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DDC64195C8B
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgC0RXG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:23:06 -0400
Received: from correo.us.es ([193.147.175.20]:37552 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727754AbgC0RXF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:23:05 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D07D0127C60
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 18:23:04 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C222DDA3AA
        for <netdev@vger.kernel.org>; Fri, 27 Mar 2020 18:23:04 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B6C33DA3A1; Fri, 27 Mar 2020 18:23:04 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id ECE3CDA38D;
        Fri, 27 Mar 2020 18:23:02 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 27 Mar 2020 18:23:02 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id CAD7A42EE393;
        Fri, 27 Mar 2020 18:23:02 +0100 (CET)
Date:   Fri, 27 Mar 2020 18:23:02 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Paul Blakey <paulb@mellanox.com>
Cc:     Oz Shlomo <ozsh@mellanox.com>, Majd Dibbiny <majd@mellanox.com>,
        Roi Dayan <roid@mellanox.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@mellanox.com>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/3] netfilter: flowtable: Use work entry per
 offload command
Message-ID: <20200327172302.pryc2xxykunqewu2@salvia>
References: <1585300351-15741-1-git-send-email-paulb@mellanox.com>
 <1585300351-15741-3-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1585300351-15741-3-git-send-email-paulb@mellanox.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 12:12:30PM +0300, Paul Blakey wrote:
> To allow offload commands to execute in parallel, create workqueue
> for flow table offload, and use a work entry per offload command.

Also applied to nf-next, thanks.
