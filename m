Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2781D19F5D2
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 14:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgDFMbW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 08:31:22 -0400
Received: from correo.us.es ([193.147.175.20]:52582 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbgDFMbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 08:31:22 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 48649F2DEB
        for <netdev@vger.kernel.org>; Mon,  6 Apr 2020 14:31:20 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 38795100A5A
        for <netdev@vger.kernel.org>; Mon,  6 Apr 2020 14:31:20 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36747100A70; Mon,  6 Apr 2020 14:31:20 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E548100A47;
        Mon,  6 Apr 2020 14:31:18 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 06 Apr 2020 14:31:18 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id D75D242EE38E;
        Mon,  6 Apr 2020 14:31:17 +0200 (CEST)
Date:   Mon, 6 Apr 2020 14:31:17 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Amol Grover <frextrite@gmail.com>
Cc:     Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jeremy Sowden <jeremy@azazel.net>,
        Florent Fourcot <florent.fourcot@wifirst.fr>,
        Kate Stewart <kstewart@linuxfoundation.org>,
        Johannes Berg <johannes.berg@intel.com>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Joel Fernandes <joel@joelfernandes.org>,
        Madhuparna Bhowmik <madhuparnabhowmik10@gmail.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH] netfilter: ipset: Pass lockdep expression to RCU lists
Message-ID: <20200406123117.22e22uurcvqyc4qs@salvia>
References: <20200216172653.19772-1-frextrite@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200216172653.19772-1-frextrite@gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Applied.
