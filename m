Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96F4A1A16A5
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 22:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbgDGUTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 16:19:13 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:41622 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726712AbgDGUTN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 16:19:13 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id C47DA1210A3E3;
        Tue,  7 Apr 2020 13:19:12 -0700 (PDT)
Date:   Tue, 07 Apr 2020 13:19:11 -0700 (PDT)
Message-Id: <20200407.131911.2253144379787989145.davem@davemloft.net>
To:     leon@kernel.org
Cc:     ka-cheong.poon@oracle.com, netdev@vger.kernel.org,
        santosh.shilimkar@oracle.com, rds-devel@oss.oracle.com,
        sironhide0null@gmail.com
Subject: Re: [PATCH net 1/2] net/rds: Replace direct refcount_inc() by
 inline function
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200407184809.GP80989@unreal>
References: <4b96ea99c3f0ccd5cc0683a5c944a1c4da41cc38.1586275373.git.ka-cheong.poon@oracle.com>
        <20200407184809.GP80989@unreal>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Apr 2020 13:19:13 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Leon Romanovsky <leon@kernel.org>
Date: Tue, 7 Apr 2020 21:48:09 +0300

> On Tue, Apr 07, 2020 at 09:08:01AM -0700, Ka-Cheong Poon wrote:
>> Added rds_ib_dev_get() and rds_mr_get() to improve code readability.
> 
> It is very hard to agree with this sentence.
> Hiding basic kernel primitives is very rare will improve code readability.
> It is definitely not the case here.

I completely agree.
