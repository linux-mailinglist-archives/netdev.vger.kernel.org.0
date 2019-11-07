Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D25CF3C37
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:28:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728294AbfKGX2L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:28:11 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49958 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727740AbfKGX2K (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:28:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 50ED915371C58;
        Thu,  7 Nov 2019 15:28:10 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:28:09 -0800 (PST)
Message-Id: <20191107.152809.1266309207458297062.davem@davemloft.net>
To:     oneukum@suse.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCHv2] CDC-NCM: handle incomplete transfer of MTU
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191107084802.10289-1-oneukum@suse.com>
References: <20191107084802.10289-1-oneukum@suse.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:28:10 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Oliver Neukum <oneukum@suse.com>
Date: Thu,  7 Nov 2019 09:48:01 +0100

> A malicious device may give half an answer when asked
> for its MTU. The driver will proceed after this with
> a garbage MTU. Anything but a complete answer must be treated
> as an error.
> 
> V2: used sizeof as request by Alexander
> 
> Reported-and-tested-by: syzbot+0631d878823ce2411636@syzkaller.appspotmail.com
> Signed-off-by: Oliver Neukum <oneukum@suse.com>

Applied and queued up for -stable, thanks.
