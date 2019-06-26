Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 97AEC569DB
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 14:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727420AbfFZM5J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 08:57:09 -0400
Received: from mail.us.es ([193.147.175.20]:34380 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfFZM5I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 08:57:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D0CDDB570A
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 14:57:06 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BFE48DA4D1
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 14:57:06 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id B580BDA732; Wed, 26 Jun 2019 14:57:06 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6BDEDA4D1;
        Wed, 26 Jun 2019 14:57:04 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 26 Jun 2019 14:57:04 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.197.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 97FE14265A32;
        Wed, 26 Jun 2019 14:57:04 +0200 (CEST)
Date:   Wed, 26 Jun 2019 14:57:03 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu <wenxu@ucloud.cn>
Cc:     fw@strlen.de, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH nf-next v2 2/2] netfilter: nft_meta: Add
 NFT_META_BRI_VLAN support
Message-ID: <20190626125703.5vg2z6xa4ciji6j6@salvia>
References: <1560993460-25569-1-git-send-email-wenxu@ucloud.cn>
 <1560993460-25569-2-git-send-email-wenxu@ucloud.cn>
 <20190626102935.ztxcfb3kysvohzi3@salvia>
 <b037a0a9-4729-41ff-81bb-ca76c0e3fba9@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b037a0a9-4729-41ff-81bb-ca76c0e3fba9@ucloud.cn>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 26, 2019 at 08:42:27PM +0800, wenxu wrote:
> I agree with you, It's a more generic way to set the vlan tag not base on
> 
> any bridge. I will resubmit NFT_META_BRI_VLAN_PROTO and
> 
> NFT_META_VLAN patches

Thank you very much.
