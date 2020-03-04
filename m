Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43069179A64
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 21:49:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387469AbgCDUtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 15:49:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:41354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728482AbgCDUtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 15:49:20 -0500
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A65A9207FD;
        Wed,  4 Mar 2020 20:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583354959;
        bh=g6jmeMLYsKWmDrxS+WXXbBjRl3Lw3BSlyyvzWzF3eNM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JVh8bJWwld8SB44MgE20h9i8xC6o6LJq6IQ52j4JuQgt7w2B1MRpjN36Vbrac3/hi
         soiMjWmDoAGMGg1usOYMKcGd8IWCIP1+UkkfL54CYskZYcd93BLAPBqUn8YO9RMdEy
         uztmt2A8FOGoEHzqBEFLGWdh22Vk/RyrblH+WinI=
Date:   Wed, 4 Mar 2020 12:49:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leslie Monis <lesliemonis@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, tahiliani@nitk.edu.in,
        gautamramk@gmail.com
Subject: Re: [PATCH net-next v2 0/4] pie: minor improvements
Message-ID: <20200304124917.0fbba371@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200304185602.2540-1-lesliemonis@gmail.com>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  5 Mar 2020 00:25:58 +0530 Leslie Monis wrote:
> This patch series includes the following minor changes with
> respect to the PIE/FQ-PIE qdiscs:
> 
>  - Patch 1 removes some ambiguity by using the term "backlog"
>            instead of "qlen" when referring to the queue length
>            in bytes.
>  - Patch 2 removes redundant type casting on two expressions.
>  - Patch 3 removes the pie_vars->accu_prob_overflows variable
>            without affecting the precision in calculations and
>            makes the size of the pie_vars structure exactly 64
>            bytes.
>  - Patch 4 realigns a comment affected by a change in patch 3.
> 
> Changes from v1 to v2:
>  - Kept 8 as the argument to prandom_bytes() instead of changing it
>    to 7 as suggested by David Miller.

I was wondering if patch 3 changes make user-visible changes but it
seems those should be only slight accuracy adjustments, so LGTM. FWIW:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
