Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E6F45D147
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235436AbhKXXf7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:35:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:34858 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235005AbhKXXf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:35:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C28B860F55;
        Wed, 24 Nov 2021 23:32:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637796769;
        bh=LrJPhqgIm2LjAuSYPNDmXjZ3TWL4CQjontN7lbB4EBQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=El1rKYURfu3EV6vs9X8wmKDcJFQOhSHXfFfbdTyS8/97qlHGnDb1nZeDcJkdoE3jH
         IwJumflRmGj0D5TcLT2quWyKVhWAchTctSHKk0s1lpaMG4OYwSTBGzKpR/BqR/RWVd
         M1lZFPBrg8sM5wwryLfrnI+ovtK1BIR1unofA8SCjx+fXXb2F7wL3yXb/HqTkJcQFo
         VE2ZB3w46duZEWeenj+PHiPiJZtuGW6Nx26NdaFr8kYdX36eeGTMxwsZEnx7prdkN7
         SDKN1nkYVV1K9A7H+Nt7oPDsLKqvD26elZz9l74VDQ6KsGgtQDNFJxpy4nDHOhTxiq
         7unmJ56Q33fng==
Date:   Wed, 24 Nov 2021 15:32:47 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Frode Nordahl <frode.nordahl@canonical.com>
Cc:     netdev@vger.kernel.org, Jiri Pirko <jiri@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH net] netdevsim: Fix physical port index
Message-ID: <20211124153247.40e7dce3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAKpbOASJBgx74VFFhMe_+MNMd0OjwjcdKRfVuiFQyBmP4ao0dw@mail.gmail.com>
References: <20211124081106.1768660-1-frode.nordahl@canonical.com>
        <20211124062048.48652ea4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKpbOATgFseXtkWoTcs6bNsvP_4WXChv5ffvtd2+8uqTHmr26w@mail.gmail.com>
        <20211124094023.68010e87@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAKpbOASJBgx74VFFhMe_+MNMd0OjwjcdKRfVuiFQyBmP4ao0dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 19:25:10 +0100 Frode Nordahl wrote:
> I assume there is an association between the PF and VF ports from devlink POV?

Yes, the VFs have PF id which should match the PF id from which they
were spawned.
