Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12580319805
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 02:39:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229617AbhBLBir (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 20:38:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:38652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229469AbhBLBir (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Feb 2021 20:38:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1C9964E26;
        Fri, 12 Feb 2021 01:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613093886;
        bh=UxE7bP04abRbByIblo7RkzeiJKScEObbKtu04f8GC3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XrFdMxmFPhSbnKEPzXx645WwkfsBe8k7ElqjwBS3kESwPqw7tdhB2IPOYAWIYms0P
         zOJEBOWEWJvgp5pxF7B/9vRofpJO/TSGj1uPASor19EktZVPgywlib5fByMFI+6CBU
         OXMkgfSRixxXtfK3WpXuo7VG0QQMILR8Vy3r1amaXyAJg1hb6r+oS1LwCC6W/pWTXw
         An6v7DyOqfB9/pxrYa7c4S+RhQNrEZnP1OSSn0H5uUcyTkKe5jYKylM67Jb2cKlfjw
         1pbZ1oQp0PByV6yk/dxpYVfsYArKnpUnnO8EJevVfbDpFSwjV8L8QKunkbrkpCiCar
         ozYzvBed5BvKw==
Date:   Thu, 11 Feb 2021 17:38:05 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vadim Fedorenko <vfedorenko@novek.ru>
Cc:     David Howells <dhowells@redhat.com>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        netdev@vger.kernel.org
Subject: Re: [net-next] rxrpc: Fix dependency on IPv6 in udp tunnel config
Message-ID: <20210211173805.217431ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <171e77b1-b58b-9c62-3082-c40c80bc9240@novek.ru>
References: <20210209135429.2016-1-vfedorenko@novek.ru>
        <171e77b1-b58b-9c62-3082-c40c80bc9240@novek.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Feb 2021 19:12:57 +0000 Vadim Fedorenko wrote:
> On 09.02.2021 13:54, Vadim Fedorenko wrote:
> > As udp_port_cfg struct changes its members with dependency on IPv6
> > configuration, the code in rxrpc should also check for IPv6.  
> 
> Looks like this patch was mistakely tagged as superseded by
> dc0e6056decc rxrpc: Fix missing dependency on NET_UDP_TUNNEL
> Although both patches have the same Fixes tag, this one fixes
> different problem - rxrpc subsystem could not be compiled without
> support for IPv6 because the code tries to access ipv6-specific
> members of struct udp_port_cfg.

It does happen sometimes, it's the patchwork bot marking things as
superseded :(
 
> Should I resend it?

Yes, that'd probably be easiest for Dave to handle.
