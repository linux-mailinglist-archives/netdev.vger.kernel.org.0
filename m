Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A9A630B1E9
	for <lists+netdev@lfdr.de>; Mon,  1 Feb 2021 22:11:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbhBAVLf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Feb 2021 16:11:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:49306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229525AbhBAVLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 1 Feb 2021 16:11:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39ADE60232;
        Mon,  1 Feb 2021 21:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612213852;
        bh=htHomx7Gm5xTpSreiOlWQVYUAjVeYo8VKAzomoGhgJY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dyhhceAk9GzN23oSPXP78ox0yGso7kMsrG97im3YRhJoie7TBGrpM4i6sD/fDj+fb
         sW2k816FkfrOKeFM4/S9BGWHfmF8IigXj5uCSxD2kyurUWmF/F/MF0EvLEKw9I+W3F
         xI6Gyoi9av6j9YhDNFNC8yI2lcbqMU8G0H5Cv9LXQdquUFhEGhHT/nHl68p71BeI9d
         tvkl8SFsOwzoIvK5Iqu9VqTrrcyP3N8VPfbYuIhfFw1FtgO6OGp1a2sCVMPg5zj3TI
         M9j57Zkad8eiF9Rzu4CbMRsdZ7KMaU8Duhw0EzzodrYI7U+ACT/atkBW2ctnMv7gu1
         1J7GTBz78/I9w==
Date:   Mon, 1 Feb 2021 13:10:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     <netdev@vger.kernel.org>, <jiri@nvidia.com>, <saeedm@nvidia.com>,
        "kernel test robot" <lkp@intel.com>
Subject: Re: [PATCH net-next v5] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210201131051.4937f0ff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6ba2203c-919f-7baa-da7e-5c389187ef2a@nvidia.com>
References: <20210130023319.32560-1-cmi@nvidia.com>
        <20210129225918.0b621ed7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <6ba2203c-919f-7baa-da7e-5c389187ef2a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 1 Feb 2021 09:32:15 +0800 Chris Mi wrote:
> On 1/30/2021 2:59 PM, Jakub Kicinski wrote:
> > On Sat, 30 Jan 2021 10:33:19 +0800 Chris Mi wrote:  
> >> +// SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
> >> +/* Copyright (c) 2021 Mellanox Technologies. */
> >> +
> >> +const struct psample_ops __rcu *psample_ops __read_mostly;
> >> +EXPORT_SYMBOL_GPL(psample_ops);  
> > Please explain to me how you could possibly have compile tested this
> > and not caught that it doesn't build.  
> Sorry, I don't understand which issue you are talking about. Do you mean
> the issue sparse found before or new issues in v5?

There is no include here now, and it uses EXPORT_SYMBOL_GPL() 
and a bunch of decorators.

