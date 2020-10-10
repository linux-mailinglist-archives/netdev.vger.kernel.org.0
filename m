Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77C91289D19
	for <lists+netdev@lfdr.de>; Sat, 10 Oct 2020 03:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729373AbgJJBec (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 21:34:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:54582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729629AbgJJBUR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 21:20:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 524CF22245;
        Sat, 10 Oct 2020 01:19:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602292794;
        bh=YrMc3cW75J/LfvmPx9H/BurBa7AVKD7Pga4jnVVyAQk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k9PBF/q46m65BeWZ4wAXezJ0rVf+2THdAg1TuJalobz/or/IOu0KisaGxo8m1F2hD
         p/ZFlkb1wRLR0mqSSWT2e4lDI+inGY0/zjKrqbAB4fwkBC8ZmPMg5PfHvhelo5JXFl
         VIohnO1qt12YL1ZsTFltGBzMJu3zItVQPKf1OjQQ=
Date:   Fri, 9 Oct 2020 18:19:52 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, heiko.carstens@de.ibm.com,
        raspl@linux.ibm.com, ubraun@linux.ibm.com
Subject: Re: [PATCH net-next 0/3] net/smc: updates 2020-10-07
Message-ID: <20201009181952.3e607c63@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201007205743.83535-1-kgraul@linux.ibm.com>
References: <20201007205743.83535-1-kgraul@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 22:57:40 +0200 Karsten Graul wrote:
> Please apply the following patch series for smc to netdev's net-next tree.
> 
> Patch 1 and 2 address warnings from static code checkers, and patch 3 handles
> a case when all proposed ISM V2 devices fail to init and no V1 devices are
> tried afterwards.

Applied, thanks!

I'm inducing the last patch is a fix for code only in net-next.
It would still have been better to have a Fixes tag there to make
it clear that there is no need to backport.
