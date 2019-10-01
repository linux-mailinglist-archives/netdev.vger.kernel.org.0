Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D372FC3A28
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 18:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732094AbfJAQQk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 12:16:40 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:49132 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731362AbfJAQQj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 12:16:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 23E94154A807D;
        Tue,  1 Oct 2019 09:16:39 -0700 (PDT)
Date:   Tue, 01 Oct 2019 09:16:38 -0700 (PDT)
Message-Id: <20191001.091638.1225423650064491230.davem@davemloft.net>
To:     pmalani@chromium.org
Cc:     hayeswang@realtek.com, grundler@chromium.org,
        netdev@vger.kernel.org, nic_swsd@realtek.com
Subject: Re: [PATCH net-next] r8152: Factor out OOB link list waits
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191001083556.195271-1-pmalani@chromium.org>
References: <20191001083556.195271-1-pmalani@chromium.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Oct 2019 09:16:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Prashant Malani <pmalani@chromium.org>
Date: Tue,  1 Oct 2019 01:35:57 -0700

> The same for-loop check for the LINK_LIST_READY bit of an OOB_CTRL
> register is used in several places. Factor these out into a single
> function to reduce the lines of code.
> 
> Change-Id: I20e8f327045a72acc0a83e2d145ae2993ab62915
> Signed-off-by: Prashant Malani <pmalani@chromium.org>
> Reviewed-by: Grant Grundler <grundler@chromium.org>

Applied.
