Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC793FD28D
	for <lists+netdev@lfdr.de>; Fri, 15 Nov 2019 02:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727325AbfKOBpN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 20:45:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57332 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbfKOBpN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 20:45:13 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9E25714B73C6A;
        Thu, 14 Nov 2019 17:45:12 -0800 (PST)
Date:   Thu, 14 Nov 2019 17:45:12 -0800 (PST)
Message-Id: <20191114.174512.2282984013110706126.davem@davemloft.net>
To:     andrea.mayer@uniroma2.it
Cc:     kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        dav.lebrun@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [net-next, 1/3] seg6: verify srh pointer in get_srh()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191113192912.17546-2-andrea.mayer@uniroma2.it>
References: <20191113192912.17546-1-andrea.mayer@uniroma2.it>
        <20191113192912.17546-2-andrea.mayer@uniroma2.it>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 Nov 2019 17:45:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrea Mayer <andrea.mayer@uniroma2.it>
Date: Wed, 13 Nov 2019 20:29:10 +0100

> pskb_may_pull may change pointers in header. For this reason, it is
> mandatory to reload any pointer that points into skb header.
> 
> Signed-off-by: Andrea Mayer <andrea.mayer@uniroma2.it>

This is a bug fix and must be separated out and submitted to 'net'.

Then you must wait until 'net' is merged into 'net-next' so that you
can cleanly resubmit the other changes in this series which add the
new features.

Actually, patch #2 looks like a bug fix as well.
