Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F518883BF
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 22:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726457AbfHIURP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 16:17:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37432 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725860AbfHIURP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 16:17:15 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7F3F414511F69;
        Fri,  9 Aug 2019 13:17:14 -0700 (PDT)
Date:   Fri, 09 Aug 2019 13:17:14 -0700 (PDT)
Message-Id: <20190809.131714.21657168204830538.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     ap420073@gmail.com, netdev@vger.kernel.org, nhorman@redhat.com,
        sassmann@redhat.com, andrewx.bowers@intel.com
Subject: Re: [net v2] ixgbe: fix possible deadlock in ixgbe_service_task()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190808163756.8753-1-jeffrey.t.kirsher@intel.com>
References: <20190808163756.8753-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 09 Aug 2019 13:17:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  8 Aug 2019 09:37:56 -0700

> From: Taehee Yoo <ap420073@gmail.com>
> 
> ixgbe_service_task() calls unregister_netdev() under rtnl_lock().
> But unregister_netdev() internally calls rtnl_lock().
> So deadlock would occur.
> 
> Fixes: 59dd45d550c5 ("ixgbe: firmware recovery mode")
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
> ---
> v2: removed unnecessary curly brackets

Applied, thanks everyone.
