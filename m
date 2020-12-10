Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A9EB2D4FBE
	for <lists+netdev@lfdr.de>; Thu, 10 Dec 2020 01:46:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729990AbgLJApp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 19:45:45 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:53006 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730105AbgLJAod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 19:44:33 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:477:9e51:a893:b0fe:602a])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id CC7644D259C1A;
        Wed,  9 Dec 2020 16:43:45 -0800 (PST)
Date:   Wed, 09 Dec 2020 16:43:45 -0800 (PST)
Message-Id: <20201209.164345.2056928837946293263.davem@davemloft.net>
To:     tariqt@nvidia.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org, moshe@nvidia.com,
        ttoukan.linux@gmail.com
Subject: Re: [PATCH net 0/2] mlx4_en fixes
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20201209130339.21795-1-tariqt@nvidia.com>
References: <20201209130339.21795-1-tariqt@nvidia.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Wed, 09 Dec 2020 16:43:46 -0800 (PST)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tariq Toukan <tariqt@nvidia.com>
Date: Wed,  9 Dec 2020 15:03:37 +0200

> Hi,
> 
> This patchset by Moshe contains fixes to the mlx4 Eth driver,
> addressing issues in restart flow.
> 
> Patch 1 protects the restart task from being rescheduled while active.
>   Please queue for -stable >= v2.6.
> Patch 2 reconstructs SQs stuck in error state, and adds prints for improved
>   debuggability.
>   Please queue for -stable >= v3.12.
> 
Series applied and queued up for -stable, thanks!

