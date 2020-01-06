Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB8E3130CAA
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 05:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgAFEAO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Sun, 5 Jan 2020 23:00:14 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46016 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727450AbgAFEAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jan 2020 23:00:14 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 98623156741CF;
        Sun,  5 Jan 2020 20:00:13 -0800 (PST)
Date:   Sun, 05 Jan 2020 20:00:11 -0800 (PST)
Message-Id: <20200105.200011.1634381109954258662.davem@davemloft.net>
To:     bigon@bigon.be
Cc:     netdev@vger.kernel.org
Subject: Re: Error in comment in include/uapi/linux/in6.h?
From:   David Miller <davem@davemloft.net>
In-Reply-To: <a6e75918-9608-2de3-eea5-a18f4bdf17ec@bigon.be>
References: <a6e75918-9608-2de3-eea5-a18f4bdf17ec@bigon.be>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 Jan 2020 20:00:13 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Laurent Bigonville <bigon@bigon.be>
Date: Mon, 6 Jan 2020 02:19:52 +0100

> Looking at the ipv6_mreq struct in include/uapi/linux/in6.h, the comment
> for the ipv6mr_ifindex member says "local IPv6 address of interface",
> shouldn't that be "index of the interface" or something like that? Or am
> I mistaken here?
> 
> struct ipv6_mreq {
>         /* IPv6 multicast address of group */
>         struct in6_addr ipv6mr_multiaddr;
> 
>         /* local IPv6 address of interface */
>         int             ipv6mr_ifindex;
> };

Yes, it should.
