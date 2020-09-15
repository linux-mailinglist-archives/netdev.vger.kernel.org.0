Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0989E26B216
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 00:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727688AbgIOWk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 18:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:52078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727208AbgIOP6D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 15 Sep 2020 11:58:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BDE6206B7;
        Tue, 15 Sep 2020 15:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600185483;
        bh=+HMSv9EJEU9r90uLwbq9RCqS1JjJ75MwUi2oubnP9go=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TX+VUGTdBqo7VmUC4KngVKqU3tbJFYRJKwUztePzhOVu6WSxmPLjVK1U1+ywWuh+D
         LEOxzCaAGffF/j3SR67jSXFqJpP271WzCdWVu6peEmnyq3tTF+hAjzcC80yEXTrK5w
         B6gmjCOdq9UdASu8mPw4xPF1drrDOnMQIXB9d+Io=
Date:   Tue, 15 Sep 2020 08:58:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Subject: Re: [PATCH net-next v2 00/10] make drivers/net/ethernet W=1 clean
Message-ID: <20200915085801.475e32f2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
References: <20200915014455.1232507-1-jesse.brandeburg@intel.com>
        <a28498acdf87f11e81d3282d63f18dbe1a3d5329.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Sep 2020 21:24:28 -0700 Saeed Mahameed wrote:
> I know Jakub and Dave do some compilation testing before merging but i
> don't know how much driver coverage they have and if they use a
> specific .config or they just manually create one on demand..

allmodconfig, it should be able to catch everything that builds on x86
and for a given GCC version.

The other advantage of this series is that we won't have to apply a
thousand single-warning fixes.
