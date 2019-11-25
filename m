Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFBA91093EA
	for <lists+netdev@lfdr.de>; Mon, 25 Nov 2019 20:06:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKYTF4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Nov 2019 14:05:56 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53042 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbfKYTFz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Nov 2019 14:05:55 -0500
Received: from localhost (c-73-35-209-67.hsd1.wa.comcast.net [73.35.209.67])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D54471500C677;
        Mon, 25 Nov 2019 11:05:54 -0800 (PST)
Date:   Mon, 25 Nov 2019 11:05:54 -0800 (PST)
Message-Id: <20191125.110554.14941471233332672.davem@davemloft.net>
To:     maowenan@huawei.com
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net v3] net: dsa: ocelot: add dependency for
 NET_DSA_MSCC_FELIX
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191125124110.145595-1-maowenan@huawei.com>
References: <3e9d6100-6965-da85-c310-6e1a9318f61d@huawei.com>
        <20191125124110.145595-1-maowenan@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 25 Nov 2019 11:05:55 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mao Wenan <maowenan@huawei.com>
Date: Mon, 25 Nov 2019 20:41:10 +0800

> +	select NET_VENDOR_MICROSEMI

This is never correct.
