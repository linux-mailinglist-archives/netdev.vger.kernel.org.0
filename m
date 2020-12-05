Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9B0E2CF800
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 01:31:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbgLEAar (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 19:30:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:47942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726462AbgLEAar (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 19:30:47 -0500
Date:   Fri, 4 Dec 2020 16:30:05 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607128206;
        bh=6JWoxLUvapYOVhM7Xi0mh9tPz+BCRJiFSQmkEIwslsA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=N1bbqvjUXafF0fQewZAQ1P7ywHs9hN1GGNPc7wJewPbCeMHw3FJ0djBwvgpcVmAVo
         oj8UgyxlgRYcSTQ2XIHjUapRAOeQ5myzFi/8mpBPNbfGSdyBxZsq6MxgWoLbVnPXxg
         d9A/WQ6cq1D1C7xz0E8+c9eXpIAesq4kQMJAJmbVgRTvs6GwgyWovuLDNrySa/laSY
         1dM1SiGzPJ5aEgIXXSx5b2akaqovsgvAkjWfuilTADo8vl7JMkvOdjxGtOpiUaNnS0
         96FPUtGhM0EZYN2LdwBPo6EUXiwm4npxvjLq2putLKoBj0GQLDtARHjO1QM8YpeiPx
         MyWotQKAx42EQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Eelco Chaudron <echaudro@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, dev@openvswitch.org,
        pshelar@ovn.org, bindiyakurle@gmail.com, mcroce@linux.microsoft.com
Subject: Re: [PATCH net] net: openvswitch: fix TTL decrement exception
 action execution
Message-ID: <20201204163005.10ab9c53@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <160708417520.39389.4157710029285521561.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
References: <160708417520.39389.4157710029285521561.stgit@wsfd-netdev64.ntdv.lab.eng.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  4 Dec 2020 07:16:23 -0500 Eelco Chaudron wrote:
> Currently, the exception actions are not processed correctly as the wrong
> dataset is passed. This change fixes this, including the misleading
> comment.
> 
> In addition, a check was added to make sure we work on an IPv4 packet,
> and not just assume if it's not IPv6 it's IPv4.
> 
> Small cleanup which removes an unsessesaty parameter from the
> dec_ttl_exception_handler() function.

No cleanups in fixes, please. Especially when we're at -rc6..

You can clean this up in net-next within a week after trees merge.

> Fixes: 69929d4c49e1 ("net: openvswitch: fix TTL decrement action netlink message format")

:( 
and please add some info on how these changes are tested.

Thanks!

