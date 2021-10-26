Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BF143BC20
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 23:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239451AbhJZVPb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 17:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:49152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239448AbhJZVPa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 17:15:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 57D2460F6F;
        Tue, 26 Oct 2021 21:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635282786;
        bh=+jmG9XO6hSfOulSZuaNDujGZZVWsPUvr+tpEmoemAp0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=umfN9I7gEdn7q4XmNQOJ6M4RL8mqWpFGCDzmu/KLfvrGl079g9YLXS0y0dszJtoXl
         3tV+/iiop2fp7TpzGdpzld6fkUXOoxusKcy/SpDWHpmE+OzFkfx+qsHXKo0v/R6xH+
         GB/72UuW/wakivWzs5/zWl3hkbKMcXIXC3+OZ+9mH5kxFK6yDvlc0DsoDa8tZyQ+E5
         aCIoOTwtSXH8ilqR9qoUEgbXx0/7O/jtytNhw1FRJ8EIz5wQOAAC5JF3JPjVtO0iEr
         oKgFVzAGnMC7R7A7Ya2sqRmN0guscK0TsHZFBNevXcJHllR9GAnc1/uW5u5odUUs3q
         KEsQ2MkKVTUPA==
Date:   Tue, 26 Oct 2021 14:13:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu <rsaladi2@marvell.com>
Cc:     <sgoutham@marvell.com>, <gakula@marvell.com>,
        <sbhatta@marvell.com>, <hkelam@marvell.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [net-next PATCH v2 1/3] octeontx2-af: debugfs: Minor changes.
Message-ID: <20211026141305.0739a59e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211026121814.27036-2-rsaladi2@marvell.com>
References: <20211026121814.27036-1-rsaladi2@marvell.com>
        <20211026121814.27036-2-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 17:48:12 +0530 Rakesh Babu wrote:
> This patch also has the null pointer check in rvu_nix.c file.

You need to explain why, and why is that not a fix, just a cosmetic
change. Same for the ret < 0 check. And please break those out to
separate patches.
