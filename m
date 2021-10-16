Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 089D142FFB0
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 04:13:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239497AbhJPCPL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 22:15:11 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:39282 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232812AbhJPCPJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Oct 2021 22:15:09 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 9485C20222;
        Sat, 16 Oct 2021 10:12:59 +0800 (AWST)
Message-ID: <37c35854b5f351dc1d06f17ea63c1009e4d9b944.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v4 04/15] mctp: Add sockaddr_mctp to uapi
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     netdev@vger.kernel.org, Matt Johnston <matt@codeconstruct.com.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Date:   Sat, 16 Oct 2021 10:12:58 +0800
In-Reply-To: <20211015170020.GB16157@asgard.redhat.com>
References: <20210729022053.134453-1-jk@codeconstruct.com.au>
         <20210729022053.134453-5-jk@codeconstruct.com.au>
         <20211015170020.GB16157@asgard.redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Eugene,

> On Thu, Jul 29, 2021 at 10:20:42AM +0800, Jeremy Kerr wrote:
> >  struct sockaddr_mctp {
> > +       unsigned short int      smctp_family;
> > +       int                     smctp_network;
> 
> struct mctp_skb_cb.net (as well as struct mctp_dev.net) are unsigned,
> is it intentional that this field (along with struct
> mctp_sock.bind_net) differs in signedness?

No, that's not intentional - I'll submit a patch to unify those.

Thanks for the review.

Cheers,


Jeremy



