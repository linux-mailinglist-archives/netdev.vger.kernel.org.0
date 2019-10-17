Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3231BDB337
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 19:24:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440708AbfJQRYV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 13:24:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39014 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436760AbfJQRYV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 13:24:21 -0400
Received: from localhost (unknown [IPv6:2603:3023:50c:85e1:5314:1b70:2a53:887e])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 1F90E13EA3E93;
        Thu, 17 Oct 2019 10:24:20 -0700 (PDT)
Date:   Thu, 17 Oct 2019 13:24:17 -0400 (EDT)
Message-Id: <20191017.132417.2018767014754768906.davem@davemloft.net>
To:     neiljerram@cantab.net
Cc:     oneukum@suse.com, netdev@vger.kernel.org, johan@kernel.org
Subject: Re: [PATCHv2] usb: hso: obey DMA rules in tiocmget
From:   David Miller <davem@davemloft.net>
In-Reply-To: <87tv87qvd4.fsf@ossau.homelinux.net>
References: <20191017132548.21888-1-oneukum@suse.com>
        <87tv87qvd4.fsf@ossau.homelinux.net>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 17 Oct 2019 10:24:20 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Jerram <neiljerram@cantab.net>
Date: Thu, 17 Oct 2019 15:50:31 +0100

> Oliver Neukum <oneukum@suse.com> writes:
> 
>> The serial state information must not be embedded into another
>> data structure, as this interferes with cache handling for DMA
>> on architectures without cache coherence..
>> That would result in data corruption on some architectures
> 
> Could you say more what you mean by "some architectures"?  I wonder if
> this is responsible for long-standing flakiness dealing with the HSO
> modem in the GTA04 phone?

Some MIPS, older sparc, etc.

I think this is documented in DMA API usage documentation under Documentation/
even.
