Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 741C33D1B5
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 18:06:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391217AbfFKQGY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 12:06:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:47534 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390214AbfFKQGY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 12:06:24 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A58E215252E21;
        Tue, 11 Jun 2019 09:06:23 -0700 (PDT)
Date:   Tue, 11 Jun 2019 09:06:23 -0700 (PDT)
Message-Id: <20190611.090623.1410739893357351709.davem@davemloft.net>
To:     nhorman@tuxdriver.com
Cc:     linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        marcelo.leitner@gmail.com, lucien.xin@gmail.com
Subject: Re: [PATCH v2] [net] Free cookie before we memdup a new one
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190611112128.27057-1-nhorman@tuxdriver.com>
References: <20190610163456.7778-1-nhorman@tuxdriver.com>
        <20190611112128.27057-1-nhorman@tuxdriver.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Jun 2019 09:06:23 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Neil Horman <nhorman@tuxdriver.com>
Date: Tue, 11 Jun 2019 07:21:28 -0400

> Based on comments from Xin, even after fixes for our recent syzbot
> report of cookie memory leaks, its possible to get a resend of an INIT
> chunk which would lead to us leaking cookie memory.
> 
> To ensure that we don't leak cookie memory, free any previously
> allocated cookie first.
> 
> ---
> Change notes
> v1->v2
> update subsystem tag in subject (davem)

Subsystem tag is "sctp: " which still isn't there :-)
