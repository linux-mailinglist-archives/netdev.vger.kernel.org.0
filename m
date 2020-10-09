Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2778A288995
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 15:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388187AbgJINJJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 09:09:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:58666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732547AbgJINJJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 09:09:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 014CE22248;
        Fri,  9 Oct 2020 13:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602248948;
        bh=ejH4/M/EizUhjeSZw6xoFj4GATeaO+40kyLfg+D7Q8o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=khDhoIxbNGatlrsao6AvN/CZSy94L5RPyguYmbW2i4V7GQ+5pyepbcw15TmnRBwMh
         2w5MkONXZXBC12hMx0tSMdh0oK+FRRlOPi87OnaWhnPKCmdFTtPl3VDFeSfVIzFtDd
         S+6HoarwfUbtZKoMpAFwzSUv69iywjMeQ5kQuSIk=
Date:   Fri, 9 Oct 2020 15:09:54 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: repair "fixed-link" support
Message-ID: <20201009130954.GA538323@kroah.com>
References: <20201009094739.5411-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201009094739.5411-1-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 09, 2020 at 11:47:39AM +0200, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> The PHYs must be registered once in device probe function, not in device
> open callback because it's only possible to register them once.
> 
> Fixes: a25e278020 ("staging: octeon: support fixed-link phys")
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>

Looks like it breaks the build, please fix up and test your patches when
sending them out next time.

thanks,

greg k-h
