Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 024281BA9D
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:07:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730263AbfEMQHx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:07:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39212 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbfEMQHx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:07:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9A03A14E226C2;
        Mon, 13 May 2019 09:07:52 -0700 (PDT)
Date:   Mon, 13 May 2019 09:07:52 -0700 (PDT)
Message-Id: <20190513.090752.109843175300806601.davem@davemloft.net>
To:     mkubecek@suse.cz
Cc:     netdev@vger.kernel.org, chenweilong@huawei.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190513121145.GE22349@unicorn.suse.cz>
References: <20190513114900.GD22349@unicorn.suse.cz>
        <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
        <20190513121145.GE22349@unicorn.suse.cz>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:07:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kubecek <mkubecek@suse.cz>
Date: Mon, 13 May 2019 14:11:45 +0200

> I'm sorry but I cannot agree with that. Seeding PRNG with current time
> is known to be a bad practice and if some application does it, the
> solution is to fix the application, not obfuscating system time.

+1 +1 +1
