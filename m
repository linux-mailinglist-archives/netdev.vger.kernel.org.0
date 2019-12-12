Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CBBE11D639
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 19:50:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730580AbfLLSuA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 13:50:00 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:42564 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730261AbfLLSuA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 13:50:00 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4215A153DCA8A;
        Thu, 12 Dec 2019 10:49:59 -0800 (PST)
Date:   Thu, 12 Dec 2019 10:49:56 -0800 (PST)
Message-Id: <20191212.104956.2134616389786003650.davem@davemloft.net>
To:     gomonovych@gmail.com
Cc:     jeffrey.t.kirsher@intel.com, intel-wired-lan@lists.osuosl.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] igb: index regs_buff array via index variable
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191212105847.16488-1-gomonovych@gmail.com>
References: <20191212105847.16488-1-gomonovych@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 12 Dec 2019 10:49:59 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasyl Gomonovych <gomonovych@gmail.com>
Date: Thu, 12 Dec 2019 11:58:47 +0100

> This patch is just a preparation for additional register dump in regs_buff.
> To make new register insertion in the middle of regs_buff array easier
> change array indexing to use local counter reg_ix.
> 
> ---
> 
> Basically this path is just a subject to ask
> How to add a new register to dump from dataseet
> Because it is logically better to add an additional register
> in the middle of an array but that will break ABI.
> To not have the ABI problem we should just add it at the
> end of the array and increase the array size.
> 
> ---
> 
> Signed-off-by: Vasyl Gomonovych <gomonovych@gmail.com>

Anything you put after "---" will be removed by git if someone actually
applies this patch, which means your signoff will disappear.
