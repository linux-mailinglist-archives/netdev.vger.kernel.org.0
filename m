Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61BAC2B59C7
	for <lists+netdev@lfdr.de>; Tue, 17 Nov 2020 07:37:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726494AbgKQGgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Nov 2020 01:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKQGgh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Nov 2020 01:36:37 -0500
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9214AC0613CF;
        Mon, 16 Nov 2020 22:36:37 -0800 (PST)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1keubK-0002h0-8M; Tue, 17 Nov 2020 07:36:26 +0100
Date:   Tue, 17 Nov 2020 07:36:26 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Aleksandr Nogikh <nogikh@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-next@vger.kernel.org,
        netdev@vger.kernel.org, Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH net-next v5] net: linux/skbuff.h: combine SKB_EXTENSIONS
 + KCOV handling
Message-ID: <20201117063626.GF22792@breakpoint.cc>
References: <20201116212108.32465-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116212108.32465-1-rdunlap@infradead.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:
> The previous Kconfig patch led to some other build errors as
> reported by the 0day bot and my own overnight build testing.
> 
> These are all in <linux/skbuff.h> when KCOV is enabled but
> SKB_EXTENSIONS is not enabled, so fix those by combining those conditions
> in the header file.

Thanks Randy.

Acked-by: Florian Westphal <fw@strlen.de>
