Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 487FB3ABC4
	for <lists+netdev@lfdr.de>; Sun,  9 Jun 2019 22:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729933AbfFIU1M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jun 2019 16:27:12 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:45406 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729580AbfFIU1M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jun 2019 16:27:12 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3C8AC14DF3D48;
        Sun,  9 Jun 2019 13:27:12 -0700 (PDT)
Date:   Sun, 09 Jun 2019 13:27:11 -0700 (PDT)
Message-Id: <20190609.132711.1638417451646515443.davem@davemloft.net>
To:     gwilkie@vyatta.att-mail.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net] mpls: fix warning with multi-label encap
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190607104941.1026-1-gwilkie@vyatta.att-mail.com>
References: <20190607104941.1026-1-gwilkie@vyatta.att-mail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 09 Jun 2019 13:27:12 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: George Wilkie <gwilkie@vyatta.att-mail.com>
Date: Fri,  7 Jun 2019 11:49:41 +0100

> If you configure a route with multiple labels, e.g.
>   ip route add 10.10.3.0/24 encap mpls 16/100 via 10.10.2.2 dev ens4
> A warning is logged:
>   kernel: [  130.561819] netlink: 'ip': attribute type 1 has an invalid
>   length.
> 
> This happens because mpls_iptunnel_policy has set the type of
> MPLS_IPTUNNEL_DST to fixed size NLA_U32.
> Change it to a minimum size.
> nla_get_labels() does the remaining validation.
> 
> Signed-off-by: George Wilkie <gwilkie@vyatta.att-mail.com>

Applied and queued up for -stable, thanks.
