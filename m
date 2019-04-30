Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 44A9DF233
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726824AbfD3Ioo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:44:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:57792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725769AbfD3Ioo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 04:44:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF4872080C;
        Tue, 30 Apr 2019 08:44:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556613883;
        bh=keV+Ec1Jz9bhz4BHUfYnU0y7exiC2U3FfjCICKG98a8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U1WVKVC23dEO0Kfr1eaRkeOxcPjD+QFlz/CqgZbME7rvrYBtBnUls//tkJTrQ48Rw
         OxSbg8M+RsnRkUS4jaG/F2JhPPQEbou++GlOPgEkU+jw982luGybH9XrBB46EkBehb
         Som4C1W/6otrHXduOFUrLRx/qGizkesO5ZbIqXmQ=
Date:   Tue, 30 Apr 2019 10:44:41 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     "Tobin C. Harding" <tobin@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Tyler Hicks <tyhicks@canonical.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Wang Hai <wanghai26@huawei.com>,
        YueHaibing <yuehaibing@huawei.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] bridge: Use correct cleanup function
Message-ID: <20190430084441.GE11737@kroah.com>
References: <20190430002817.10785-1-tobin@kernel.org>
 <20190430002817.10785-3-tobin@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430002817.10785-3-tobin@kernel.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 30, 2019 at 10:28:16AM +1000, Tobin C. Harding wrote:
> The correct cleanup function if a call to kobject_init_and_add() has
> returned _successfully_ is kobject_del().  kobject_put() is used if the
> call to kobject_init_and_add() fails.  kobject_del() calls kobject_put().
> 
> Use correct cleanup function in error path.
> 
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
