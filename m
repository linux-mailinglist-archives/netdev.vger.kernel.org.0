Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A014435963
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 05:46:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231338AbhJUDs0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 23:48:26 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:40750 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231535AbhJUDry (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 23:47:54 -0400
Received: from [172.16.66.209] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id AAE7920222;
        Thu, 21 Oct 2021 11:45:37 +0800 (AWST)
Message-ID: <e9f97a8d9cf10537de4dcd38b666b6ccba5078a6.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v3] mctp: Implement extended addressing
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 21 Oct 2021 11:45:36 +0800
In-Reply-To: <20211015134448.GA16157@asgard.redhat.com>
References: <20211014083420.2050417-1-jk@codeconstruct.com.au>
         <20211015134448.GA16157@asgard.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

> So, unless there is existing code that relies on this socket level
> definition, it is probably worth re-defining it to 284 and put a copy
> of SOL_MCTP definition after SOL_XDP in include/linux/socket.h.

Nope, new ABI here, so we're fine to define it as we like.

I've sent a v4 with this moved to linux/socket.h, and dropped the uapi
definition - as (like you've mentioned) there's not a lot of precedent
for the copies under uapi.

Thanks for the review!

Cheers,


Jeremy

