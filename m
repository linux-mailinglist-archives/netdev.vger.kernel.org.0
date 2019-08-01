Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA49A7E09E
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 18:55:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733226AbfHAQzS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 12:55:18 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57010 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732225AbfHAQzQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 12:55:16 -0400
Received: from localhost (unknown [IPv6:2603:3004:624:eb00::2d06])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DF8E9153F14CF;
        Thu,  1 Aug 2019 09:55:15 -0700 (PDT)
Date:   Thu, 01 Aug 2019 12:55:15 -0400 (EDT)
Message-Id: <20190801.125515.1481350183346032497.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net-next] be2net: disable bh with spin_lock in
 be_process_mcc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801092420.34502-1-dkirjanov@suse.com>
References: <20190801092420.34502-1-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 01 Aug 2019 09:55:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Thu,  1 Aug 2019 11:24:20 +0200

> be_process_mcc() is invoked in 3 different places and
> always with BHs disabled except the be_poll function
> but since it's invoked from softirq with BHs
> disabled it won't hurt.
> 
> v1->v2: added explanation to the patch
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Like Willem I see no benefit at all to this change.
