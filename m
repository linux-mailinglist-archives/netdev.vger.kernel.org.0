Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4C422BBC87
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:05:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbgKUDDk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:03:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:52450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725785AbgKUDDj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:03:39 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45972223FD;
        Sat, 21 Nov 2020 03:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605927819;
        bh=mrM4Gugrlpa2bnssw1SCVzGj1JzWL3uov9Ec+7IOQVc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yLoRFwIRJvq68jxigwle4dd9GzGZykFl6j2+3/EeubUYUW+QakdM0ybKRxjGeDuYF
         O+Uz69+/VdiIJzM7cEjkASo3q4tamHkusB2WZe3MS4d1pqKO+X7eiq95Ph7o32jClv
         unjYrS6Eof8AicfZZHhCr3QShs1ZXvN9e6Gs9c8Q=
Date:   Fri, 20 Nov 2020 19:03:38 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net 0/4] s390/qeth: fixes 2020-11-20
Message-ID: <20201120190338.2ca6153c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201120090939.101406-1-jwi@linux.ibm.com>
References: <20201120090939.101406-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 10:09:35 +0100 Julian Wiedmann wrote:
> please apply the following patch series to netdev's net tree.
> 
> This brings several fixes for qeth's af_iucv-specific code paths.
> 
> Also one fix by Alexandra for the recently added BR_LEARNING_SYNC
> support. We want to trust the feature indication bit, so that HW can
> mask it out if there's any issues on their end.

Applied, thank you!
