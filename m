Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB631A6D52
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 22:33:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388414AbgDMUdj convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Apr 2020 16:33:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:51114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727877AbgDMUdi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 16:33:38 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9AFC4127691AC;
        Mon, 13 Apr 2020 13:33:34 -0700 (PDT)
Date:   Mon, 13 Apr 2020 13:33:31 -0700 (PDT)
Message-Id: <20200413.133331.704932428417772141.davem@davemloft.net>
To:     lesedorucalin01@gmail.com
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: UDP repair mode for retrieving the send queue of
 corked UDP socket
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200413200927.GA22493@white>
References: <20200408205954.GA15086@white>
        <20200412.205611.844961656085784911.davem@davemloft.net>
        <20200413200927.GA22493@white>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 Apr 2020 13:33:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leºe Doru Cãlin <lesedorucalin01@gmail.com>
Date: Mon, 13 Apr 2020 23:09:27 +0300

> On Sun, Apr 12, 2020 at 08:56:11PM -0700, David Miller wrote:
>> From: Lese Doru Calin <lesedorucalin01@gmail.com>
>> Date: Wed, 8 Apr 2020 23:59:54 +0300
>> 
>> > +static int udp_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
>> > +{
>> > +	struct sk_buff *skb;
>> > +	int copied = 0, err = 0, copy;
>> 
>> Please use reverse christmas tree (longest to shortest) ordering for
>> local variables.
>> 
>> > +static int udp6_peek_sndq(struct sock *sk, struct msghdr *msg, int off, int len)
>> > +{
>> > +	struct sk_buff *skb;
>> > +	int copied = 0, err = 0, copy;
>> 
>> Likewise.
>> 
>> Thank you.
> 
> I changed it accordingly. I hope it is ok.

You have to make a fresh patch posting when you fix feedback given
to you, and add appropriate version specifications to your Subject
line such as "[PATCH v2]" etc.
