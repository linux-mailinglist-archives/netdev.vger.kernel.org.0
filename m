Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BC4D3ECAEC
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 23:11:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727176AbfKAWLu convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Fri, 1 Nov 2019 18:11:50 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfKAWLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Nov 2019 18:11:49 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 74C27151B09B4;
        Fri,  1 Nov 2019 15:11:49 -0700 (PDT)
Date:   Fri, 01 Nov 2019 15:11:48 -0700 (PDT)
Message-Id: <20191101.151148.786719507529491521.davem@davemloft.net>
To:     weiwan@google.com
Cc:     netdev@vger.kernel.org, maze@google.com, edumazet@google.com,
        cgallek@google.com
Subject: Re: [PATCH net] selftests: net: reuseport_dualstack: fix
 uninitalized parameter
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191031232436.18481-1-weiwan@google.com>
References: <20191031232436.18481-1-weiwan@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 Nov 2019 15:11:49 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wei Wang <weiwan@google.com>
Date: Thu, 31 Oct 2019 16:24:36 -0700

> This test reports EINVAL for getsockopt(SOL_SOCKET, SO_DOMAIN)
> occasionally due to the uninitialized length parameter.
> Initialize it to fix this, and also use int for "test_family" to comply
> with the API standard.
> 
> Fixes: d6a61f80b871 ("soreuseport: test mixed v4/v6 sockets")
> Reported-by: Maciej ¯enczykowski <maze@google.com>
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Wei Wang <weiwan@google.com>
> Cc: Craig Gallek <cgallek@google.com>

Applied and queued up for -stable.
