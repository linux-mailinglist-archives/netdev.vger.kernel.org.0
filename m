Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBE62B89A3
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 02:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgKSBfT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 20:35:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:49792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726980AbgKSBfT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 20:35:19 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6EFF9246BC;
        Thu, 19 Nov 2020 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605749718;
        bh=HoiBbmK8bNU9eGyCj2Dk0C382Jib2XukY76pUhA+RW8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=O/cq9I709X6eRPrAeOYGrz07eZ6aE39pHP9vPMV03CMP9f/uGoalRBINUGf79m+OO
         0fXkfeS49+sAQ2cKFtqxhOHZpd0Y4hPDom6aNS3t8rRZ32qFoazzcvqs1Nu1MGsm4b
         XX6jKhHQ7bkU1gXzyoQ3cgJQPqsXKdXJI8AFH/bc=
Date:   Wed, 18 Nov 2020 17:35:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Julian Wiedmann <jwi@linux.ibm.com>
Cc:     David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net-next 0/9] s390/qeth: updates 2020-11-17
Message-ID: <20201118173517.4cfaa900@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117161520.1089-1-jwi@linux.ibm.com>
References: <20201117161520.1089-1-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 17:15:11 +0100 Julian Wiedmann wrote:
> please apply the following patch series for qeth to netdev's net-next tree.
> 
> This brings some cleanups, and a bunch of improvements for our
> .get_link_ksettings() code.

Applied, thanks!
