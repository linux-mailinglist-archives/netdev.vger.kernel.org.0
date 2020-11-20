Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA3342BB8FD
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 23:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbgKTW3I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 17:29:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728039AbgKTW3H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 17:29:07 -0500
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:191:4433::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45FC8C0613CF;
        Fri, 20 Nov 2020 14:29:07 -0800 (PST)
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.94)
        (envelope-from <johannes@sipsolutions.net>)
        id 1kgEtJ-00Bdb8-DL; Fri, 20 Nov 2020 23:28:29 +0100
Message-ID: <9b722328efd90104d0c0819f530c296213c19450.camel@sipsolutions.net>
Subject: Re: [PATCH net-next] net: don't include ethtool.h from netdevice.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, mkubecek@suse.cz,
        linux-rdma@vger.kernel.org, linux-wireless@vger.kernel.org
Date:   Fri, 20 Nov 2020 23:28:28 +0100
In-Reply-To: <20201120221328.1422925-1-kuba@kernel.org> (sfid-20201120_231813_295757_85C2724D)
References: <20201120221328.1422925-1-kuba@kernel.org>
         (sfid-20201120_231813_295757_85C2724D)
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-malware-bazaar: not-scanned
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2020-11-20 at 14:13 -0800, Jakub Kicinski wrote:
> linux/netdevice.h is included in very many places, touching any
> of its dependecies causes large incremental builds.
> 
> Drop the linux/ethtool.h include, linux/netdevice.h just needs
> a forward declaration of struct ethtool_ops.
> 
> Fix all the places which made use of this implicit include.

>  include/net/cfg80211.h                                   | 1 +

Sounds good to me, thanks. Will still cause all wireless drivers to
rebuild this way though. Maybe I'll see later if something can be done
about that.

Acked-by: Johannes Berg <johannes@sipsolutions.net>

Thanks,
johannes

