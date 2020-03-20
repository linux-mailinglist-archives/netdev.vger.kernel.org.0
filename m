Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B654018C68E
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 05:38:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgCTEie convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 20 Mar 2020 00:38:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46900 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725446AbgCTEid (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 00:38:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EFB171590D672;
        Thu, 19 Mar 2020 21:38:32 -0700 (PDT)
Date:   Thu, 19 Mar 2020 21:38:32 -0700 (PDT)
Message-Id: <20200319.213832.2258629564733373153.davem@davemloft.net>
To:     ilpo.jarvinen@cs.helsinki.fi
Cc:     netdev@vger.kernel.org, ycheng@google.com, ncardwell@google.com,
        eric.dumazet@gmail.com, olivier.tilmans@nokia-bell-labs.com
Subject: Re: [RFC PATCH 00/28]: Accurate ECN for TCP
From:   David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.20.2003192222320.5256@whs-18.cs.helsinki.fi>
References: <1584524612-24470-1-git-send-email-ilpo.jarvinen@helsinki.fi>
        <20200318.162958.1146893420208387579.davem@davemloft.net>
        <alpine.DEB.2.20.2003192222320.5256@whs-18.cs.helsinki.fi>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Mar 2020 21:38:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Ilpo Järvinen" <ilpo.jarvinen@cs.helsinki.fi>
Date: Thu, 19 Mar 2020 22:25:23 +0200 (EET)

> On Wed, 18 Mar 2020, David Miller wrote:
> 
>> From: Ilpo Järvinen <ilpo.jarvinen@helsinki.fi>
>> Date: Wed, 18 Mar 2020 11:43:04 +0200
>> 
>> > Comments would be highly appreciated.
>> 
>> Two coding style comments which you should audit your entire submission
>> for:
>> 
>> 1) Please order local variables in reverse christmas tree ordering (longest
>>    to shortest long)
> 
> Does this apply also to the usual struct tcp_sock *tp = tcp_sk(sk); line
> or can it be put first if there are some dependencies on it?

Yes, please.  Put the assignment into the code lines if necessary.
