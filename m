Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F173C02EF
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 12:05:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfI0KFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 06:05:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57884 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725992AbfI0KFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 06:05:39 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 09CC614E0E7AD;
        Fri, 27 Sep 2019 03:05:37 -0700 (PDT)
Date:   Fri, 27 Sep 2019 12:05:33 +0200 (CEST)
Message-Id: <20190927.120533.464156831739223782.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com
Subject: Re: [PATCH net 0/3] tcp: provide correct skb->priority
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190924150116.199028-1-edumazet@google.com>
References: <20190924150116.199028-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 03:05:38 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Tue, 24 Sep 2019 08:01:13 -0700

> SO_PRIORITY socket option requests TCP egress packets
> to contain a user provided value.
> 
> TCP manages to send most packets with the requested values,
> notably for TCP_ESTABLISHED state, but fails to do so for
> few packets.
> 
> These packets are control packets sent on behalf
> of SYN_RECV or TIME_WAIT states.
> 
> Note that to test this with packetdrill, it is a bit
> of a hassle, since packetdrill can not verify priority
> of egress packets, other than indirect observations,
> using for example sch_prio on its tunnel device.
> 
> The bad skb priorities cause problems for GCP,
> as this field is one of the keys used in routing.

Series applied, thanks Eric.
