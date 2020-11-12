Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 728AF2AFF1E
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728165AbgKLFdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:41594 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728769AbgKLEXu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 23:23:50 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0481B216FD;
        Thu, 12 Nov 2020 04:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605155029;
        bh=VviEERgd2t6FUCvmgqE0g5Z+LFAmEtTYDlIaiVZfBbk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E60S7XqWtfmq/GlDZgTN2TIt2aEhfiB3np1vnJWXcgY4B+G/8cNFOr5zKqZ+7nWeP
         jyx2r7qRH/e1lIONBZz76DzllaCRylGJstklmRSNLGAw/s9w6KmPBfp9QP3KMJNYSD
         jPdbPNpkj4Po9V3EyJpxKFmdNAncUjnfINxZvTeE=
Date:   Wed, 11 Nov 2020 20:23:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V4 net-bugfixs] net/ethernet: Update ret when ptp_clock
 is ERROR
Message-ID: <20201111202348.0c9a051a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <AN*A-ACtDVzmm*z9RWHEvaqz.3.1605149317799.Hmail.wangqing@vivo.com>
References: <20201111173218.25f89965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <AN*A-ACtDVzmm*z9RWHEvaqz.3.1605149317799.Hmail.wangqing@vivo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 10:48:37 +0800 (GMT+08:00) =E7=8E=8B=E6=93=8E wrote:
> >On Thu, 12 Nov 2020 09:15:05 +0800 (GMT+08:00) =E7=8E=8B=E6=93=8E wrote:=
 =20
> >> >Grygorii, would you mind sending a correct patch in so Wang Qing can
> >> >see how it's done? I've been asking for a fixes tag multiple times
> >> >already :(   =20
> >>=20
> >> I still don't quite understand what a fixes tag means=EF=BC=8C
> >> can you tell me how to do this, thanks. =20
> >
> >Please read: Documentation/process/submitting-patches.rst
> >
> >You can search for "Fixes:" =20
>=20
> I see, but this bug is not caused by a specific patch, it exists at the b=
eginning, so=20
> there is no need to add a fixes tag. Please point out if I understand it =
incorrectly,thanks!

Please put whatever constitutes the beginning here (first commit of the
driver or first commit of git history).
