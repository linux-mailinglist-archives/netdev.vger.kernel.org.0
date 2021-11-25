Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50AA745D473
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 06:57:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345208AbhKYGAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 01:00:16 -0500
Received: from pi.codeconstruct.com.au ([203.29.241.158]:57882 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242820AbhKYF6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Nov 2021 00:58:16 -0500
Received: from [172.16.68.9] (unknown [49.255.141.98])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id BD55120222;
        Thu, 25 Nov 2021 13:55:02 +0800 (AWST)
Message-ID: <a80b67fea17ef0f033ca5f0e5345cd72d84ea455.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next 1/3] mctp: serial: cancel tx work on ldisc close
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jiri Slaby <jirislaby@kernel.org>, netdev@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Date:   Thu, 25 Nov 2021 13:55:01 +0800
In-Reply-To: <5c27a7c0-54a0-0fab-4680-350fcc12ac49@kernel.org>
References: <20211123125042.2564114-1-jk@codeconstruct.com.au>
         <20211123125042.2564114-2-jk@codeconstruct.com.au>
         <b3307219-db82-d519-63df-dc246e11b037@kernel.org>
         <e97b2d3ee72ba8eec5fbae81ce0757806bf25d69.camel@codeconstruct.com.au>
         <5c27a7c0-54a0-0fab-4680-350fcc12ac49@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiri,

> there should be no invocation of ldisc after close(). If there is,
> it's a bug as this is even documented:

Excellent thanks for that (and the doc pointer), I'll get a v2 done
now.

Cheers,


Jeremy

