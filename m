Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E26023094FD
	for <lists+netdev@lfdr.de>; Sat, 30 Jan 2021 12:52:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229990AbhA3Lv6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 Jan 2021 06:51:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:58840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhA3Lv6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 30 Jan 2021 06:51:58 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 278D564DF5;
        Sat, 30 Jan 2021 11:51:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612007477;
        bh=1TiGTb8bXJFZSQogGr6Y36Vr+6eMgMN/eHqeJmvIpZw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sNDc9N19ZS7e1IGwfePNA6IQjA/jlOQRQt58Id/oXteKZ5oSCdJHeiWKP4FV0q9oh
         JEcu1iLBKz8qjDLtSYKLr9ewpyT3xW2YxQV4B66JsIPoOeCpWH7NwG9YmW6J5SYOqD
         QPpvMHT5ZJJ5zU5BwhIV1pCpgPGT58TA+JTgcfEc=
Date:   Sat, 30 Jan 2021 12:51:14 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Aviraj Cj (acj)" <acj@cisco.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xe-linux-external(mailer list)" <xe-linux-external@cisco.com>,
        Hangbin Liu <liuhangbin@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [Internal review][PATCH stable v5.4 1/2] ICMPv6: Add ICMPv6
 Parameter Problem, code 3 definition
Message-ID: <YBVIMvTN8ZFC+54U@kroah.com>
References: <20210129192741.117693-1-acj@cisco.com>
 <YBUafB76nbydgXv+@kroah.com>
 <D6F3B42A-95E1-4B8D-8556-E29F195C69D3@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <D6F3B42A-95E1-4B8D-8556-E29F195C69D3@cisco.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jan 30, 2021 at 11:31:11AM +0000, Aviraj Cj (acj) wrote:
> 
> 
> ﻿On 30/01/21, 2:06 PM, "Greg KH" <gregkh@linuxfoundation.org> wrote:
> 
> On Sat, Jan 30, 2021 at 12:57:40AM +0530, Aviraj CJ wrote:
> > From: Hangbin Liu <liuhangbin@gmail.com>
> > 
> > commit b59e286be280fa3c2e94a0716ddcee6ba02bc8ba upstream.
> > 
> > Based on RFC7112, Section 6:
> > 
> >    IANA has added the following "Type 4 - Parameter Problem" message to
> >    the "Internet Control Message Protocol version 6 (ICMPv6) Parameters"
> >    registry:
> > 
> >       CODE     NAME/DESCRIPTION
> >        3       IPv6 First Fragment has incomplete IPv6 Header Chain
> > 
> > Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
> > Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Aviraj CJ <acj@cisco.com>
> > ---
> >  include/uapi/linux/icmpv6.h | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> > diff --git a/include/uapi/linux/icmpv6.h b/include/uapi/linux/icmpv6.h
> > index 2622b5a3e616..9a31ea2ad1cf 100644
> > --- a/include/uapi/linux/icmpv6.h
> > +++ b/include/uapi/linux/icmpv6.h
> > @@ -137,6 +137,7 @@ struct icmp6hdr {
> >  #define ICMPV6_HDR_FIELD		0
> >  #define ICMPV6_UNK_NEXTHDR		1
> >  #define ICMPV6_UNK_OPTION		2
> > +#define ICMPV6_HDR_INCOMP		3
> >  
> >  /*
> >   *	constants for (set|get)sockopt
> > -- 
> > 2.26.2.Cisco
> > 
> 
> What do you mean by "internal review" and what am I supposed to do with
> this patch?  Same for the 2/2 patch in this series...
> <ACJ> Sorry " internal review" added by mistake, this is the correct patch for v5.4 branch, pls let me if u want me to send it by correcting...

Please fix and resend.

thanks,

greg k-h
