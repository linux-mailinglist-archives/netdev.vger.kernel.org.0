Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD90C21ABDD
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 02:03:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726615AbgGJADW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 20:03:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:54498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726227AbgGJADW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 20:03:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B7C6F2065D;
        Fri, 10 Jul 2020 00:03:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594339401;
        bh=t/V3Lros/6ca4YPSjpX3yu/XgWwl/od9f8zBidiPIzI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iesZwQ+UV+dRIXa7fgKANrF5jwDH97g6oSD9uA5UC1KlGdotB526I62pSyg3pUptl
         LldYHLuhu2JvH6xC1pQCqu1ZPSts6KThDfrxdFdN1zVIE3u/opccr8ldHt96V66XxS
         tEYY1EqEoEmYoRWlTjRWReqRrSE7Xt7mflvqsQzs=
Date:   Thu, 9 Jul 2020 17:03:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, xiyou.wangcong@gmail.com,
        linux@roeck-us.net
Subject: Re: [PATCH net] cgroup: Fix sock_cgroup_data on big-endian.
Message-ID: <20200709170320.2fa4885b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200709.163235.585914476648957821.davem@davemloft.net>
References: <20200709.163235.585914476648957821.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 09 Jul 2020 16:32:35 -0700 (PDT) David Miller wrote:
> From: Cong Wang <xiyou.wangcong@gmail.com>
> 
> In order for no_refcnt and is_data to be the lowest order two
> bits in the 'val' we have to pad out the bitfield of the u8.
> 
> Fixes: ad0f75e5f57c ("cgroup: fix cgroup_sk_alloc() for sk_clone_lock()")
> Reported-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: David S. Miller <davem@davemloft.net>

FWIW Cong's listed in From: but there's no sign-off from him so the
signoff checking script may get upset about this one.
