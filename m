Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7F020288D00
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:44:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389303AbgJIPoY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:44:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:47846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388696AbgJIPoY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:44:24 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A202225D;
        Fri,  9 Oct 2020 15:44:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602258263;
        bh=Q3DjcFi9LMb3yF8Yma33wRbWfhQokYReKSSBcGWnnKI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Kxk03/ZrAvdRv8hon9zMUltgro7feAhJasDvinmxcXkQaUrqAwKLOwD+/axQBhFI2
         T7AKd54yhH3ZbKNaJr/0pa0O8NsLAa/7G3AikgrfDF0Qkt2fqXhXyE44pAdD6MrCuO
         hYQ4hUi5qnfimFZ7yXnHpoU2BGply++1hWkJ3s+0=
Date:   Fri, 9 Oct 2020 08:44:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Allen Pais <allen.lkml@gmail.com>
Cc:     davem@davemloft.net, gerrit@erg.abdn.ac.uk, edumazet@google.com,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        johannes@sipsolutions.net, alex.aring@gmail.com,
        stefan@datenfreihafen.org, santosh.shilimkar@oracle.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, Allen Pais <apais@linux.microsoft.com>
Subject: Re: [net-next v2 0/8] net: convert tasklets to use new
Message-ID: <20201009084421.651689e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007101219.356499-1-allen.lkml@gmail.com>
References: <20201007101219.356499-1-allen.lkml@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 15:42:11 +0530 Allen Pais wrote:
> From: Allen Pais <apais@linux.microsoft.com>
> 
> Commit 12cc923f1ccc ("tasklet: Introduce new initialization API")'
> introduced a new tasklet initialization API. This series converts
> all the net/* drivers to use the new tasklet_setup() API
> 
> The following series is based on net-next (9faebeb2d)
> 
> v1:
>   fix kerneldoc

Please respin, Eric's patch is in net-next now.

FWIW looks like both of your series for net-next had the subject of the
cover letter cut off.
