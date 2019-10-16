Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0379D84B5
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 02:16:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388373AbfJPAQH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 20:16:07 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42166 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388355AbfJPAQG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 20:16:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EAEC911F5F8D0;
        Tue, 15 Oct 2019 17:16:05 -0700 (PDT)
Date:   Tue, 15 Oct 2019 17:16:05 -0700 (PDT)
Message-Id: <20191015.171605.1926923209676909296.davem@davemloft.net>
To:     dcaratti@redhat.com
Cc:     lkp@intel.com, john.hurley@netronome.com, kbuild-all@01.org,
        lorenzo@kernel.org, netdev@vger.kernel.org,
        xiyou.wangcong@gmail.com, simon.horman@netronome.com
Subject: Re: [PATCH net v2 0/2] net/sched: fix wrong behavior of MPLS
 push/pop action
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1570878412.git.dcaratti@redhat.com>
References: <cover.1570878412.git.dcaratti@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 15 Oct 2019 17:16:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>
Date: Sat, 12 Oct 2019 13:55:05 +0200

> this series contains two fixes for TC 'act_mpls', that try to address
> two problems that can be observed configuring simple 'push' / 'pop'
> operations:
> - patch 1/2 avoids dropping non-MPLS packets that pass through the MPLS
>   'pop' action.
> - patch 2/2 fixes corruption of the L2 header that occurs when 'push'
>   or 'pop' actions are configured in TC egress path.
> 
> v2: - change commit message in patch 1/2 to better describe that the
>       patch impacts only TC, thanks to Simon Horman
>     - fix missing documentation of 'mac_len' in patch 2/2

Series applied and queued up for -stable, thanks!
