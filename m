Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77576161F1E
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 03:50:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRCum (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 21:50:42 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgBRCul (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 21:50:41 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477::f0c])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1338415B193BF;
        Mon, 17 Feb 2020 18:50:41 -0800 (PST)
Date:   Mon, 17 Feb 2020 18:50:35 -0800 (PST)
Message-Id: <20200217.185035.1127250696063378463.davem@davemloft.net>
To:     danielwa@cisco.com
Cc:     zbr@ioremap.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: connector: cn_proc: allow limiting certain
 messages
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200217172551.GL24152@zorba>
References: <20200212192901.6402-1-danielwa@cisco.com>
        <20200216.184443.782357344949548902.davem@davemloft.net>
        <20200217172551.GL24152@zorba>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 17 Feb 2020 18:50:41 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Daniel Walker (danielwa)" <danielwa@cisco.com>
Date: Mon, 17 Feb 2020 17:25:57 +0000

> On Sun, Feb 16, 2020 at 06:44:43PM -0800, David Miller wrote:
>> 
>> This is a netlink based facility, therefore please you should add filtering
>> capabilities to the netlink configuration and communications path.
>> 
>> Module parameters are quite verboten.
> 
> How about adding in Kconfig options to limit the types of messages?

Dynamic over compile time please.

