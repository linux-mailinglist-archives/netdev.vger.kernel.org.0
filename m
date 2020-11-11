Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C47F2AE6E6
	for <lists+netdev@lfdr.de>; Wed, 11 Nov 2020 04:13:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbgKKDNx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 22:13:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725859AbgKKDNx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Nov 2020 22:13:53 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AFB420786;
        Wed, 11 Nov 2020 03:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605064432;
        bh=xLpOUflaxfa2TAoXdgmyigBc7OZJ1+d/fo1nl+o3+sc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TfB4kfcvtMpL2gLErzmFB6Fr6WYJ5tS9ZyOq4UFtSbtf+b0va7gqxMAKqHi8KTVrK
         0N8UyGrAfW/dGdR2/v+qmaNjBEUVJg5HHOTNXL+KV+r6I4Jq7y1LuFq4Pn7/QxswKW
         8af7m56CAmLM+dmcPvWPyijClM0AUjEdiytiEyzI=
Date:   Tue, 10 Nov 2020 19:13:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Markus =?UTF-8?B?QmzDtmNobA==?= <markus.bloechl@ipetronik.com>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        "David S. Miller" <davem@davemloft.net>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] net: lan78xx: Disable hardware vlan filtering in
 promiscuous mode
Message-ID: <20201110191351.3449a6a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
References: <20201110153958.ci5ekor3o2ekg3ky@ipetronik.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 16:39:58 +0100 Markus Bl=C3=B6chl wrote:
> The rx-vlan-filter feature flag prevents unexpected tagged frames on
> the wire from reaching the kernel in promiscuous mode.
> Disable this offloading feature in the lan7800 controller whenever
> IFF_PROMISC is set and make sure that the hardware features
> are updated when IFF_PROMISC changes.
>=20
> Signed-off-by: Markus Bl=C3=B6chl <markus.bloechl@ipetronik.com>

Doesn't apply to neither net or net-next, please respin.

Could you also add a Fixes tag since this is a fix?

Thanks!
