Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5D582A56E4
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 22:32:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732887AbgKCVbt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 16:31:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:51362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbgKCVbr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 16:31:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE9002072C;
        Tue,  3 Nov 2020 21:31:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604439107;
        bh=3RIdsKXOD3UQzctZeM8u0cWoFmTcw2N5AkQCQo/VuLQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JQxvqhmxRLkAPyTKQQbeIkvgYjr6koDBClB0KLfJefHCdKrp7CxtWq3+kuf38mCuG
         ugSQu3yeA/7lJ7w3WHm4xkZ+BY4pZl0KkbyynxLrogSFO746ZzE0mzOWc1BfhUQwza
         p4cFO5s9EeMyCDIFRkqi3VjcjW5LzCp0JDVXrxeI=
Date:   Tue, 3 Nov 2020 13:31:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     davem@davemloft.net, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: Re: [PATCH] net: ipv6: remove redundant blank in
 ip6_frags_ns_sysctl_register
Message-ID: <20201103133146.5a647de1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102142403.4063-1-menglong8.dong@gmail.com>
References: <20201102142403.4063-1-menglong8.dong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 22:24:03 +0800 Menglong Dong wrote:
> From: Menglong Dong <dong.menglong@zte.com.cn>
> 
> This blank seems redundant.
> 
> Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>

It is redundant but cleanup like this is not worth the potential
conflicts when backporting fixes.
