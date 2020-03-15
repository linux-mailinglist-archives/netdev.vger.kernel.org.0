Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 241C51859F8
	for <lists+netdev@lfdr.de>; Sun, 15 Mar 2020 05:02:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726201AbgCOECr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Mar 2020 00:02:47 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:35276 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725890AbgCOECr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Mar 2020 00:02:47 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C0CDA15B7526B;
        Sat, 14 Mar 2020 21:02:46 -0700 (PDT)
Date:   Sat, 14 Mar 2020 21:02:46 -0700 (PDT)
Message-Id: <20200314.210246.1281276055973553805.davem@davemloft.net>
To:     bmeneg@redhat.com
Cc:     linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        netdev@vger.kernel.org, GLin@suse.com, kuba@kernel.org,
        ast@kernel.org
Subject: Re: [PATCH v2] net/bpfilter: fix dprintf usage for /dev/kmsg
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200312230820.2132069-1-bmeneg@redhat.com>
References: <20200312230820.2132069-1-bmeneg@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 14 Mar 2020 21:02:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruno Meneguele <bmeneg@redhat.com>
Date: Thu, 12 Mar 2020 20:08:20 -0300

> The bpfilter UMH code was recently changed to log its informative messages to
> /dev/kmsg, however this interface doesn't support SEEK_CUR yet, used by
> dprintf(). As result dprintf() returns -EINVAL and doesn't log anything.
> 
> However there already had some discussions about supporting SEEK_CUR into
> /dev/kmsg interface in the past it wasn't concluded. Since the only user of
> that from userspace perspective inside the kernel is the bpfilter UMH
> (userspace) module it's better to correct it here instead waiting a conclusion
> on the interface.
> 
> Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
> Signed-off-by: Bruno Meneguele <bmeneg@redhat.com>

Applied, thank you.
