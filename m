Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD1822AE403
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 00:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732123AbgKJX1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 18:27:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:38548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726737AbgKJX1o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 18:27:44 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5DEAD20781;
        Tue, 10 Nov 2020 23:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605050863;
        bh=9JAxhUwCHcKvNKu8xDE6U4iis8Ll2RAIZtTP5TsFIyY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Ic6eiDza3igggo/eNg9pZLV5wAo/ZCKsUfacI+N3nbI9gqq6a98byP+EGF5cUX1JN
         ZGx5SNJ0vfkT1VDW8Nc9hH7SfzbYscc/3gCfAXCx1aUQhEIRUPcrFyf2+nwz6DILOk
         Uai6j5R6wb7t4JJIOl0Wk0hqKpEWTXCzW+DlsX24=
Date:   Tue, 10 Nov 2020 15:27:42 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     xiakaixu1987@gmail.com
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kaixu Xia <kaixuxia@tencent.com>
Subject: Re: [PATCH] net: pch_gbe: remove unneeded variable retval in
 __pch_gbe_suspend
Message-ID: <20201110152742.4360b10c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1604837580-12419-1-git-send-email-kaixuxia@tencent.com>
References: <1604837580-12419-1-git-send-email-kaixuxia@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun,  8 Nov 2020 20:13:00 +0800 xiakaixu1987@gmail.com wrote:
> From: Kaixu Xia <kaixuxia@tencent.com>
> 
> Fix the following coccicheck warning:
> 
> ./drivers/net/ethernet/oki-semi/pch_gbe/pch_gbe_main.c:2415:5-11: Unneeded variable: "retval". Return "0" on line 2435
> 
> Reported-by: Tosk Robot <tencent_os_robot@tencent.com>
> Signed-off-by: Kaixu Xia <kaixuxia@tencent.com>

Applied.
