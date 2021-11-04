Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29846445CCD
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 00:59:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhKEACA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 20:02:00 -0400
Received: from pi.codeconstruct.com.au ([203.29.241.158]:46524 "EHLO
        codeconstruct.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbhKEAB7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 20:01:59 -0400
Received: from pecola.lan (unknown [159.196.93.152])
        by mail.codeconstruct.com.au (Postfix) with ESMTPSA id 9055B20222;
        Fri,  5 Nov 2021 07:59:17 +0800 (AWST)
Message-ID: <54b02f37ab63e0e5a0c6fc2912b8652927fdb22f.camel@codeconstruct.com.au>
Subject: Re: [PATCH net-next v2 0/2] MCTP sockaddr padding
 check/initialisation fixup
From:   Jeremy Kerr <jk@codeconstruct.com.au>
To:     Jakub Kicinski <kuba@kernel.org>,
        Eugene Syromiatnikov <esyr@redhat.com>
Cc:     Matt Johnston <matt@codeconstruct.com.au>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Fri, 05 Nov 2021 07:59:17 +0800
In-Reply-To: <20211104165532.781b3dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <cover.1635965993.git.esyr@redhat.com>
         <20211104165532.781b3dd0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> > This pair of patches introduces checks for padding fields of struct
> > sockaddr_mctp/sockaddr_mctp_ext to ease their re-use for possible
> > extensions in the future;  as well as zeroing of these fields
> > in the respective sockaddr filling routines.  While the first
> > commit
> > is definitely an ABI breakage, it is proposed in hopes that the
> > change
> > is made soon enough (the interface appeared only in Linux 5.15)
> > to avoid affecting any existing user space.
> 
> Seems reasonable, Jeremy can you send an ack?

Yep, will do ASAP - I'm planning also send references to the commits
ton the userspace side, so that we have a record of where everything
lines up on the updated ABI.

I'll have that done later today.

Cheers,


Jeremy


