Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 00C225A73A
	for <lists+netdev@lfdr.de>; Sat, 29 Jun 2019 00:55:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfF1Wzg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jun 2019 18:55:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:60280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726563AbfF1Wzg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Jun 2019 18:55:36 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 294082086D;
        Fri, 28 Jun 2019 22:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561762535;
        bh=kIUly98/abHLrDwCWp4BUJhyZ2mlDdcyKyA9sUivkSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wVvmhKl+g08YzyG46XVfg5LuZNia1qQiQ+ASouU6FvvY4YA5mZQraPNeIczvyi9+8
         tXz6V0vJZ8hm/8liYtFASLimcSVoXcMDQKB+ZK5WC7OTlilgWg1mSepNTWKqSvoCsi
         7N9TzfD6p+QFxogm3crRjw7xgSZQgMCdSZJKqy40=
Date:   Fri, 28 Jun 2019 18:55:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Josh Elsasser <jelsasser@appneta.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: net: check before dereferencing netdev_ops during busy poll
Message-ID: <20190628225533.GJ11506@sasha-vm>
References: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAGnkfhxxw9keiNj_Qm=2GBYpY38HAq28cOROMRqXfbqq8wNbWQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 28, 2019 at 06:34:58PM +0200, Matteo Croce wrote:
>Hi,
>
>Is there any reason for this panic fix not being applied in stable?
>
>https://lore.kernel.org/netdev/20180313053248.13654-1-jelsasser@appneta.com/T/

What's the upstream commit id?

--
Thanks,
Sasha
