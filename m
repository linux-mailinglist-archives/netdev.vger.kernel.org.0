Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D0DB6751C
	for <lists+netdev@lfdr.de>; Fri, 12 Jul 2019 20:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727053AbfGLSa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Jul 2019 14:30:26 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59858 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726976AbfGLSa0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Jul 2019 14:30:26 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 073B414DE4C10;
        Fri, 12 Jul 2019 11:30:25 -0700 (PDT)
Date:   Fri, 12 Jul 2019 11:30:25 -0700 (PDT)
Message-Id: <20190712.113025.1839861836309622459.davem@davemloft.net>
To:     eric.dumazet@gmail.com
Cc:     ecree@solarflare.com, pabeni@redhat.com, netdev@vger.kernel.org
Subject: Re: [RFC PATCH net-next 0/3] net: batched receive in GRO path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
References: <38ff0ce0-7e26-1683-90f0-adc9c0ac9abe@gmail.com>
        <927da9ee-c2fc-8556-fbeb-e26ea1c98d1e@solarflare.com>
        <d7ca6e7a-b80e-12e8-9050-c25b8b92bf26@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Jul 2019 11:30:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 12 Jul 2019 18:48:29 +0200

> I should have mentioned that we have a patch that I forgot to
> upstream adding the PSH flag to all TSO packets, meaning the
> receiver can automatically learn the boundary of a GRO packet and
> not have to wait for the napi->poll() end (busypolling or not)

Wow, I thought we were already doing this...
