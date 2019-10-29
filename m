Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A43C7E9354
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:09:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726273AbfJ2XJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:09:20 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:60886 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbfJ2XJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 19:09:19 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 745FF14EBBF64;
        Tue, 29 Oct 2019 16:09:19 -0700 (PDT)
Date:   Tue, 29 Oct 2019 16:09:17 -0700 (PDT)
Message-Id: <20191029.160917.1556007696608724850.davem@davemloft.net>
To:     jeffrey.t.kirsher@intel.com
Cc:     netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com
Subject: Re: [net-next v2 0/9][pull request] 40GbE Intel Wired LAN Driver
 Updates 2019-10-25
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
References: <20191025204242.10535-1-jeffrey.t.kirsher@intel.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 29 Oct 2019 16:09:19 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Date: Fri, 25 Oct 2019 13:42:33 -0700

> This series contains updates to i40e only.  Several are fixes that could
> go to 'net', but were intended for 'net-next'.
 ...
> v2: Dropped patches 2 & 6 from the original series while we wait for the
>     author to respond to community feedback.
> 
> The following are changes since commit 503a64635d5ef7351657c78ad77f8b5ff658d5fc:
>   Merge branch 'DPAA-Ethernet-changes'
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/jkirsher/next-queue 40GbE

Pulled, thanks Jeff.
