Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC0C0284C4A
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 15:10:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726127AbgJFNKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 09:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbgJFNKo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 09:10:44 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9A4AC061755;
        Tue,  6 Oct 2020 06:10:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F19CB127C6C28;
        Tue,  6 Oct 2020 05:53:54 -0700 (PDT)
Date:   Tue, 06 Oct 2020 06:10:41 -0700 (PDT)
Message-Id: <20201006.061041.2224252569656609542.davem@davemloft.net>
To:     anant.thazhemadam@gmail.com
Cc:     linux-kernel-mentees@lists.linuxfoundation.org, joe@perches.com,
        syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com,
        petkan@nucleusys.com, kuba@kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] net: usb: rtl8150: set random MAC address when
 set_ethernet_addr() fails
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201005132958.5712-1-anant.thazhemadam@gmail.com>
References: <20201005132958.5712-1-anant.thazhemadam@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 06 Oct 2020 05:53:55 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Anant Thazhemadam <anant.thazhemadam@gmail.com>
Date: Mon,  5 Oct 2020 18:59:58 +0530

> When get_registers() fails in set_ethernet_addr(),the uninitialized
> value of node_id gets copied over as the address.
> So, check the return value of get_registers().
> 
> If get_registers() executed successfully (i.e., it returns
> sizeof(node_id)), copy over the MAC address using ether_addr_copy()
> (instead of using memcpy()).
> 
> Else, if get_registers() failed instead, a randomly generated MAC
> address is set as the MAC address instead.
> 
> Reported-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Tested-by: syzbot+abbc768b560c84d92fd3@syzkaller.appspotmail.com
> Acked-by: Petko Manolov <petkan@nucleusys.com>
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

Applied, thank you.
