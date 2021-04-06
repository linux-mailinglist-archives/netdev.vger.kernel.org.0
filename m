Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35660355BC6
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 20:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236996AbhDFSyw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 14:54:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240567AbhDFSyL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 14:54:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F02E6128A;
        Tue,  6 Apr 2021 18:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617735243;
        bh=gTXBArHDHmSIeLqmt58KO+JpgBcYSDf6+tvFLMK/JG8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mf9jFgg1SqyGJSd8CYMR7SSSN9tfSHyyyak6obmSwKkS9v53LOrFZOjIQZYHpRBen
         IUHGSrRYfZIXV1erYDHJaXX6xn+FnSUQbk/mBYe+ncoYZspwKEMPMU3uK3xWUecGkQ
         5hfYWo+mebzIJxK6J2clr9bTBlZ54qv2WPSgF3KdGGOdiSI+X71xhC6ZcI80fBmwip
         d5pKfxpb/qrIb7HKvKAIuAUFUm7znvjh3uBf35WNEX0E/2yNXOfkkLePV6VyPGb7uB
         T8bSFMxlAs6PK7BYY80GRuBbLDbXhRffHUNH4EFUfRYyuUHLYVI2iKuSk86o4NO1mL
         jDBkfmsOoh78A==
Date:   Tue, 6 Apr 2021 11:54:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wong Vee Khee <vee.khee.wong@linux.intel.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH net v1 1/1] ethtool: fix incorrect datatype in set_eee
 ops
Message-ID: <20210406115402.373ba332@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
References: <20210406131730.25404-1-vee.khee.wong@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Apr 2021 21:17:30 +0800 Wong Vee Khee wrote:
> The member 'tx_lpi_timer' is defined with __u32 datatype in the ethtool
> header file. Hence, we should use ethnl_update_u32() in set_eee ops.
> 
> Fixes: fd77be7bd43c ("ethtool: set EEE settings with EEE_SET request")
> Cc: <stable@vger.kernel.org> # 5.10.x
> Cc: Michal Kubecek <mkubecek@suse.cz>
> Signed-off-by: Wong Vee Khee <vee.khee.wong@linux.intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
