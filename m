Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 507D11D3EC1
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 22:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727900AbgENUMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 16:12:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727827AbgENUMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 16:12:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D477EC061A0C;
        Thu, 14 May 2020 13:12:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 745A5128D5B94;
        Thu, 14 May 2020 13:12:30 -0700 (PDT)
Date:   Thu, 14 May 2020 13:12:29 -0700 (PDT)
Message-Id: <20200514.131229.1854195473777943633.davem@davemloft.net>
To:     ubraun@linux.ibm.com
Cc:     netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        heiko.carstens@de.ibm.com, kgraul@linux.ibm.com
Subject: Re: [PATCH net 1/1] MAINTAINERS: another add of Karsten Graul for
 S390 networking
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200514114512.101771-1-ubraun@linux.ibm.com>
References: <20200514114512.101771-1-ubraun@linux.ibm.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 14 May 2020 13:12:30 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ursula Braun <ubraun@linux.ibm.com>
Date: Thu, 14 May 2020 13:45:12 +0200

> Complete adding of Karsten as maintainer for all S390 networking
> parts in the kernel.
> 
> Cc: Julian Wiedmann <jwi@linux.ibm.com>
> Acked-by: Julian Wiedmann <jwi@linux.ibm.com>
> Signed-off-by: Ursula Braun <ubraun@linux.ibm.com>

Applied, thanks.
