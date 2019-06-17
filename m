Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB8D14841E
	for <lists+netdev@lfdr.de>; Mon, 17 Jun 2019 15:35:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727974AbfFQNeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 09:34:46 -0400
Received: from mail.us.es ([193.147.175.20]:47042 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727973AbfFQNep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Jun 2019 09:34:45 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 5679CB6C92
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:34:43 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 435ADDA70B
        for <netdev@vger.kernel.org>; Mon, 17 Jun 2019 15:34:43 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 2D2A1DA703; Mon, 17 Jun 2019 15:34:43 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 03CAADA701;
        Mon, 17 Jun 2019 15:34:41 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 17 Jun 2019 15:34:41 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 8F7574265A2F;
        Mon, 17 Jun 2019 15:34:40 +0200 (CEST)
Date:   Mon, 17 Jun 2019 15:34:40 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian Brauner <christian@brauner.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        bridge@lists.linux-foundation.org, tyhicks@canonical.com,
        kadlec@blackhole.kfki.hu, fw@strlen.de, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, linux-kernel@vger.kernel.org,
        richardrose@google.com, vapier@chromium.org, bhthompson@google.com,
        smbarber@chromium.org, joelhockey@chromium.org,
        ueberall@themenzentrisch.de
Subject: Re: [PATCH net-next v2 0/2] br_netfilter: enable in non-initial netns
Message-ID: <20190617133440.mhnhtcwwraf53bl4@salvia>
References: <20190610212606.29743-1-christian@brauner.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190610212606.29743-1-christian@brauner.io>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 11:26:04PM +0200, Christian Brauner wrote:
[...]
> Over time I have seen multiple reports by users who want to run applications
> (Kubernetes e.g. via [1]) that require the br_netfilter module in
> non-initial network namespaces. There are *a lot* of issues for this. A
> shortlist including ChromeOS and other big users is found below under
> [2]! Even non-devs already tried to get more traction on this by
> commenting on the patchset (cf. [3]).
> 
> Currently, the /proc/sys/net/bridge folder is only created in the
> initial network namespace. This patch series ensures that the
> /proc/sys/net/bridge folder is available in each network namespace if
> the module is loaded and disappears from all network namespaces when the
> module is unloaded.

Series applied, thanks Christian.
