Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65C292B1333
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 01:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726112AbgKMAV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 19:21:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:42908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725894AbgKMAV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 19:21:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 120CF20A8B;
        Fri, 13 Nov 2020 00:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605226917;
        bh=pHNSUZkUxEccH8VL2y1wGZr7S0hV9rs65Z7xLJFB4Dg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1uEVnUFHZ9Wakhohe3qWMPvY2hZXCjzE2sj6SVIHUsYicyN/7L3pZiTV1UwfTCV6q
         4oxKdOT65kIQwEQ1qvDTFrLI2hjn+cueS7PTkUGgHSBEVaIpCoIFAsBNvX0UPXdEEZ
         XtAl1NRlbUaCAUNln6DqXiuC1x0Bu7l+Sb9lkKKQ=
Date:   Thu, 12 Nov 2020 16:21:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmytro Shytyi <dmytro@shytyi.net>
Cc:     "kuznet" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji" <yoshfuji@linux-ipv6.org>,
        "liuhangbin" <liuhangbin@gmail.com>, "davem" <davem@davemloft.net>,
        "netdev" <netdev@vger.kernel.org>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next V3] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201112162156.211cad4e@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <175bd218cf4.103c639bc117278.4209371191555514829@shytyi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 16:44:54 +0100 Dmytro Shytyi wrote:
> Reported-by: kernel test robot <lkp@intel.com>

You don't have to add the reported by tag just because the bot pointed
out issues in the previous version.
