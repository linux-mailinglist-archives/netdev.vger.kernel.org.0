Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B287910A6FD
	for <lists+netdev@lfdr.de>; Wed, 27 Nov 2019 00:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726926AbfKZXPn convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 26 Nov 2019 18:15:43 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:43808 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726231AbfKZXPn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 18:15:43 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A349814DB5304;
        Tue, 26 Nov 2019 15:15:42 -0800 (PST)
Date:   Tue, 26 Nov 2019 15:15:42 -0800 (PST)
Message-Id: <20191126.151542.740854013908888546.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: inet_is_local_reserved_port() port arg should be
 unsigned short
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191126224416.23883-1-zenczykowski@gmail.com>
References: <20191126224416.23883-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 26 Nov 2019 15:15:42 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Tue, 26 Nov 2019 14:44:16 -0800

> From: Maciej ¯enczykowski <maze@google.com>
> 
> Any argument outside of that range would result in an out of bound
> memory access, since the accessed array is 65536 bits long.
> 
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied.
