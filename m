Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285D129CC98
	for <lists+netdev@lfdr.de>; Wed, 28 Oct 2020 00:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1832942AbgJ0XJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Oct 2020 19:09:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2506226AbgJ0XJ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Oct 2020 19:09:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60F4B2068E;
        Tue, 27 Oct 2020 23:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603840198;
        bh=ZNWNqYqYejDWTy+gL9cEOKqlKr3bdhv1AMc2ck2NxcA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VPT2/V9hM2DsUe9g6YfYUPnolYFXJRb4r0gFN9xCakYZnQcRYSE32I2sX+bbBuvhc
         GMPkrcb4xNKOh4TNqL77r+dhyhdT16Kp3MdPen9D9mhHb7UMrCdwT/2jWYy4tBvIPv
         NcM/AT7X1O8M3aBjneZreACnTl+r8O5WFop2UlX8=
Date:   Tue, 27 Oct 2020 16:09:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Xu Wang <vulab@iscas.ac.cn>
Cc:     jdmason@kudzu.us, davem@davemloft.net, jesse.brandeburg@intel.com,
        christophe.jaillet@wanadoo.fr, gustavoars@kernel.org,
        bigeasy@linutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vxge: remove unnecessary cast in kfree()
Message-ID: <20201027160957.3411b469@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201023085533.4792-1-vulab@iscas.ac.cn>
References: <20201023085533.4792-1-vulab@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 16:55:33 +0800 Xu Wang wrote:
> Remove unnecessary cast in the argument to kfree.
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied.
