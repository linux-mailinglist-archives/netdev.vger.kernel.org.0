Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A1E2AE631
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 03:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbgKKCMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 21:12:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726861AbgKKCMH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 21:12:07 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B56621D91;
        Wed, 11 Nov 2020 02:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605060726;
        bh=0f0NXqOkTRsaaUfxpZORvgRcgdrcHQrib07uSFQ/VEU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EymgoN1q0I9usJ0xbVomPO5Jasf9qODxgUPha7sAu7muUUaaopSUzXrMcs7hMW4C7
         x432pvcW4Fd6q9x2lDnjHcrx/yh1GLaR+Q/Gh3EvMU9DVbNtXLNnUUcVQcSuJEnmov
         b27FoKbriap21tIhm8fH1IsDEpm+usyO8tc0oklw=
Date:   Tue, 10 Nov 2020 18:12:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ursula Braun <ubraun@linux.ibm.com>
Cc:     Julian Wiedmann <jwi@linux.ibm.com>,
        David Miller <davem@davemloft.net>,
        linux-netdev <netdev@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <hca@linux.ibm.com>,
        Karsten Graul <kgraul@linux.ibm.com>
Subject: Re: [PATCH net v2 2/2] MAINTAINERS: remove Ursula Braun as s390
 network maintainer
Message-ID: <20201110181205.40f01ca0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201109075706.56573-3-jwi@linux.ibm.com>
References: <20201109075706.56573-1-jwi@linux.ibm.com>
        <20201109075706.56573-3-jwi@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  9 Nov 2020 08:57:06 +0100 Julian Wiedmann wrote:
> From: Ursula Braun <ubraun@linux.ibm.com>
> 
> I am retiring soon. Thus this patch removes myself from the
> MAINTAINERS file (s390 network).

Thanks for all the work over the years! :)
