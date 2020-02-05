Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BB0731531AB
	for <lists+netdev@lfdr.de>; Wed,  5 Feb 2020 14:22:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728003AbgBENWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Feb 2020 08:22:01 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:46912 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726748AbgBENWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Feb 2020 08:22:01 -0500
Received: from localhost (unknown [IPv6:2001:982:756:1:57a7:3bfd:5e85:defb])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D514158E30C3;
        Wed,  5 Feb 2020 05:21:59 -0800 (PST)
Date:   Wed, 05 Feb 2020 14:21:58 +0100 (CET)
Message-Id: <20200205.142158.1877672466689439631.davem@davemloft.net>
To:     mdf@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-parisc@vger.kernel.org, mst@redhat.com, hkallweit1@gmail.com,
        morats@google.com
Subject: Re: [PATCH] net: ethernet: dec: tulip: Fix length mask in receive
 length calculation
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200204230118.7877-1-mdf@kernel.org>
References: <20200204230118.7877-1-mdf@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Feb 2020 05:22:00 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>
Date: Tue,  4 Feb 2020 15:01:18 -0800

> The receive frame length calculation uses a wrong mask to calculate the
> length of the received frames.
> 
> Per spec table 4-1 the length is contained in the FL (Frame Length)
> field in bits 30:16.
> 
> This didn't show up as an issue so far since frames were limited to
> 1500 bytes which falls within the 11 bit window.
> 
> Signed-off-by: Moritz Fischer <mdf@kernel.org>

Applied, thanks.
