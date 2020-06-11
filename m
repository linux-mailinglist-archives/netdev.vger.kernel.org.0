Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6311F64E8
	for <lists+netdev@lfdr.de>; Thu, 11 Jun 2020 11:47:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgFKJrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jun 2020 05:47:06 -0400
Received: from correo.us.es ([193.147.175.20]:54904 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726684AbgFKJrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Jun 2020 05:47:06 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 51E65B6322
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:47:05 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 413C9DA8E8
        for <netdev@vger.kernel.org>; Thu, 11 Jun 2020 11:47:05 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 36D79DA73F; Thu, 11 Jun 2020 11:47:05 +0200 (CEST)
X-Spam-Checker-Version: SpamAssassin 3.4.1 (2015-04-28) on antivirus1-rhel7.int
X-Spam-Level: 
X-Spam-Status: No, score=-108.2 required=7.5 tests=ALL_TRUSTED,BAYES_50,
        SMTPAUTH_US2,URIBL_BLOCKED,USER_IN_WHITELIST autolearn=disabled version=3.4.1
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 20B02DA8F4;
        Thu, 11 Jun 2020 11:47:03 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 11 Jun 2020 11:47:03 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 003B941E4801;
        Thu, 11 Jun 2020 11:47:02 +0200 (CEST)
Date:   Thu, 11 Jun 2020 11:47:02 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net 2/2] flow_offload: fix miss cleanup flow_block_cb of
 indr_setup_ft_cb type
Message-ID: <20200611094702.GA19063@salvia>
References: <1591846217-3514-1-git-send-email-wenxu@ucloud.cn>
 <1591846217-3514-2-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1591846217-3514-2-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 11, 2020 at 11:30:17AM +0800, wenxu@ucloud.cn wrote:
> From: wenxu <wenxu@ucloud.cn>
> 
> Currently indr setup supoort both indr_setup_ft_cb and indr_setup_tc_cb.
> But the __flow_block_indr_cleanup only check the indr_setup_tc_cb in
> mlx5e driver.
> It is better to just check the indr_release_cb, all the setup_cb type
> share the same release_cb.

I think patch 1/2 and 2/2 should be collapsed into one single patch.

(Non-native English) suggestion for your patch description:

"If the representor is removed, then identify the indirect flow_blocks
that need to be removed by the release callback."

Thank you.
