Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A45CFF56C
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 21:20:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727591AbfKPUUB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 15:20:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53262 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbfKPUUB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 15:20:01 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id ED89E1517225C;
        Sat, 16 Nov 2019 12:19:58 -0800 (PST)
Date:   Sat, 16 Nov 2019 12:19:58 -0800 (PST)
Message-Id: <20191116.121958.831688079107924292.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_8021q: Fix
 dsa_8021q_restore_pvid for an absent pvid
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191116160842.29511-1-olteanv@gmail.com>
References: <20191116160842.29511-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 16 Nov 2019 12:19:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Please do not submit parallel fixes for net and net-next.

Just submit the 'net' fix and when 'net' is nexted merged into
'net-next' the fix will propagate.
