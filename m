Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 727D229447E
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 23:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409831AbgJTVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 17:24:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:40520 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388189AbgJTVYC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Oct 2020 17:24:02 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0BC121481;
        Tue, 20 Oct 2020 21:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603229041;
        bh=0rinrY5fW2KR60LVFevNDEIQwC1CPMujb7gtjgT7eoI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wCqQNJAHk0zCyq7ot7jKOWAa+0BtcA5Cc0+8jRMCDwa2UVWmCBSGpFB8mP7TrcM8w
         qzLxIzlbc3tyZVEwQSsMGcHJCLwJX83osHCT9yEdaQAJuuRLhUX1+uCXnd7AoicI+z
         4hJfv+58GTOULk90mgXX09Bn6NXQ6l9OMOnqBqZ4=
Date:   Tue, 20 Oct 2020 14:23:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next v5 0/4] GVE Raw Addressing
Message-ID: <20201020142359.6fd662b0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201020181252.753330-1-awogbemila@google.com>
References: <20201020181252.753330-1-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Oct 2020 11:12:48 -0700 David Awogbemila wrote:
> Changes from v4:
> Patch 2: Remove "#include <linux/device-mapper.h>" gve_rx.c - it was added
> 	by accident.

We have already sent a pull request for 5.10 and therefore net-next 
is closed for new drivers, features, and code refactoring.

Please repost when net-next reopens after 5.10-rc1 is cut.

(http://vger.kernel.org/~davem/net-next.html will not be up to date 
 this time around, sorry about that).

RFC patches sent for review only are obviously welcome at any time.
