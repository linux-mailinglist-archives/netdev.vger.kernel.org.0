Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E89E914AE93
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 05:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgA1EFY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 23:05:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726191AbgA1EFX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 23:05:23 -0500
Received: from cakuba (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0010C2173E;
        Tue, 28 Jan 2020 04:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580184323;
        bh=fpVkEgj5XojtInMJQc7EHSKL9y5sM7zJXM/u8UZYXTA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=taiw4PAn6Sm4GwohdhOApt28v6P6fUL09nnLzwkH0J9zfKYhFHuaoJhagOqDy6xZ2
         TCX5rT2hLo7m9/0xp6c736APXCFKZWu3GwrxLqP0GdXEru5CuDzEU02scgI05Hdb1A
         eW6yXkVfq89mB2wDe9opg7TkGKcJ+zTkhLeljeOI=
Date:   Mon, 27 Jan 2020 20:05:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net v2 5/6] netdevsim: use __GFP_NOWARN to avoid
 memalloc warning
Message-ID: <20200127200522.3bff7eb6@cakuba>
In-Reply-To: <20200127143053.1550-1-ap420073@gmail.com>
References: <20200127143053.1550-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 27 Jan 2020 14:30:53 +0000, Taehee Yoo wrote:
> vfnum buffer size and binary_len buffer size is received by user-space.
> So, this buffer size could be too large. If so, kmalloc will internally
> print a warning message.
> This warning message is actually not necessary for the netdevsim module.
> So, this patch adds __GFP_NOWARN.

> Fixes: 79579220566c ("netdevsim: add SR-IOV functionality")
> Fixes: 82c93a87bf8b ("netdevsim: implement couple of testing devlink health reporters")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
