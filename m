Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AEA83E53D5
	for <lists+netdev@lfdr.de>; Tue, 10 Aug 2021 08:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237941AbhHJGrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Aug 2021 02:47:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:43548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235165AbhHJGrl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Aug 2021 02:47:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2660F6105A;
        Tue, 10 Aug 2021 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628578039;
        bh=6ot/s562xQeM2tG8qfWeEJTm5lPjP93NPcOCwW/B0fo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=h6YzNvKCZ2R5HU5d8HFsbkF3axb7z+L6gVvBQfAh/fNXGfgPSxdxwo1H+xsfiEEIU
         H1p1LMda1NLDyn/X8nlggqP2EVO9OKE5fKMyYvkWiGeBveK0wfmTyOB4SUOdA5IdJc
         7nAFnmzApNL3ln07aQIFI658lUjjb1T876DVQrBPCW6PC8qXLglBvDlb/NghT+1tT8
         30jKUnUrlMxCsxS6wuWordEH0ouKw+jFCOhq4nubXxacrPDzfBfysH2ZRcBlGMLI7l
         xdATOPzHFxY6SCnVuDL9fiJimH1Fqk+KzlUyyh3AKKYPf3eEvFPPThzvWROFtZSuAm
         LjJ0mw/UxpS5w==
Date:   Tue, 10 Aug 2021 09:47:16 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, joe@perches.com,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 2/2] bonding: combine netlink and console
 error messages
Message-ID: <YRIg9IRmBpaZghKf@unreal>
References: <a36c7639a13963883f49c272ed7993c9625a712a.1628306392.git.jtoppins@redhat.com>
 <f39027d1a23fb744212bd502d426a44512be4897.1628576943.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f39027d1a23fb744212bd502d426a44512be4897.1628576943.git.jtoppins@redhat.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 10, 2021 at 02:40:31AM -0400, Jonathan Toppins wrote:
> There seems to be no reason to have different error messages between
> netlink and printk. It also cleans up the function slightly.
> 
> v2:
>  - changed the printks to reduce object code slightly
>  - emit a single error message based on if netlink or sysfs is
>    attempting to enslave
> 
> Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
> ---
>  drivers/net/bonding/bond_main.c | 49 +++++++++++++++++++--------------
>  1 file changed, 29 insertions(+), 20 deletions(-)

Can you please resubmit whole series and not as a reply and put your changelog under ---?
We don't want to see chengelog in final commit message.

Thanks
