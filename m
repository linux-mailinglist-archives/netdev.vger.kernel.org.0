Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C71152B140E
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:57:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgKMB5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:48160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKMB5L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:57:11 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF92920791;
        Fri, 13 Nov 2020 01:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605232631;
        bh=LRg2lj6jbbMdphRy5vdF/YlAglvqJJNU4OqmV7GUGfE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wo2L+k8pMrW0JalZ4MWOH3GI0Kh/n8ncJUSbKEi1g+E9wdgr3ozRZ/Jj3WJNoPC7P
         TE4D7GekBgxWwmac3tunQIPcoH8jI0pHX4FgpYjE2a5/jeuexjXbNAbYkpRUJ+ZvLl
         Q5Szec2gJXNRF81tMXDWGXDwa3H2bYtIFj47Gq9U=
Date:   Thu, 12 Nov 2020 17:57:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon@samsung.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] nfc: s3fwrn82: Add driver for Samsung S3FWRN82
 NFC Chip
Message-ID: <20201112175709.01c0aabe@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6@epcms2p5>
References: <CGME20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6@epcms2p5>
        <20201113014730epcms2p56b287dd23181ba4c0362ca1cb3d0a5b6@epcms2p5>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 10:47:30 +0900 Bongsu Jeon wrote:
> Add driver for Samsung S3FWRN82 NFC controller.
> S3FWRN82 is using NCI protocol and I2C communication interface.
> 
> Signed-off-by: bongsujeon <bongsu.jeon@samsung.com>

I think you've only read my first review comment, there is more
comments inline in my reply.
