Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 332AC47BA7D
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 08:12:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhLUHMG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 02:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhLUHMG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 02:12:06 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059D5C061574;
        Mon, 20 Dec 2021 23:12:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B7634B810DC;
        Tue, 21 Dec 2021 07:12:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B4DC36AE9;
        Tue, 21 Dec 2021 07:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640070723;
        bh=fQt/CiyDY99RKB4xmUXQXd505qrSBvHhfBUnu3o5RsI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Bb3oJckgBMwVoUfrY6zZndbQi03vmRlwmHzlLnFUqoM04vpMCJ1Lq9Jl684k08W9G
         oDYAjaoxyg/KEiJuO585NZhRjTEYebQgclZ4brJgBgWnZ8Fy5WMMwHgm22F2HjGm9+
         b+2GgXtbcYeqzhmRVJH6+BcktZqRiDIsGSkEW7oU=
Date:   Tue, 21 Dec 2021 08:12:00 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Mike Ximing Chen <mike.ximing.chen@intel.com>
Cc:     linux-kernel@vger.kernel.org, arnd@arndb.de,
        dan.j.williams@intel.com, pierre-louis.bossart@linux.intel.com,
        netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Subject: Re: [RFC PATCH v12 01/17] dlb: add skeleton for DLB driver
Message-ID: <YcF+QIHKgNLJOxUh@kroah.com>
References: <20211221065047.290182-1-mike.ximing.chen@intel.com>
 <20211221065047.290182-2-mike.ximing.chen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211221065047.290182-2-mike.ximing.chen@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 21, 2021 at 12:50:31AM -0600, Mike Ximing Chen wrote:
> +/* Copyright(C) 2016-2020 Intel Corporation. All rights reserved. */

So you did not touch this at all in 2021?  And it had a copyrightable
changed added to it for every year, inclusive, from 2016-2020?

Please run this past your lawyers on how to do this properly.

greg k-h
