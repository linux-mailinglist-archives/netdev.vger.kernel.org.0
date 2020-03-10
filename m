Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CCC517F64B
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 12:30:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726258AbgCJLal (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 07:30:41 -0400
Received: from correo.us.es ([193.147.175.20]:38182 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726197AbgCJLal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 07:30:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F182E179893
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 12:30:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E4B4FFF132
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 12:30:18 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id D9B81FF12B; Tue, 10 Mar 2020 12:30:18 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D79FDFF126;
        Tue, 10 Mar 2020 12:30:16 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 10 Mar 2020 12:30:16 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id BA076426CCB9;
        Tue, 10 Mar 2020 12:30:16 +0100 (CET)
Date:   Tue, 10 Mar 2020 12:30:36 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ecree@solarflare.com, mlxsw@mellanox.com
Subject: Re: [patch net-next v2] flow_offload: use flow_action_for_each in
 flow_action_mixed_hw_stats_types_check()
Message-ID: <20200310113036.5yn5nmg76ylxch4p@salvia>
References: <20200310101157.5567-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200310101157.5567-1-jiri@resnulli.us>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:11:57AM +0100, Jiri Pirko wrote:
> Instead of manually iterating over entries, use flow_action_for_each
> helper. Move the helper and wrap it to fit to 80 cols on the way.
> 
> Signed-off-by: Jiri Pirko <jiri@resnulli.us>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>
