Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFA32903E7
	for <lists+netdev@lfdr.de>; Fri, 16 Oct 2020 13:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405471AbgJPLRA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Oct 2020 07:17:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:58210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405440AbgJPLQ7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Oct 2020 07:16:59 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7964820878;
        Fri, 16 Oct 2020 11:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602847018;
        bh=9O2VsNOj0Pl896NsOWT55a1CGfW1jErCtAHYmNumc58=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GefhZu0pi7Kyd3g7+HhdWWen52jVybrN5Q6NONX9so3K11g0/qPdDKMM4aK9fBY63
         j63U84EAkNzRoY3tV1P5stiI0yv2XXcvBepKwmye6/9/TCCWQlbQPobwv9qV/ZdCNE
         3Kpr6521HiIruqx8Hs4X0CdqO4pmMWh41wCkLTsA=
Date:   Fri, 16 Oct 2020 13:17:29 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Alexander A Sverdlin <alexander.sverdlin@nokia.com>
Cc:     devel@driverdev.osuosl.org, Aaro Koskinen <aaro.koskinen@iki.fi>,
        Ralf Baechle <ralf@linux-mips.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH v2 net] staging: octeon: Drop on uncorrectable alignment
 or FCS error
Message-ID: <20201016111729.GB1785357@kroah.com>
References: <20201016101858.11374-1-alexander.sverdlin@nokia.com>
 <20201016101858.11374-2-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201016101858.11374-2-alexander.sverdlin@nokia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 16, 2020 at 12:18:58PM +0200, Alexander A Sverdlin wrote:
> From: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> 
> Currently in case of alignment or FCS error if the packet cannot be
> corrected it's still not dropped. Report the error properly and drop the
> packet while making the code around a little bit more readable.
> 
> Signed-off-by: Alexander Sverdlin <alexander.sverdlin@nokia.com>
> Fixes: 80ff0fd3ab ("Staging: Add octeon-ethernet driver files.")
> 
> Change-Id: Ie1fadcc57cb5e221cf3e83c169b53a5533b8edff

You didn't run checkpatch :(

