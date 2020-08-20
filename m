Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F299424C861
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 01:18:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728714AbgHTXSs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Aug 2020 19:18:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728498AbgHTXSq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Aug 2020 19:18:46 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98DC3C061385;
        Thu, 20 Aug 2020 16:18:46 -0700 (PDT)
Received: from localhost (c-76-104-128-192.hsd1.wa.comcast.net [76.104.128.192])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E0C6F12875E6C;
        Thu, 20 Aug 2020 16:01:59 -0700 (PDT)
Date:   Thu, 20 Aug 2020 16:18:44 -0700 (PDT)
Message-Id: <20200820.161844.351760970892591961.davem@davemloft.net>
To:     alex.dewar90@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] nfc: st-nci: Remove unnecessary cast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200820183301.902460-1-alex.dewar90@gmail.com>
References: <20200820183301.902460-1-alex.dewar90@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 20 Aug 2020 16:02:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Alex Dewar <alex.dewar90@gmail.com>
Date: Thu, 20 Aug 2020 19:32:58 +0100

> In st_nci_hci_connectivity_event_received(), the return value of
> devm_kzalloc() is unnecessarily cast from void*. Remove cast.
> 
> Issue identified with Coccinelle.
> 
> Signed-off-by: Alex Dewar <alex.dewar90@gmail.com>

Applied.
