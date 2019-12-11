Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B02D311BFB2
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:17:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbfLKWRC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:17:02 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:32886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbfLKWRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:17:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id F1A3414F4FDA9;
        Wed, 11 Dec 2019 14:17:00 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:16:58 -0800 (PST)
Message-Id: <20191211.141658.433012532951670675.davem@davemloft.net>
To:     vivien.didelot@gmail.com
Cc:     nikolay@cumulusnetworks.com, dsahern@gmail.com,
        roopa@cumulusnetworks.com, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, stephen@networkplumber.org
Subject: Re: [PATCH net-next v2] net: bridge: add STP xstats
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191211164754.GB1616641@t480s.localdomain>
References: <20191211134133.GB1587652@t480s.localdomain>
        <20191211.120120.991784482938734303.davem@davemloft.net>
        <20191211164754.GB1616641@t480s.localdomain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 11 Dec 2019 14:17:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vivien Didelot <vivien.didelot@gmail.com>
Date: Wed, 11 Dec 2019 16:47:54 -0500

> I thought the whole point of using enums was to avoid caring about fixed
> numeric values, but well.

I don't get where you got that idea from.

Each and every netlink attribute value is like IPPROTO_TCP in an ipv4
header, the exact values matter, and therefore you cannot make changes
that modify existing values.

Therefore, you must add new attributes to the end of the enumberation,
right before the __MAX value.

> To be more precise, what I don't get is that when
> I move the BRIDGE_XSTATS_STP definition *after* BRIDGE_XSTATS_PAD, the STP
> xstats don't show up anymore in iproute2.

Because you ahve to recompile iproute2 so that it uses the corrected value
in the kernel header, did you do that?
