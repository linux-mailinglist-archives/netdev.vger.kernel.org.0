Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28D922608F6
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 05:20:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728486AbgIHDUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 23:20:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:39282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728396AbgIHDUh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 23:20:37 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19F2A206DB;
        Tue,  8 Sep 2020 03:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599535237;
        bh=vkX3VPNmRSVoEMlhmvS4sQyTb8NnPpYOW+ui7wYjgc8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=11U24V/RK5GLYsVx6GgtUgzkN061oFsOtOW6pIT8H6+Q1GYdS/Uutjvfr0xokl42h
         zxGxCF1mL3jDqMkuyWbvQwGq3s4UFrQ19cZNP3xQ0gFdijyQZnSfJk5rvIAusiIqeE
         GclIxu+4acrC4w4JfddT/OKyfO4H9Q+w2rIXNeSw=
Date:   Mon, 7 Sep 2020 20:20:35 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, jwi@linux.ibm.com, f.fainelli@gmail.com,
        andrew@lunn.ch, mkubecek@suse.cz, dsahern@gmail.com,
        edwin.peer@broadcom.com, michael.chan@broadcom.com,
        saeedm@mellanox.com, rmk+kernel@armlinux.org.uk
Subject: Re: [PATCH net-next v2] net: tighten the definition of interface
 statistics
Message-ID: <20200907202035.63a39252@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200903231431.2354702-1-kuba@kernel.org>
References: <20200903231431.2354702-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Sep 2020 16:14:31 -0700 Jakub Kicinski wrote:
> This patch is born out of an investigation into which IEEE statistics
> correspond to which struct rtnl_link_stats64 members. Turns out that
> there seems to be reasonable consensus on the matter, among many drivers.
> To save others the time (and it took more time than I'm comfortable
> admitting) I'm adding comments referring to IEEE attributes to
> struct rtnl_link_stats64.

Applied.
