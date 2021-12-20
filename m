Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B1D047A3A5
	for <lists+netdev@lfdr.de>; Mon, 20 Dec 2021 03:30:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237262AbhLTCaR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 21:30:17 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:37274 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230024AbhLTCaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 21:30:16 -0500
Received: from [192.168.12.102] (unknown [159.196.94.94])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 6348820164;
        Mon, 20 Dec 2021 10:30:13 +0800 (AWST)
Message-ID: <2f13e007f8e9deaa0fde187f7c1321e2703b9895.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v2] mctp: emit RTM_NEWADDR and RTM_DELADDR
From:   Matt Johnston <matt@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jeremy Kerr <jk@codeconstruct.com.au>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Date:   Mon, 20 Dec 2021 10:30:12 +0800
In-Reply-To: <20211217114247.39b632c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211215053250.703167-1-matt@codeconstruct.com.au>
         <20211217114247.39b632c8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 2021-12-17 at 11:42 -0800, Jakub Kicinski wrote:
> 	return NLMSG_ALIGN(sizeof(struct ifaddrmsg))
> > +		+ nla_total_size(4) // IFA_LOCAL
> > +		+ nla_total_size(4) // IFA_ADDRESS
> 
> why 4? The attributes are u8, no?
> 
> 
> > +	if (rc < 0)
> How about a customary WARN_ON_ONCE(rc == -EMSGSIZE) here?

Thanks for the review Jakub. Size 4 is a mistake, I'll send v3.

Cheers,
Matt
> 

