Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE6996C147
	for <lists+netdev@lfdr.de>; Wed, 17 Jul 2019 21:04:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfGQTEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jul 2019 15:04:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfGQTEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jul 2019 15:04:08 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C8161475AE87;
        Wed, 17 Jul 2019 12:04:07 -0700 (PDT)
Date:   Wed, 17 Jul 2019 12:04:06 -0700 (PDT)
Message-Id: <20190717.120406.1122378175032864724.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     adobriyan@gmail.com, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-nfs@vger.kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        kadlec@netfilter.org, fw@strlen.de, bfields@fieldses.org,
        chuck.lever@oracle.com
Subject: Re: [PATCH 2/2] net: apply proc_net_mkdir() harder
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190716185220.hnlyiievuucdtn7x@salvia>
References: <20190706165521.GB10550@avx2>
        <20190716185220.hnlyiievuucdtn7x@salvia>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 17 Jul 2019 12:04:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Tue, 16 Jul 2019 20:52:20 +0200

> On Sat, Jul 06, 2019 at 07:55:21PM +0300, Alexey Dobriyan wrote:
>> From: "Hallsmark, Per" <Per.Hallsmark@windriver.com>
>> 
>> proc_net_mkdir() should be used to create stuff under /proc/net,
>> so that dentry revalidation kicks in.
>> 
>> See
>> 
>> 	commit 1fde6f21d90f8ba5da3cb9c54ca991ed72696c43
>> 	proc: fix /proc/net/* after setns(2)
>> 
>> 	[added more chunks --adobriyan]
> 
> I don't find this in the tree,

Because there were changes requested.

