Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDAC445868
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 18:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233860AbhKDRgs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 13:36:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:47154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhKDRgs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 13:36:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A0CC61076;
        Thu,  4 Nov 2021 17:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636047249;
        bh=A4238DQGmI4/bX7NYgaTJp0Z3vyq2cge8JI3yq/k/is=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=F3t4Lf/91ADp+gdchaR5vWv+XVWBJmN8N8HXm7dTA9thuaeYeofSt/jezew3jT5Iw
         POTZMiBQKUl7NSwIbSFoFI9JGGMCMgwbRi0B6+klJldp6FeQMQ77H/QRABAaZ0M2vH
         Al7FpW2MN9PpEHsNyW+QwpepFm+B0THTi1uwllVHEWkxi1ODMxQHUonvrh5WIaVLd3
         km7ScP/l/DXV9ms4NXuwAVoZEodhBedivpT1s8bdbXOGfvxRVmqfzmEcHXyO7UmDr+
         z2R3IbjSmFxqyfeUzY3/wjHtx7IQR8XSMtrkZ+9B/fMxbS3zn/owLNJmfHaomJ5tU5
         MvcbB9ohfyFpw==
Date:   Thu, 4 Nov 2021 10:34:08 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Riccardo Paolo Bestetti <pbl@bestov.io>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Message-ID: <20211104103346.29d82cb1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211102141921.197561-1-pbl@bestov.io>
References: <20210321002045.23700-1-pbl@bestov.io>
        <20211102141921.197561-1-pbl@bestov.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  2 Nov 2021 15:19:21 +0100 Riccardo Paolo Bestetti wrote:
> Add support to inet v4 raw sockets for binding to nonlocal addresses
> through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
> the ipv4.ip_nonlocal_bind kernel parameter.
> 
> Add helper function to inet_sock.h to check for bind address validity on
> the base of the address type and whether nonlocal address are enabled
> for the socket via any of the sockopts/sysctl, deduplicating checks in
> ipv4/ping.c, ipv4/af_inet.c, ipv6/af_inet6.c (for mapped v4->v6
> addresses), and ipv4/raw.c.
> 
> Add test cases with IP[V6]_FREEBIND verifying that both v4 and v6 raw
> sockets support binding to nonlocal addresses after the change. Add
> necessary support for the test cases to nettest.
> 
> Signed-off-by: Riccardo Paolo Bestetti <pbl@bestov.io>

Thanks for the patch, please keep Dave's review tag and repost 
in ~2 weeks.


# Form letter - net-next is closed

We have already sent the networking pull request for 5.16
and therefore net-next is closed for new drivers, features,
code refactoring and optimizations. We are currently accepting
bug fixes only.

Please repost when net-next reopens after 5.15-rc1 is cut.

Look out for the announcement on the mailing list or check:
http://vger.kernel.org/~davem/net-next.html
