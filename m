Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF7A4F5ACD
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 23:19:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731171AbfKHWSx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 17:18:53 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:39448 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbfKHWSx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 17:18:53 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4E616153B4DF4;
        Fri,  8 Nov 2019 14:18:52 -0800 (PST)
Date:   Fri, 08 Nov 2019 14:18:51 -0800 (PST)
Message-Id: <20191108.141851.574550170546220386.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        david.laight@aculab.com
Subject: Re: [PATCHv4 net-next 0/5] sctp: update from rfc7829
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573190212.git.lucien.xin@gmail.com>
References: <cover.1573190212.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 08 Nov 2019 14:18:52 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Fri,  8 Nov 2019 13:20:31 +0800

> SCTP-PF was implemented based on a Internet-Draft in 2012:
> 
>   https://tools.ietf.org/html/draft-nishida-tsvwg-sctp-failover-05
> 
> It's been updated quite a few by rfc7829 in 2016.
> 
> This patchset adds the following features:
> 
>   1. add SCTP_ADDR_POTENTIALLY_FAILED notification
>   2. add pf_expose per netns/sock/asoc
>   3. add SCTP_EXPOSE_POTENTIALLY_FAILED_STATE sockopt
>   4. add ps_retrans per netns/sock/asoc/transport
>      (Primary Path Switchover)
>   5. add spt_pathcpthld for SCTP_PEER_ADDR_THLDS sockopt
> 
> v1->v2:
>   - See Patch 2/5 and Patch 5/5.
> v2->v3:
>   - See Patch 1/5, 2/5 and 3/5.
> v3->v4:
>   - See Patch 1/5, 2/5, 3/5 and 4/5.

Series applied, thank you.
