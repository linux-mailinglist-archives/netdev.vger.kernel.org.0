Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC0481896B5
	for <lists+netdev@lfdr.de>; Wed, 18 Mar 2020 09:11:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727487AbgCRILy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Mar 2020 04:11:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727113AbgCRILx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Mar 2020 04:11:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2579E13EC66AC;
        Wed, 18 Mar 2020 01:11:53 -0700 (PDT)
Date:   Wed, 18 Mar 2020 01:11:52 -0700 (PDT)
Message-Id: <20200318.011152.72770718915606186.davem@davemloft.net>
To:     alexei.starovoitov@gmail.com
Cc:     pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/29] Netfilter updates for net-next
From:   David Miller <davem@davemloft.net>
In-Reply-To: <CAADnVQLWa-mAXB10OQoC+aDwpcrJc7e0Tr=z9uXBjB7dFjOvYQ@mail.gmail.com>
References: <20200318003956.73573-1-pablo@netfilter.org>
        <CAADnVQLWa-mAXB10OQoC+aDwpcrJc7e0Tr=z9uXBjB7dFjOvYQ@mail.gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 18 Mar 2020 01:11:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 17 Mar 2020 20:55:46 -1000

> On Tue, Mar 17, 2020 at 2:42 PM Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>>
>>
>> 15) Add new egress hook, from Lukas Wunner.
> 
> NACKed-by: Alexei Starovoitov <ast@kernel.org>

Sorry I just saw this after pushing this pull request back out.

Please someone deal with this via a revert or similar.
