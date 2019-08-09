Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5416F86F16
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 03:05:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405195AbfHIBFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Aug 2019 21:05:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:53964 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725785AbfHIBFa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 21:05:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 87B401425E38A;
        Thu,  8 Aug 2019 18:05:29 -0700 (PDT)
Date:   Thu, 08 Aug 2019 18:05:29 -0700 (PDT)
Message-Id: <20190808.180529.1408453640987288575.davem@davemloft.net>
To:     adobriyan@gmail.com
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-sctp@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: use "nb" for notifier blocks
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190805204331.GA25178@avx2>
References: <20190805204331.GA25178@avx2>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 08 Aug 2019 18:05:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Mon, 5 Aug 2019 23:43:31 +0300

> Use more pleasant looking
> 
> 	struct notifier_block *nb,
> 
> instead of "this".
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>

Sorry, this is a lot of churn for something that is basically an
opinion of being nicer or less nice.

I actually kind of like "this".
