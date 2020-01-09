Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2FF1513609F
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 19:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388657AbgAIS6w (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 13:58:52 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:57114 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729054AbgAIS6v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 13:58:51 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2305615841E92;
        Thu,  9 Jan 2020 10:58:50 -0800 (PST)
Date:   Thu, 09 Jan 2020 10:58:49 -0800 (PST)
Message-Id: <20200109.105849.1926189565071852143.davem@davemloft.net>
To:     amaftei@solarflare.com
Cc:     netdev@vger.kernel.org, linux-net-drivers@solarflare.com,
        scrum-linux@solarflare.com
Subject: Re: [PATCH net-next 0/9] sfc: more code refactoring
From:   David Miller <davem@davemloft.net>
In-Reply-To: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
References: <4d915542-3699-e864-5558-bef616b2fe66@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jan 2020 10:58:50 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Alex Maftei (amaftei)" <amaftei@solarflare.com>
Date: Thu, 9 Jan 2020 15:41:43 +0000

> Splitting more of the driver code into different files, which will
> later be used in another driver for a new product.
> 
> This is a continuation to my previous patch series.
> There will be another series and a stand-alone patch as well
> after this.
> 
> This series in particular covers MCDI (management controller
> driver interface) code.

Series applied, thanks.
