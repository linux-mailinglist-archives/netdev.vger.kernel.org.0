Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8276EE6507
	for <lists+netdev@lfdr.de>; Sun, 27 Oct 2019 20:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727985AbfJ0TN4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Oct 2019 15:13:56 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:58582 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727258AbfJ0TNz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Oct 2019 15:13:55 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4A05B14BE8685;
        Sun, 27 Oct 2019 12:13:55 -0700 (PDT)
Date:   Sun, 27 Oct 2019 12:13:53 -0700 (PDT)
Message-Id: <20191027.121353.1242592121363137955.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/5] Netfilter/IPVS fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191027120221.2884-1-pablo@netfilter.org>
References: <20191027120221.2884-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 27 Oct 2019 12:13:55 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Sun, 27 Oct 2019 13:02:16 +0100

> The following patchset contains Netfilter/IPVS fixes for net:
> 
> 1) Fix crash on flowtable due to race between garbage collection
>    and insertion.
> 
> 2) Restore callback unbinding in netfilter offloads.
> 
> 3) Fix races on IPVS module removal, from Davide Caratti.
> 
> 4) Make old_secure_tcp per-netns to fix sysbot report,
>    from Eric Dumazet.
> 
> 5) Validate matching length in netfilter offloads, from wenxu.

Pulled, thanks.
