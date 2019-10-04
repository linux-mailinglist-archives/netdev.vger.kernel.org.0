Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BE26CC4D4
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 23:32:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728841AbfJDVc1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 17:32:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59268 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbfJDVc1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Oct 2019 17:32:27 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 03B8614F0FAB1;
        Fri,  4 Oct 2019 14:32:26 -0700 (PDT)
Date:   Fri, 04 Oct 2019 14:32:26 -0700 (PDT)
Message-Id: <20191004.143226.1046593817417339949.davem@davemloft.net>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        rajendra.dendukuri@broadcom.com, eric.dumazet@gmail.com,
        dsahern@gmail.com, edumazet@google.com
Subject: Re: [PATCH net] Revert "ipv6: Handle race in addrconf_dad_work"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191003214615.10119-1-dsahern@kernel.org>
References: <20191003214615.10119-1-dsahern@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 04 Oct 2019 14:32:27 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Thu,  3 Oct 2019 14:46:15 -0700

> From: David Ahern <dsahern@gmail.com>
> 
> This reverts commit a3ce2a21bb8969ae27917281244fa91bf5f286d7.
> 
> Eric reported tests failings with commit. After digging into it,
> the bottom line is that the DAD sequence is not to be messed with.
> There are too many cases that are expected to proceed regardless
> of whether a device is up.
> 
> Revert the patch and I will send a different solution for the
> problem Rajendra reported.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied and the reverted patch removed from the -stable queue.
