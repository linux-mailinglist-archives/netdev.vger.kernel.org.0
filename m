Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF59838ED
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 20:47:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726055AbfHFSra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 14:47:30 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:48034 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725798AbfHFSra (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Aug 2019 14:47:30 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0ED6415248BD1;
        Tue,  6 Aug 2019 11:47:30 -0700 (PDT)
Date:   Tue, 06 Aug 2019 11:47:29 -0700 (PDT)
Message-Id: <20190806.114729.427225609419991078.davem@davemloft.net>
To:     kda@linux-powerpc.org
Cc:     sathya.perla@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, netdev@vger.kernel.org
Subject: Re: [PATCH v3 net-next] be2net: disable bh with spin_lock in
 be_process_mcc
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190806105111.27058-1-dkirjanov@suse.com>
References: <20190806105111.27058-1-dkirjanov@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 06 Aug 2019 11:47:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Denis Kirjanov <kda@linux-powerpc.org>
Date: Tue,  6 Aug 2019 12:51:11 +0200

> be_process_mcc() is invoked in 3 different places and
> always with BHs disabled except the be_poll function
> but since it's invoked from softirq with BHs
> disabled it won't hurt.
> 
> v1->v2: added explanation to the patch
> v2->v3: add a missing call from be_cmds.c
> 
> Signed-off-by: Denis Kirjanov <kda@linux-powerpc.org>

Applied.
