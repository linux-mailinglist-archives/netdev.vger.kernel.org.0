Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2516DB569
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:03:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438023AbfJQSDO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 17 Oct 2019 14:03:14 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39626 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437975AbfJQSDO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:03:14 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 26A8B13F8C90E;
        Thu, 17 Oct 2019 11:03:13 -0700 (PDT)
Date:   Thu, 17 Oct 2019 14:03:12 -0400 (EDT)
Message-Id: <20191017.140312.595649405075783834.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     pablo@netfilter.org, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, saeedm@mellanox.com, vishal@chelsio.com,
        vladbu@mellanox.com
Subject: Re: [PATCH net-next,v5 3/4] net: flow_offload: mangle action at
 byte level
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4ec50937-1880-bac0-5495-c36f7e60584f@solarflare.com>
References: <20191017103059.3b7ff828@cakuba.netronome.com>
        <20191017174603.m3riooywbgy2r5hr@salvia>
        <4ec50937-1880-bac0-5495-c36f7e60584f@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 11:03:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Thu, 17 Oct 2019 19:01:36 +0100

> On 17/10/2019 18:46, Pablo Neira Ayuso wrote:
>> Making this opt-in will just leave things as bad as they are right
>> now, with drivers that are very much hard to read.
> Again, there are two driver developers in this conversation, and they
>  both disagree with you.  Reflect on that fact.

+1
