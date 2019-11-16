Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91854FF56B
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:19:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727719AbfKPUS4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:18:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53248 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPUS4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:18:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AC79015172247;
        Sat, 16 Nov 2019 12:18:55 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:18:55 -0800 (PST)
Message-Id: <20191116.121855.39087339208287206.davem@davemloft.net>
To:     andrea.mayer@uniroma2.it
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net, 0/2] seg6: fixes to Segment Routing in IPv6
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116150553.17497-1-andrea.mayer@uniroma2.it>
References: <20191116150553.17497-1-andrea.mayer@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:18:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>
Date: Sat, 16 Nov 2019 16:05:51 +0100

> This patchset is divided in 2 patches and it introduces some fixes
> to Segment Routing in IPv6, which are:
> 
> - in function get_srh() fix the srh pointer after calling
>   pskb_may_pull();
> 
> - fix the skb->transport_header after calling decap_and_validate()
>   function;
> 
> Any comments on the patchset are welcome.

Series applied and queued up for -stable, thanks.
