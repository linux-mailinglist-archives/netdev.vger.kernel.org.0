Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DC602CF7A4
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 00:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgLDXlN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 18:41:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:43736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726111AbgLDXlN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 18:41:13 -0500
Date:   Fri, 4 Dec 2020 15:40:45 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607125247;
        bh=xZueu0qpXLhKBBWVHRjSbGglwsp20+CKOkl1Y8XBxtY=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wb/HNogbdneGDmIK4YfiQbshWHpysKiITzWmsUoMOXX5NdbH6PPtqtRjhhGRy/1jL
         5C+Lr/cVb6jWLqxNMg7PXFmThhm8gSvfIE0Lru3dlP1QKCodxd8opzoX1hxzcR7x0l
         0INsOWVngj/XrN2Xkh2r0dkUDSrhYcEJpvEKEOqfoWfVLHmu76pJAPYJvTnpenZI83
         325YKPRp6x5DqdCAbBgIXfdFYSVST3KbnJMGEu1al3ybKH8UhLZmwBcS1ps1ZOlTVF
         2W5t7shoZOZWEqP3HlmT9fPBYzTadOQKfxBgKbAHtJdn96u9pVmAlqeiF8u1KMJZuq
         GkbefH/8r1sHw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] ipv4: fix error return code in rtm_to_fib_config()
Message-ID: <20201204154045.0f93f240@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <d525d028-582d-2cea-5507-db43ee9f9fe3@gmail.com>
References: <1607071695-33740-1-git-send-email-zhangchangzhong@huawei.com>
        <d525d028-582d-2cea-5507-db43ee9f9fe3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 4 Dec 2020 09:04:08 -0700 David Ahern wrote:
> On 12/4/20 1:48 AM, Zhang Changzhong wrote:
> > Fix to return a negative error code from the error handling
> > case instead of 0, as done elsewhere in this function.
> > 
> > Fixes: d15662682db2 ("ipv4: Allow ipv6 gateway with ipv4 routes")
> > Reported-by: Hulk Robot <hulkci@huawei.com>
> > Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
