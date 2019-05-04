Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B53713798
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 07:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726230AbfEDFhj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 01:37:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:56890 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725801AbfEDFhj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 01:37:39 -0400
Received: from localhost (unknown [75.104.87.19])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB5CC14DA6485;
        Fri,  3 May 2019 22:37:35 -0700 (PDT)
Date:   Sat, 04 May 2019 01:37:31 -0400 (EDT)
Message-Id: <20190504.013731.38990269717923489.davem@davemloft.net>
To:     echaudro@redhat.com
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, dev@openvswitch.org
Subject: Re: [PATCH net-next] net: openvswitch: return an error instead of
 doing BUG_ON()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190502201238.21698.58459.stgit@netdev64>
References: <20190502201238.21698.58459.stgit@netdev64>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 03 May 2019 22:37:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Eelco Chaudron <echaudro@redhat.com>
Date: Thu,  2 May 2019 16:12:38 -0400

> For all other error cases in queue_userspace_packet() the error is
> returned, so it makes sense to do the same for these two error cases.
> 
> Reported-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>

Applied.
