Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C86332AFB22
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 23:11:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726826AbgKKWL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 17:11:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:57036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgKKWL1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 17:11:27 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 00AC72053B;
        Wed, 11 Nov 2020 22:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605132687;
        bh=IRrx0yMxU87dl/WnhkXv020ovsPo9cy8zhM5txdYQ8w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0QnfohEQtXMP7n8XHRnowjF2sDRWaZm04KKemrf1a3Z75MAJL4JyVxebFKkImFsca
         PQB1LyZGfrKwZyZXChWdSVaSWbgXFpJnVF93UoZKC/yFyeq78qRtXOh69lrcwtbNB3
         +WXQQ/3OUNiwZXy1WrH/fCydcqUKTf+UwCR7Hn/M=
Date:   Wed, 11 Nov 2020 14:11:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     netdev@vger.kernel.org, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next] net: phy: aquantia: do not return an error on
 clearing pending IRQs
Message-ID: <20201111141125.67c62e95@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109154601.3812574-1-ciorneiioana@gmail.com>
References: <20201109154601.3812574-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 17:46:01 +0200 Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> The referenced commit added in .config_intr() the part of code which upon
> configuration of the IRQ state it also clears up any pending IRQ. If
> there were actually pending IRQs, a read on the IRQ status register will
> return something non zero. This should not result in the callback
> returning an error.
> 
> Fix this by returning an error only when the result of the
> phy_read_mmd() is negative.
> 
> Fixes: e11ef96d44f1 ("net: phy: aquantia: remove the use of .ack_interrupt()")
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks!
