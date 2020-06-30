Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0AC20FD71
	for <lists+netdev@lfdr.de>; Tue, 30 Jun 2020 22:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729234AbgF3UJ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Jun 2020 16:09:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgF3UJ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Jun 2020 16:09:26 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9204C061755
        for <netdev@vger.kernel.org>; Tue, 30 Jun 2020 13:09:25 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 610BD1276FC5C;
        Tue, 30 Jun 2020 13:09:25 -0700 (PDT)
Date:   Tue, 30 Jun 2020 13:09:23 -0700 (PDT)
Message-Id: <20200630.130923.402514193016248355.davem@davemloft.net>
To:     ecree@solarflare.com
Cc:     linux-net-drivers@solarflare.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/14] sfc: prerequisites for EF100 driver,
 part 2
From:   David Miller <davem@davemloft.net>
In-Reply-To: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
References: <14a93b71-3d4e-4663-82be-a2281cd1105e@solarflare.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Jun 2020 13:09:25 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Edward Cree <ecree@solarflare.com>
Date: Tue, 30 Jun 2020 13:00:18 +0100

> Continuing on from [1], this series further prepares the sfc codebase
>  for the introduction of the EF100 driver.
> 
> [1]: https://lore.kernel.org/netdev/20200629.173812.1532344417590172093.davem@davemloft.net/T/

Series applied, thank you.
