Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D6831B304B
	for <lists+netdev@lfdr.de>; Tue, 21 Apr 2020 21:26:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726173AbgDUT0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Apr 2020 15:26:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725902AbgDUT0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Apr 2020 15:26:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0891DC0610D5
        for <netdev@vger.kernel.org>; Tue, 21 Apr 2020 12:26:14 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4844C128C1267;
        Tue, 21 Apr 2020 12:26:13 -0700 (PDT)
Date:   Tue, 21 Apr 2020 12:26:10 -0700 (PDT)
Message-Id: <20200421.122610.891640326169718840.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     andre.guedes@intel.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, aaron.f.brown@intel.com
Subject: Re: [net-next 02/13] igc: Use netdev log helpers in igc_main.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com>
References: <20200420234313.2184282-1-jeffrey.t.kirsher@intel.com>
        <20200420234313.2184282-3-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Apr 2020 12:26:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Mon, 20 Apr 2020 16:43:02 -0700

> It also takes this opportunity to improve some messages and remove
> the '\n' character at the end of messages since it is automatically
> added to by netdev_* log helpers.

Where does this happen?  I can't find it.

I'm tossing this series, you have to explain where this happens
because I see several developers who can't figure this out at all.
