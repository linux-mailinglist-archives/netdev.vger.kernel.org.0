Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98F52183939
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 20:08:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726776AbgCLTIe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Mar 2020 15:08:34 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725268AbgCLTId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Mar 2020 15:08:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 02BB3157967FD;
        Thu, 12 Mar 2020 12:08:32 -0700 (PDT)
Date:   Thu, 12 Mar 2020 12:08:30 -0700 (PDT)
Message-Id: <20200312.120830.863305778891179250.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     kuniyu@amazon.co.jp, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        edumazet@google.com, kuni1840@gmail.com, netdev@vger.kernel.org,
        osa-contribution-log@amazon.com
Subject: Re: [PATCH v5 net-next 0/4] Improve bind(addr, 0) behaviour.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <566b454d-f338-895e-03bf-346740f3ce48@gmail.com>
References: <20200310080527.70180-1-kuniyu@amazon.co.jp>
        <566b454d-f338-895e-03bf-346740f3ce48@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Mar 2020 12:08:33 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 12 Mar 2020 11:52:57 -0700

> On 3/10/20 1:05 AM, Kuniyuki Iwashima wrote:
>> Currently we fail to bind sockets to ephemeral ports when all of the ports
>> are exhausted even if all sockets have SO_REUSEADDR enabled. In this case,
>> we still have a chance to connect to the different remote hosts.
>> 
>> These patches add net.ipv4.ip_autobind_reuse option and fix the behaviour
>> to fully utilize all space of the local (addr, port) tuples.
> 
> Reviewed-by: Eric Dumazet <edumazet@google.com>

Series applied to net-next, thanks everyone.
