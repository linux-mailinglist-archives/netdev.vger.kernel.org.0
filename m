Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D97051082A
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 15:13:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfEANNL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 09:13:11 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60610 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725993AbfEANNL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 09:13:11 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6509146D4339;
        Wed,  1 May 2019 06:13:09 -0700 (PDT)
Date:   Wed, 01 May 2019 09:13:06 -0400 (EDT)
Message-Id: <20190501.091306.361777656290214405.davem@davemloft.net>
To:     rdunlap@infradead.org
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com
Subject: Re: [PATCH -net] Documentation: fix netdev-FAQ.rst markup warning
From:   David Miller <davem@davemloft.net>
In-Reply-To: <eabf639b-0e35-4758-a4ad-b78e85a3eb0f@infradead.org>
References: <eabf639b-0e35-4758-a4ad-b78e85a3eb0f@infradead.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 06:13:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>
Date: Sun, 28 Apr 2019 18:10:39 -0700

> From: Randy Dunlap <rdunlap@infradead.org>
> 
> Fix ReST underline warning:
> 
> ./Documentation/networking/netdev-FAQ.rst:135: WARNING: Title underline too short.
> 
> Q: I made changes to only a few patches in a patch series should I resend only those changed?
> --------------------------------------------------------------------------------------------
> 
> 
> Fixes: ffa91253739c ("Documentation: networking: Update netdev-FAQ regarding patches")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>

Applied.
