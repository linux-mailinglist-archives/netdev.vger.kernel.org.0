Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B891B32A6
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 00:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726100AbgDUWc2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 18:32:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726039AbgDUWc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 18:32:27 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB6FCC0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 15:32:27 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0BF3128E6F29;
        Tue, 21 Apr 2020 15:32:24 -0700 (PDT)
Date:   Tue, 21 Apr 2020 15:32:21 -0700 (PDT)
Message-Id: <20200421.153221.2089591404052111123.davem@davemloft.net>
To:     andre.guedes@linux.intel.com
Cc:     jeffrey.t.kirsher@intel.com, kuba@kernel.org,
        andre.guedes@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, aaron.f.brown@intel.com
Subject: Re: [net-next 02/13] igc: Use netdev log helpers in igc_main.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <158750338551.60047.10607495842380954746@pvrobles-mobl1.amr.corp.intel.com>
References: <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com>
        <20200421.122610.891640326169718840.davem@davemloft.net>
        <158750338551.60047.10607495842380954746@pvrobles-mobl1.amr.corp.intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 15:32:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andre Guedes <andre.guedes@linux.intel.com>
Date: Tue, 21 Apr 2020 14:09:45 -0700

> Quoting David Miller (2020-04-21 12:26:10)
>> I'm tossing this series, you have to explain where this happens
>> because I see several developers who can't figure this out at all.
> 
> Hope that clarifies and this series is still good to be merged.

First of all, the commits make it look like specifically like the
netdev printk facilities do the newline thing.

But overall this looks like just busy work, and I've seen commits
that add missing newlines.

I don't think these changes are valuable nor wise.

Please kill these newline removal changes, thank you.
