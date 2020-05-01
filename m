Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E3C1C0B79
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 03:07:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728012AbgEABHd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 21:07:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727114AbgEABHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 21:07:32 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0DE5C035494;
        Thu, 30 Apr 2020 18:07:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7BDFB1274E639;
        Thu, 30 Apr 2020 18:07:32 -0700 (PDT)
Date:   Thu, 30 Apr 2020 18:07:31 -0700 (PDT)
Message-Id: <20200430.180731.770344471291969154.davem@davemloft.net>
To:     pablo@netfilter.org
Cc:     netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/2] Netfilter fixes for net
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429214811.19941-1-pablo@netfilter.org>
References: <20200429214811.19941-1-pablo@netfilter.org>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 18:07:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Wed, 29 Apr 2020 23:48:09 +0200

> The following patchset contains Netfilter fixes for net:
> 
> 1) Do not update the UDP checksum when it's zero, from Guillaume Nault.
> 
> 2) Fix return of local variable in nf_osf, from Arnd Bergmann.
> 
> You can pull these changes from:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/pablo/nf.git

Pulled, thanks Pablo.
