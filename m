Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE84D13B7F1
	for <lists+netdev@lfdr.de>; Wed, 15 Jan 2020 03:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728905AbgAOCor (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jan 2020 21:44:47 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:51694 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728862AbgAOCor (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jan 2020 21:44:47 -0500
Received: from localhost (unknown [8.46.75.2])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 25338158099BF;
        Tue, 14 Jan 2020 18:44:34 -0800 (PST)
Date:   Tue, 14 Jan 2020 18:44:27 -0800 (PST)
Message-Id: <20200114.184427.389937353174651227.davem@davemloft.net>
To:     johan@kernel.org
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, hayeswang@realtek.com
Subject: Re: [PATCH] r8152: add missing endpoint sanity check
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200114082729.24063-1-johan@kernel.org>
References: <20200114082729.24063-1-johan@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 14 Jan 2020 18:44:46 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Johan Hovold <johan@kernel.org>
Date: Tue, 14 Jan 2020 09:27:29 +0100

> Add missing endpoint sanity check to probe in order to prevent a
> NULL-pointer dereference (or slab out-of-bounds access) when retrieving
> the interrupt-endpoint bInterval on ndo_open() in case a device lacks
> the expected endpoints.
> 
> Fixes: 40a82917b1d3 ("net/usb/r8152: enable interrupt transfer")
> Cc: hayeswang <hayeswang@realtek.com>
> Signed-off-by: Johan Hovold <johan@kernel.org>

Applied and queued up for -stable, thank you.
