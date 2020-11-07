Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E372AA777
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 19:47:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727305AbgKGSry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 13:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:39276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725836AbgKGSry (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 7 Nov 2020 13:47:54 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 985BB208E4;
        Sat,  7 Nov 2020 18:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604774874;
        bh=aURX1AqxpSLEPMcVzBUkJsifKaH5eZsH0f6fJk6G0MY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aKDrFJ/Ao5sXVvU8A39oF75G/dvFEQloE69wJkqnu5blMs4tBKTXql2JSPeZ0AiYj
         JEu9cIWPQbuWrJfGW32oL73jpIg++Ag1ZfcK8FfAx+37PZzmiylQ6OptPysD8qZPPz
         kz5payywKvTMtinvn1HaSUKl3hFGhnZvEw1H4IH0=
Date:   Sat, 7 Nov 2020 10:47:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: Re: [net-next v4 0/8]net: convert tasklets to use new tasklet_setup
 API
Message-ID: <20201107104752.2113e27a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201103091823.586717-1-allen.lkml@gmail.com>
References: <20201103091823.586717-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 14:48:15 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the net/* drivers to use the new tasklet_setup() API
> 
> The following series is based on net-next (9faebeb2d)

Hi Aleen! I applied everything but the RDS patch to net-next.
Could you resend the RDS one separately and CC linux-rdma,
so we can coordinate who takes it?

Thanks!
