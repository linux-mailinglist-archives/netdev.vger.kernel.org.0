Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9DA16182707
	for <lists+netdev@lfdr.de>; Thu, 12 Mar 2020 03:25:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387646AbgCLCZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 22:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:56650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387501AbgCLCZO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 22:25:14 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0339A20736;
        Thu, 12 Mar 2020 02:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583979914;
        bh=P2eBWWdI8LThN4aAKOPvQJPkQ8jP+IsRJtJrwSNatec=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=x5bDxWZjO4d43dAi4m/VxkvUV8Kogz9M4t2uBK2u5Hgxs7UIgp56p0mrPqANjhrWZ
         UI4qQ+Gp5k9S4jZUeDF0H81IApDFfJ4J/kLjPhKPYBQMNn9BitEWcpSzkwIX8G2c/o
         8PTH/nSbTBNlK8l6ctKk9GxCsw4ArVi6UVP0AA2I=
Date:   Wed, 11 Mar 2020 19:25:11 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     Petr Machata <petrm@mellanox.com>, netdev@vger.kernel.org,
        Roman Mashak <mrv@mojatatu.com>, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net-next v2 3/6] net: sched: RED: Introduce an ECN
 tail-dropping mode
Message-ID: <20200311192511.3260658c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <7a7038ca-2f6f-30f6-e168-6a3510db0db7@gmail.com>
References: <20200311173356.38181-1-petrm@mellanox.com>
        <20200311173356.38181-4-petrm@mellanox.com>
        <2629782f-24e7-bf34-6251-ab0afe22ff03@gmail.com>
        <87imjaxv23.fsf@mellanox.com>
        <7a7038ca-2f6f-30f6-e168-6a3510db0db7@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 18:01:38 -0700 Eric Dumazet wrote:
> > That said, I agree that from the perspective of the qdisc itself the
> > name does not make sense. We can make it "nodrop", or "nored", or maybe
> > "keep_non_ect"... I guess "nored" is closest to the desired effect.  
> 
> Well, red algo is still used to decide if we attempt ECN marking, so "nodrop"
> seems better to me :)

nodrop + harddrop is a valid combination and that'd look a little
strange. Maybe something like ect-only?
