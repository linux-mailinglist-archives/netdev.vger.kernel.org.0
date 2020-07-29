Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F013F23265E
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 22:44:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726847AbgG2UoC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 16:44:02 -0400
Received: from correo.us.es ([193.147.175.20]:55768 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgG2UoB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 16:44:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id F337BFB36B
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:44:00 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E0AA0DA84F
        for <netdev@vger.kernel.org>; Wed, 29 Jul 2020 22:44:00 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CCAFADA7B6; Wed, 29 Jul 2020 22:44:00 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id AFB7DDA78A;
        Wed, 29 Jul 2020 22:43:58 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 29 Jul 2020 22:43:58 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 742A34265A2F;
        Wed, 29 Jul 2020 22:43:58 +0200 (CEST)
Date:   Wed, 29 Jul 2020 22:43:58 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     kadlec@netfilter.org, fw@strlen.de, davem@davemloft.net,
        kuba@kernel.org, paul@paul-moore.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org,
        linux-decnet-user@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-security-module@vger.kernel.org
Subject: Re: [PATCH v2] netfilter: Replace HTTP links with HTTPS ones
Message-ID: <20200729204358.GA11388@salvia>
References: <20200724112856.GA26061@salvia>
 <20200725170225.4505-1-grandmaster@al2klimov.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200725170225.4505-1-grandmaster@al2klimov.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 25, 2020 at 07:02:25PM +0200, Alexander A. Klimov wrote:
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.

Applied.
