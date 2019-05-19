Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 98C55227C2
	for <lists+netdev@lfdr.de>; Sun, 19 May 2019 19:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727130AbfESRdo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 May 2019 13:33:44 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41146 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726434AbfESRdn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 May 2019 13:33:43 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CFB913EE2B5E;
        Sun, 19 May 2019 10:33:43 -0700 (PDT)
Date:   Sun, 19 May 2019 10:33:42 -0700 (PDT)
Message-Id: <20190519.103342.860791515386700334.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH -next] net: fix kernel-doc warnings for socket.c
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cf9917f9-740d-4185-49bd-b8872ce2dd61@infradead.org>
References: <cf9917f9-740d-4185-49bd-b8872ce2dd61@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 19 May 2019 10:33:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sat, 18 May 2019 21:23:07 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix kernel-doc warnings by moving the kernel-doc notation to be
> immediately above the functions that it describes.
> 
> Fixes these warnings for sock_sendmsg() and sock_recvmsg():
> 
> ../net/socket.c:658: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
> ../net/socket.c:658: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
> ../net/socket.c:889: warning: Excess function parameter 'sock' description in 'INDIRECT_CALLABLE_DECLARE'
> ../net/socket.c:889: warning: Excess function parameter 'msg' description in 'INDIRECT_CALLABLE_DECLARE'
> ../net/socket.c:889: warning: Excess function parameter 'flags' description in 'INDIRECT_CALLABLE_DECLARE'
> 
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied, thanks Randy.
