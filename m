Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30F86B7875
	for <lists+netdev@lfdr.de>; Thu, 19 Sep 2019 13:27:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389853AbfISL1v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 07:27:51 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55110 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388045AbfISL1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 07:27:51 -0400
Received: from localhost (unknown [86.58.254.34])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 33758154FB654;
        Thu, 19 Sep 2019 04:27:49 -0700 (PDT)
Date:   Thu, 19 Sep 2019 13:27:48 +0200 (CEST)
Message-Id: <20190919.132748.2115280997703522390.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] usbnet: sanity checking of packet sizes and device mtu
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190919082309.23365-1-oneukum@suse.com>
References: <20190919082309.23365-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 19 Sep 2019 04:27:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu, 19 Sep 2019 10:23:08 +0200

> After a reset packet sizes and device mtu can change and need
> to be reevaluated to calculate queue sizes.
> Malicious devices can set this to zero and we divide by it.
> Introduce sanity checking.
> 
> Reported-and-tested-by:  syzbot+6102c120be558c885f04@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied and queued up for -stable.
