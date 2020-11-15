Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42BFB2B3216
	for <lists+netdev@lfdr.de>; Sun, 15 Nov 2020 05:14:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726591AbgKOEMm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 23:12:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33750 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726177AbgKOEMm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 23:12:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B6FE322284;
        Sun, 15 Nov 2020 04:12:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605413562;
        bh=Sijvv8+8FcMxce7kTnEwo5dOMyK6gmCi0lMIyXxdd4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mnsUCTy7QUDKdI6vtG2pWNLT6LIL67Mtxyp7K7MUeTpA0+39GK6O81LZBf/1+YVfi
         jghAdQrtI5A2PlfEkPSEKUzJgxdQCNw1cIKifYo2u9TVDW6EcV+fwGWCW2qho9xr6c
         f6cCbuutfE1SfX6lmqzVy2UrxVWYPxvFrB1XfosY=
Date:   Sat, 14 Nov 2020 20:12:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        linux-next@vger.kernel.org, netdev@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net-next v3] net: linux/skbuff.h: combine SKB_EXTENSIONS
 + KCOV handling
Message-ID: <20201114201235.604486e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201115011043.8159-1-rdunlap@infradead.org>
References: <20201115011043.8159-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 14 Nov 2020 17:10:43 -0800 Randy Dunlap wrote:
> The previous Kconfig patch led to some other build errors as
> reported by the 0day bot and my own overnight build testing.
> 
> These are all in <linux/skbuff.h> when KCOV is enabled but
> SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
> in the header file.
> 
> Also, add stubs for skb_ext_add() and skb_ext_find() to reduce the
> amount of ifdef-ery. (Jakub)
> 
> Fixes: 6370cc3bbd8a ("net: add kcov handle to skb extensions")
> Fixes: 85ce50d337d1 ("net: kcov: don't select SKB_EXTENSIONS when there is no NET")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Reported-by: kernel test robot <lkp@intel.com>

Thanks, LGTM! Let's give it a day on the ML so that build bot can take
it for a spin just in case.
