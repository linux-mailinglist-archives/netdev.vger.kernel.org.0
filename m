Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5354CE7D13
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 00:37:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731593AbfJ1XhF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Oct 2019 19:37:05 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46714 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726834AbfJ1XhF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Oct 2019 19:37:05 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A830C14BF2022;
        Mon, 28 Oct 2019 16:37:04 -0700 (PDT)
Date:   Mon, 28 Oct 2019 16:37:04 -0700 (PDT)
Message-Id: <20191028.163704.2148236844456016931.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] mlxsw: spectrum_buffers: remove unneeded
 semicolon
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025090948.13668-1-yuehaibing@huawei.com>
References: <20191025090948.13668-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Oct 2019 16:37:04 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: YueHaibing <yuehaibing@huawei.com>
Date: Fri, 25 Oct 2019 17:09:48 +0800

> Remove excess semicolon after closing parenthesis.
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Applied.
