Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D63CF47F15F
	for <lists+netdev@lfdr.de>; Fri, 24 Dec 2021 23:57:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhLXW5T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 17:57:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:39024 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbhLXW5T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 17:57:19 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E47D8612BE;
        Fri, 24 Dec 2021 22:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2605C36AE5;
        Fri, 24 Dec 2021 22:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640386638;
        bh=d3Uuu33b1tz/huT+/Fpn2SEBaYlEn9thzNHCSyBG/1M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=mNM+FhYQQdDd5NKoUSAdELWgMM5yEQA66fjh2mUcWoSlTBRIAnHCDNuFPmD2tIsQj
         T76D/FkyxfLihW8ckvDTZaYdpxTadvqrGdGeMtdRpKWL/1YBRSqVaVyKFaN5C3PkNI
         ZvUjU9KjKXzYcSeQoa2GKlcZ7zOubUOKZmMWIpaE7oLbKqc1lVeUCxyGeAGHBfwSlX
         AkXatZ4F27FDd1TePKJbarU5HShBqktg73ydYlLdATHQ55Sgcl/mMjo1ct5u7jZp/c
         qdXU4C/Mr6YC0FogX779GUS3nZxUxKaYqM06X1Nxvrq3kwxESTF2vSAT0uoXqCFDtt
         TWx0vABgzhXAQ==
Date:   Fri, 24 Dec 2021 14:57:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>
Cc:     j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn
Subject: Re: [PATCH v5] net: bonding: Add support for IPV6 ns/na to
 balance-alb/balance-tlb mode
Message-ID: <20211224145717.7aebc89f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
References: <20211224142512.44182-1-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 09:25:12 -0500 Sun Shouxin wrote:
> Since ipv6 neighbor solicitation and advertisement messages
> isn't handled gracefully in bonding6 driver, we can see packet
> drop due to inconsistency bewteen mac address in the option
> message and source MAC .
> 
> Another examples is ipv6 neighbor solicitation and advertisement
> messages from VM via tap attached to host brighe, the src mac
> mighe be changed through balance-alb mode, but it is not synced
> with Link-layer address in the option message.
> 
> The patch implements bond6's tx handle for ipv6 neighbor
> solicitation and advertisement messages.
> 
> Suggested-by: Hu Yadi <huyd12@chinatelecom.cn>
> Reported-by: kernel test robot <lkp@intel.com>

Still breaks allmodconfig build.
