Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37BFF1376E9
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 20:24:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728492AbgAJTYx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 14:24:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39896 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728381AbgAJTYx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 14:24:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 695EE1577D948;
        Fri, 10 Jan 2020 11:24:52 -0800 (PST)
Date:   Fri, 10 Jan 2020 11:24:51 -0800 (PST)
Message-Id: <20200110.112451.2073113610881067233.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH net-next 0/9] sfc: even more code refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
References: <95eb1347-0b8d-b8f7-3f32-cc4006a88303@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Jan 2020 11:24:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Fri, 10 Jan 2020 13:25:22 +0000

> Splitting even more of the driver code into different files, which
> will later be used in another driver for a new product.
> 
> This is a continuation to my previous patch series, and the one
> before it.
> There will be a stand-alone patch as well after this - after which
> the refactoring will be concluded, for now.

Series applied, thank you.
