Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CE9E145CE9
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 21:10:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728928AbgAVUK4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 15:10:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50834 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725911AbgAVUK4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 15:10:56 -0500
Received: from localhost (unknown [62.209.224.147])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F12515A15BBE;
        Wed, 22 Jan 2020 12:10:55 -0800 (PST)
Date:   Wed, 22 Jan 2020 21:10:01 +0100 (CET)
Message-Id: <20200122.211001.959451019501750401.davem@davemloft.net>
To:     pabeni@redhat.com
Cc:     netdev@vger.kernel.org, willemdebruijn.kernel@gmail.com
Subject: Re: [PATCH net] Revert "udp: do rmem bulk free even if the rx sk
 queue is empty"
From:   David Miller <davem@davemloft.net>
In-Reply-To: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
References: <ec4444596ced8bd90da812538198d97703186626.1579615523.git.pabeni@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 Jan 2020 12:10:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paolo Abeni <pabeni@redhat.com>
Date: Tue, 21 Jan 2020 16:50:49 +0100

> This reverts commit 0d4a6608f68c7532dcbfec2ea1150c9761767d03.
> 
> Williem reported that after commit 0d4a6608f68c ("udp: do rmem bulk
> free even if the rx sk queue is empty") the memory allocated by
> an almost idle system with many UDP sockets can grow a lot.
> 
> For stable kernel keep the solution as simple as possible and revert
> the offending commit.
> 
> Reported-by: Willem de Bruijn <willemdebruijn.kernel@gmail.com>
> Diagnosed-by: Eric Dumazet <eric.dumazet@gmail.com>
> Fixes: 0d4a6608f68c ("udp: do rmem bulk free even if the rx sk queue is empty")
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Applied and queued up for -stable.
