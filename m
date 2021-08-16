Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 856563EDF14
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 23:09:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233365AbhHPVJu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 17:09:50 -0400
Received: from smtp5.emailarray.com ([65.39.216.39]:39948 "EHLO
        smtp5.emailarray.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233330AbhHPVJt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 17:09:49 -0400
Received: (qmail 35157 invoked by uid 89); 16 Aug 2021 21:09:15 -0000
Received: from unknown (HELO localhost) (amxlbW9uQGZsdWdzdmFtcC5jb21AMTYzLjExNC4xMzIuMQ==) (POLARISLOCAL)  
  by smtp5.emailarray.com with SMTP; 16 Aug 2021 21:09:15 -0000
Date:   Mon, 16 Aug 2021 14:09:14 -0700
From:   Jonathan Lemon <jonathan.lemon@gmail.com>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     netdev@vger.kernel.org, Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH] ptp: ocp: don't allow on S390
Message-ID: <20210816210914.qkyd4em4rw3thbyg@bsd-mbp.dhcp.thefacebook.com>
References: <20210813203026.27687-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210813203026.27687-1-rdunlap@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 13, 2021 at 01:30:26PM -0700, Randy Dunlap wrote:
> There is no 8250 serial on S390. See commit 1598e38c0770.

There's a 8250 serial device on the PCI card.   Its been
ages since I've worked on the architecture, but does S390
even support PCI?

> Is this driver useful even without 8250 serial?

The FB timecard has an FPGA that will internally parse the 
GNSS strings and correct the clock, so the PTP clock will
work even without the serial devices.

However, there are userspace tools which want to read the
GNSS signal (for holdolver and leap second indication), 
which is why they are exposed.
-- 
Jonathan
