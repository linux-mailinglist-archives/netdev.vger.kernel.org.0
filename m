Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B84E111BD8E
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 21:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726739AbfLKUBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 15:01:21 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:59660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726463AbfLKUBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 15:01:21 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9773013EF0DC6;
        Wed, 11 Dec 2019 12:01:20 -0800 (PST)
Date:   Wed, 11 Dec 2019 12:01:20 -0800 (PST)
Message-Id: <20191211.120120.991784482938734303.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     nikolay@cumulusnetworks.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191211134133.GB1587652@t480s.localdomain>
References: <0e45fd22-c31b-a9c2-bf87-22c16a60aeb4@gmail.com>
        <9f978ee1-08ee-aa57-6e3d-9b68657eeb14@cumulusnetworks.com>
        <20191211134133.GB1587652@t480s.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Dec 2019 12:01:20 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 11 Dec 2019 13:41:33 -0500

> Hi David, Nikolay,
> 
> On Wed, 11 Dec 2019 17:42:33 +0200, Nikolay Aleksandrov <nikolay@cumulusnetworks.com> wrote:
>> >>  /* Bridge multicast database attributes
>> >>   * [MDBA_MDB] = {
>> >>   *     [MDBA_MDB_ENTRY] = {
>> >> @@ -261,6 +270,7 @@ enum {
>> >>  	BRIDGE_XSTATS_UNSPEC,
>> >>  	BRIDGE_XSTATS_VLAN,
>> >>  	BRIDGE_XSTATS_MCAST,
>> >> +	BRIDGE_XSTATS_STP,
>> >>  	BRIDGE_XSTATS_PAD,
>> >>  	__BRIDGE_XSTATS_MAX
>> >>  };
>> > 
>> > Shouldn't the new entry be appended to the end - after BRIDGE_XSTATS_PAD
>> > 
>> 
>> Oh yes, good catch. That has to be fixed, too.
>> 
> 
> This I don't get. Why new attributes must come between BRIDGE_XSTATS_PAD
> and __BRIDGE_XSTATS_MAX?

Because, just like any other attribute value, BRIDGE_XSTATS_PAD is an
API and fixed in stone.  You can't add things before it which change
it's value.

