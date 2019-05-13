Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 042FE1BA9C
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 18:07:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730053AbfEMQHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 12:07:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729246AbfEMQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 12:07:35 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2EA3714E2083E;
        Mon, 13 May 2019 09:07:34 -0700 (PDT)
Date:   Mon, 13 May 2019 09:07:33 -0700 (PDT)
Message-Id: <20190513.090733.1731394770012592569.davem@davemloft.net>
To:     chenweilong@huawei.com
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org
Subject: Re: [PATCH net-next] ipv4: Add support to disable icmp timestamp
From:   David Miller <davem@davemloft.net>
In-Reply-To: <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
References: <676bcfba-7688-1466-4340-458941aa9258@huawei.com>
        <20190513114900.GD22349@unicorn.suse.cz>
        <04fe9e70-2461-268b-7599-d2170c40377f@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 13 May 2019 09:07:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Weilong Chen <chenweilong@huawei.com>
Date: Mon, 13 May 2019 20:06:37 +0800

> So, the 'time' may become sensitive information. The OS should not
> leak it out.

The current time of day is a globally synchronized value everyone on
the planet has access to.

I don't buy this line of reasoning at all, time is not sensitive
information.

I agree with Michal, the apps should not be using time as a seed for
critical calculations that have security implications.

There is no way I am applying this patch, especially as-is.
