Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0F576105EF4
	for <lists+netdev@lfdr.de>; Fri, 22 Nov 2019 04:15:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726574AbfKVDPk convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 21 Nov 2019 22:15:40 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57238 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726335AbfKVDPk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 22:15:40 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C068E15103183;
        Thu, 21 Nov 2019 19:15:39 -0800 (PST)
Date:   Thu, 21 Nov 2019 19:15:39 -0800 (PST)
Message-Id: <20191121.191539.916772134939792845.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net-ipv6: IPV6_TRANSPARENT - check NET_RAW prior to
 NET_ADMIN
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191121211908.64187-1-zenczykowski@gmail.com>
References: <20191121211908.64187-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 Nov 2019 19:15:39 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Thu, 21 Nov 2019 13:19:08 -0800

> From: Maciej ¯enczykowski <maze@google.com>
> 
> NET_RAW is less dangerous, so more likely to be available to a process,
> so check it first to prevent some spurious logging.
> 
> This matches IP_TRANSPARENT which checks NET_RAW first.
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied, thanks.
