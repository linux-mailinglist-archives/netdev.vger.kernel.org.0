Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 061A8123FFC
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 08:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbfLRHDu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 02:03:50 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47672 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725797AbfLRHDu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 02:03:50 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7CCC015038AB5;
        Tue, 17 Dec 2019 23:03:49 -0800 (PST)
Date:   Tue, 17 Dec 2019 23:03:48 -0800 (PST)
Message-Id: <20191217.230348.602638762802229798.davem@davemloft.net>
To:     pdurrant@amazon.com
Cc:     xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next 1/3] xen-netback: move netback_probe() and
 netback_remove() to the end...
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191217133218.27085-2-pdurrant@amazon.com>
References: <20191217133218.27085-1-pdurrant@amazon.com>
        <20191217133218.27085-2-pdurrant@amazon.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 17 Dec 2019 23:03:49 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Paul Durrant <pdurrant@amazon.com>
Date: Tue, 17 Dec 2019 13:32:16 +0000

> ...of xenbus.c
> 
> This is a cosmetic function re-ordering to reduce churn in a subsequent
> patch. Some style fix-up was done to make checkpatch.pl happier.
> 
> No functional change.
> 
> Signed-off-by: Paul Durrant <pdurrant@amazon.com>

Applied.
