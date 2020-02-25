Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 861E316ED17
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 18:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730813AbgBYRxS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 12:53:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:36216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730566AbgBYRxS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 12:53:18 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2AF6F21744;
        Tue, 25 Feb 2020 17:53:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582653197;
        bh=DmT0VpGDtab5DzjIBtfNp70Sypf/37KYdVUDbZ4tWcE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Cv8D/DTrHN0DxVWEeT2T8src0Fms7gBJBq9vruVoXgn3L8K+3m5ryxU1xnlL/TIDQ
         /OtFru6oRRM616Pa8kkSG12NMDhjh+i5y96lgVKOTUMCagVTbpQ3zIsK0qXgBh2SCU
         nJ5MTtx8O2SDgfXT1Cnq5ixufFy/X3SUXHMF21I0=
Date:   Tue, 25 Feb 2020 09:53:15 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 09/10] netdevsim: add ACL trap reporting cookie
 as a metadata
Message-ID: <20200225095315.40b94e73@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200225074019.GB17869@nanopsycho>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-10-jiri@resnulli.us>
        <20200224204257.07c7456f@cakuba.hsd1.ca.comcast.net>
        <20200225074019.GB17869@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Feb 2020 08:40:19 +0100 Jiri Pirko wrote:
> >Also I feel like we could just hold onto the ASCII hex buf, 
> >and simplify the reading side. If the hex part is needed in 
> >the first place, hexdump and xxd exist..  
> 
> I don't understand. Do you suggest to keep the write hex "buf" as well
> and just print it out in "read()" function? I don't like to store one
> info in 2 places. We need to have the cookie in fa_cookie anyway. Easy
> to bin2hex from it and send to userspace.

Okay, no strong feelings. I did not like the GFP_ATOMIC allocation on
read, just to convert formats. But it's not a big deal.

Thanks for the adjustments!
