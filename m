Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DBE21C92CC
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 16:59:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727067AbgEGO7I convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 7 May 2020 10:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725985AbgEGO7I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 10:59:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1465C05BD43
        for <netdev@vger.kernel.org>; Thu,  7 May 2020 07:59:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5CBF015C85DA1;
        Thu,  7 May 2020 07:59:08 -0700 (PDT)
Date:   Thu, 07 May 2020 07:59:07 -0700 (PDT)
Message-Id: <20200507.075907.1635197587647645577.davem@davemloft.net>
To:     zenczykowski@gmail.com
Cc:     maze@google.com, netdev@vger.kernel.org
Subject: Re: [PATCH] net: remove spurious declaration of
 tcp_default_init_rwnd()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200507075805.4831-1-zenczykowski@gmail.com>
References: <20200507075805.4831-1-zenczykowski@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-2
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 07:59:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej ¯enczykowski <zenczykowski@gmail.com>
Date: Thu,  7 May 2020 00:58:05 -0700

> From: Maciej ¯enczykowski <maze@google.com>
> 
> it doesn't actually exist...
> 
> Test: builds and 'git grep tcp_default_init_rwnd' comes up empty
> Signed-off-by: Maciej ¯enczykowski <maze@google.com>

Applied, thank you.
