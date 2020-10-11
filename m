Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2240828A8E8
	for <lists+netdev@lfdr.de>; Sun, 11 Oct 2020 19:59:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730583AbgJKR7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Oct 2020 13:59:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:50578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730562AbgJKR7h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Oct 2020 13:59:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 337F22222A;
        Sun, 11 Oct 2020 17:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602439176;
        bh=kpHPm3b0x7774/V3XF7AlNsW2/7DQu7ykW7w2QiUHmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X/9CsasW2yL1pDtbweT1nLYwhP/IWANFFTYZLgSlQLC9spG79Z0kOx81/ozKTmB8j
         jCEwZevWT/u4sqWInkWxOEy+mK6obAoprAAAuo2t66AGRdZ0w6kZHolfC2gb+B8bNa
         Nk3po15C7XSE86KlKYuXKZp2UYn9AzvLNtPoyd2g=
Date:   Sun, 11 Oct 2020 10:59:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Anant Thazhemadam <anant.thazhemadam@gmail.com>
Cc:     petkan@nucleusys.com, davem@davemloft.net,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-next@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH v2] net: usb: rtl8150: don't incorrectly assign random
 MAC addresses
Message-ID: <20201011105934.5c988cd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201011173030.141582-1-anant.thazhemadam@gmail.com>
References: <20201010064459.6563-1-anant.thazhemadam@gmail.com>
        <20201011173030.141582-1-anant.thazhemadam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 11 Oct 2020 23:00:30 +0530 Anant Thazhemadam wrote:
> In set_ethernet_addr(), if get_registers() succeeds, the ethernet address
> that was read must be copied over. Otherwise, a random ethernet address
> must be assigned.
> 
> get_registers() returns 0 if successful, and negative error number
> otherwise. However, in set_ethernet_addr(), this return value is
> incorrectly checked.
> 
> Since this return value will never be equal to sizeof(node_id), a
> random MAC address will always be generated and assigned to the
> device; even in cases when get_registers() is successful.
> 
> Correctly modifying the condition that checks if get_registers() was
> successful or not fixes this problem, and copies the ethernet address
> appropriately.
> 
> Fixes: f45a4248ea4c ("net: usb: rtl8150: set random MAC address when set_ethernet_addr() fails")
> Signed-off-by: Anant Thazhemadam <anant.thazhemadam@gmail.com>

This patch is a fix to a conflict resolution in linux-next.

linux-next is not a "real" tree, it's an integration tree used to
figure out conflicts early.

We had let Stephen know about the problem already. Please wait one
week, and if the problem is still present resend this.

Thank you.
