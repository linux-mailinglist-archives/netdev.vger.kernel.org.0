Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C3A939756C
	for <lists+netdev@lfdr.de>; Tue,  1 Jun 2021 16:29:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234160AbhFAObY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 10:31:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbhFAObY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Jun 2021 10:31:24 -0400
X-Greylist: delayed 1173 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Jun 2021 07:29:42 PDT
Received: from ganesha.gnumonks.org (ganesha.gnumonks.org [IPv6:2001:780:45:1d:225:90ff:fe52:c662])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3F2C061574;
        Tue,  1 Jun 2021 07:29:42 -0700 (PDT)
Received: from uucp by ganesha.gnumonks.org with local-bsmtp (Exim 4.89)
        (envelope-from <laforge@gnumonks.org>)
        id 1lo55o-0006dN-Af; Tue, 01 Jun 2021 16:10:04 +0200
Received: from laforge by localhost.localdomain with local (Exim 4.94.2)
        (envelope-from <laforge@gnumonks.org>)
        id 1lo54u-004M7u-30; Tue, 01 Jun 2021 16:09:08 +0200
Date:   Tue, 1 Jun 2021 16:09:08 +0200
From:   Harald Welte <laforge@gnumonks.org>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     pablo@netfilter.org, davem@davemloft.net, kuba@kernel.org,
        osmocom-net-gprs@lists.osmocom.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] gtp: Fix a typo
Message-ID: <YLY/hDKxXLC507ft@nataraja>
References: <20210601141625.4131445-1-zhengyongjun3@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210601141625.4131445-1-zhengyongjun3@huawei.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 01, 2021 at 10:16:25PM +0800, Zheng Yongjun wrote:
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>

Obviousy-Acked-by: Harald Welte <laforge@gnumonks.org>

-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
