Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA1CBEC68
	for <lists+netdev@lfdr.de>; Thu, 26 Sep 2019 09:16:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728240AbfIZHQQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Sep 2019 03:16:16 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:44680 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727581AbfIZHQQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Sep 2019 03:16:16 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2C88D12652B51;
        Thu, 26 Sep 2019 00:16:15 -0700 (PDT)
Date:   Thu, 26 Sep 2019 09:16:11 +0200 (CEST)
Message-Id: <20190926.091611.1322777377828408100.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org
Subject: Re: [pull request][net 0/7] Mellanox, mlx5 fixes 2019-09-24
From:   David Miller <davem@davemloft.net>
In-Reply-To: <e54d042319eef6a272c1a3e987a0f8513f0de5b7.camel@mellanox.com>
References: <20190924094047.15915-1-saeedm@mellanox.com>
        <e54d042319eef6a272c1a3e987a0f8513f0de5b7.camel@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Sep 2019 00:16:15 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 24 Sep 2019 09:51:50 +0000

> On Tue, 2019-09-24 at 09:41 +0000, Saeed Mahameed wrote:
>> Hi Dave,
>> 
>> This series introduces some fixes to mlx5 driver.
>> For more information please see tag log below.
>> 
>> Please pull and let me know if there is any problem.
>> 
>> For -stable v4.10:
> 
> correction: 4.20, NOT 4.10.
> 
>>  ('net/mlx5e: Fix traffic duplication in ethtool steering')
>> 
>> For -stable v4.19:
>>  ('net/mlx5: Add device ID of upcoming BlueField-2')
>> 
>> For -stable v5.3:
>>  ('net/mlx5e: Fix matching on tunnel addresses type')

Pulled and queued up for -stable.
