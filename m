Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5C480772
	for <lists+netdev@lfdr.de>; Sat,  3 Aug 2019 19:40:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728143AbfHCRkl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Aug 2019 13:40:41 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:33464 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725886AbfHCRkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Aug 2019 13:40:41 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8C103153F224A;
        Sat,  3 Aug 2019 10:40:40 -0700 (PDT)
Date:   Sat, 03 Aug 2019 10:40:37 -0700 (PDT)
Message-Id: <20190803.104037.2133076011988894606.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next 00/11][pull request] 100GbE Intel Wired LAN Driver
 Updates 2019-08-01
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
References: <20190801222548.15975-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 03 Aug 2019 10:40:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Thu,  1 Aug 2019 15:25:37 -0700

> This series for fm10k, by Jake Keller, reduces the scope of local variables
> where possible.
> 
> The following are changes since commit a8e600e2184f45c40025cbe4d7e8893b69378a9f:
>   Merge branch '100GbE' of git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 100GbE

Pulled, thanks Jeff.
