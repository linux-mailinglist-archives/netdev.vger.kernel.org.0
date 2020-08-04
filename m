Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AC1E23BEBD
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 19:18:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgHDRSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Aug 2020 13:18:33 -0400
Received: from mx2.suse.de ([195.135.220.15]:59572 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728371AbgHDRSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 4 Aug 2020 13:18:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id BE088B05C;
        Tue,  4 Aug 2020 17:18:45 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 6ADF66030D; Tue,  4 Aug 2020 19:18:28 +0200 (CEST)
Date:   Tue, 4 Aug 2020 19:18:28 +0200
From:   Michal Kubecek <mkubecek@suse.cz>
To:     Adrian Pop <popadrian1996@gmail.com>
Cc:     netdev@vger.kernel.org, linville@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>,
        Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH] ethtool: Add QSFP-DD support
Message-ID: <20200804171828.sbrnaqak6y2xxhly@lion.mk-sys.cz>
References: <20200731084725.7804-1-popadrian1996@gmail.com>
 <20200804101456.4cfv4agv6etufi7a@lion.mk-sys.cz>
 <CAL_jBfRyKxaFqU5m7oXNyfvC3_T_TVAjaF+04NV7rZksCqmszg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_jBfRyKxaFqU5m7oXNyfvC3_T_TVAjaF+04NV7rZksCqmszg@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 04, 2020 at 11:25:48AM +0100, Adrian Pop wrote:
> >
> > AFAICS the kernel counterpart is going to reach mainline in 5.9-rc1
> > merge window. Please base your patch on "next" branch or wait until next
> > is merged into master after 5.8 release (which should be later today or
> > tomorrow).
> 
> I will wait until tomorrow and rebase my patch onto master then.

Branch "next" is merged into master now so you can base v2 on master.

Michal
