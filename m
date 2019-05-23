Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3507327552
	for <lists+netdev@lfdr.de>; Thu, 23 May 2019 07:09:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726359AbfEWFIs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 May 2019 01:08:48 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39660 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725786AbfEWFIs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 May 2019 01:08:48 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D1C761504E004;
        Wed, 22 May 2019 22:08:47 -0700 (PDT)
Date:   Wed, 22 May 2019 22:08:45 -0700 (PDT)
Message-Id: <20190522.220845.1986810713768336903.davem@davemloft.net>
To:     edumazet@google.com
Cc:     netdev@vger.kernel.org, eric.dumazet@gmail.com, lkp@intel.com
Subject: Re: [PATCH net] ipv4/igmp: fix build error if !CONFIG_IP_MULTICAST
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190523013516.132053-1-edumazet@google.com>
References: <20190523013516.132053-1-edumazet@google.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 22 May 2019 22:08:48 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>
Date: Wed, 22 May 2019 18:35:16 -0700

> ip_sf_list_clear_all() needs to be defined even if !CONFIG_IP_MULTICAST
> 
> Fixes: 3580d04aa674 ("ipv4/igmp: fix another memory leak in igmpv3_del_delrec()")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Reported-by: kbuild test robot <lkp@intel.com>

Applied, thanks Eric.
