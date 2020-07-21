Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B83E228CAA
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 01:22:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731450AbgGUXWn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 19:22:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726148AbgGUXWm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 19:22:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4E7BC061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 16:22:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E9D711E45901;
        Tue, 21 Jul 2020 16:05:57 -0700 (PDT)
Date:   Tue, 21 Jul 2020 16:22:41 -0700 (PDT)
Message-Id: <20200721.162241.478043805479604284.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     rakeshs.lkm@gmail.com, sbhatta@marvell.com, sgoutham@marvell.com,
        jerinj@marvell.com, rsaladi2@marvell.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Interrupt handler support for NPA and NIX in
 Octeontx2.
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200721122329.4d785138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200721023847.2567-1-rakeshs.lkm@gmail.com>
        <20200721122329.4d785138@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 21 Jul 2020 16:05:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue, 21 Jul 2020 12:23:29 -0700

> On Tue, 21 Jul 2020 08:08:45 +0530 rakeshs.lkm@gmail.com wrote:
>> From: Rakesh Babu <rakeshs.lkm@gmail.com>
>> 
>> Changes from v1.
>> 1. Assigned void pointers to another type of pointers without type casting.
>> 2. Removed Switch and If cases in interrupt handlers and printed the hexa
>> value of the interrupt
> 
> These days error events should be reported via devlink health, 
> not printing messages to the logs.

+1
