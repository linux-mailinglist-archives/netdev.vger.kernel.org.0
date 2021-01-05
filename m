Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 565012EB673
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 00:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726626AbhAEXqh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 18:46:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726018AbhAEXqh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 18:46:37 -0500
Received: from mail.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23CBFC061574
        for <netdev@vger.kernel.org>; Tue,  5 Jan 2021 15:45:57 -0800 (PST)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 7B4B14CE685B6;
        Tue,  5 Jan 2021 15:45:56 -0800 (PST)
Date:   Tue, 05 Jan 2021 15:45:56 -0800 (PST)
Message-Id: <20210105.154556.1677960656687331561.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next 00/16] mlx5 SW steering updates
 2021-01-05
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210105230333.239456-1-saeed@kernel.org>
References: <20210105230333.239456-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Tue, 05 Jan 2021 15:45:56 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeed@kernel.org>
Date: Tue,  5 Jan 2021 15:03:17 -0800

> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Jakub, Dave
> 
> This series introduces some refactoring to SW steering to support
> different formats of different Hardware.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

Pulled, thanks Saeed.
