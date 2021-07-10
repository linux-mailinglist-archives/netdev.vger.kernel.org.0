Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA663C3518
	for <lists+netdev@lfdr.de>; Sat, 10 Jul 2021 17:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbhGJPTT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Jul 2021 11:19:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49036 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229805AbhGJPTT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 10 Jul 2021 11:19:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=69CjnvpN/5ehmxhfv9jVxwaU5JWN+G5OUT021R5Y70I=; b=iYQRRsPBgtSj1mYdHpWVQzPDOR
        FzGdRaRYhv9mN4KNTPwiNDQdrlJS30HX6qIVwdyKs74k5LBLNPTpj7zP1RTCpGUsL+A6iyYVss0fo
        bW6lxNaeECjFmbqN7XkN4Rm/8ul5xEmNf0gRIKTl40FCHzMR5MtvI0unyXOqj3VlUf40=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m2EiI-00CtC4-MO; Sat, 10 Jul 2021 17:16:18 +0200
Date:   Sat, 10 Jul 2021 17:16:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Jian Shen <shenjian15@huawei.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, linuxarm@openeuler.org
Subject: Re: [RFC net-next] net: extend netdev features
Message-ID: <YOm5wgVv7PGx9AYi@lunn.ch>
References: <1625910047-56840-1-git-send-email-shenjian15@huawei.com>
 <20210710081120.5570fb87@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210710081120.5570fb87@hermes.local>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Infrastructure changes must be done as part of the patch that
> needs the new feature bit. It might be that your feature bit is
> not accepted as part of the review cycle, or a better alternative
> is proposed.

Hi Stephan

I agree with what you are saying, but i also think there is no way to
avoid needing more feature bits. So even if the new feature bit itself
is rejected, the code to allow it could be useful.

	  Andrew
