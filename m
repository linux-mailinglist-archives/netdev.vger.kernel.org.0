Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C23E33AD6E
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 05:10:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387461AbfFJDId (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 23:08:33 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49118 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387436AbfFJDId (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 23:08:33 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68FA714EB018D;
        Sun,  9 Jun 2019 20:08:32 -0700 (PDT)
Date:   Sun, 09 Jun 2019 20:08:31 -0700 (PDT)
Message-Id: <20190609.200831.1379938472199180553.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        john.hurley@netronome.com
Subject: Re: [PATCH net] nfp: ensure skb network header is set for packet
 redirect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190609004803.9018-1-jakub.kicinski@netronome.com>
References: <20190609004803.9018-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 20:08:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sat,  8 Jun 2019 17:48:03 -0700

> From: John Hurley <john.hurley@netronome.com>
> 
> Packets received at the NFP driver may be redirected to egress of another
> netdev (e.g. in the case of OvS internal ports). On the egress path, some
> processes, like TC egress hooks, may expect the network header offset
> field in the skb to be correctly set. If this is not the case there is
> potential for abnormal behaviour and even the triggering of BUG() calls.
> 
> Set the skb network header field before the mac header pull when doing a
> packet redirect.
> 
> Fixes: 27f54b582567 ("nfp: allow fallback packets from non-reprs")
> Signed-off-by: John Hurley <john.hurley@netronome.com>
> Reviewed-by: Jakub Kicinski <jakub.kicinski@netronome.com>

Applied.
