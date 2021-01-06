Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285CA2EB6B4
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 01:08:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbhAFAIE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 19:08:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726694AbhAFAIE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 19:08:04 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54472C061574;
        Tue,  5 Jan 2021 16:07:24 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id C98024CBCE192;
        Tue,  5 Jan 2021 16:07:23 -0800 (PST)
Date:   Tue, 05 Jan 2021 16:07:23 -0800 (PST)
Message-Id: <20210105.160723.1741093527336129717.davem@davemloft.net>
To:     bongsu.jeon2@gmail.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org,
        bongsu.jeon@samsung.com
Subject: Re: [PATCH net-next] net: nfc: nci: Change the NCI close sequence
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201228014631.5557-1-bongsu.jeon@samsung.com>
References: <20201228014631.5557-1-bongsu.jeon@samsung.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 16:07:24 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon2@gmail.com>
Date: Mon, 28 Dec 2020 10:46:31 +0900

> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> Change the NCI close sequence because the NCI Command timer should be
> deleted after flushing the NCI command work queue.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Applied.
