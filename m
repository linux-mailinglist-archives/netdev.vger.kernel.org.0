Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690021CBDC8
	for <lists+netdev@lfdr.de>; Sat,  9 May 2020 07:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728847AbgEIFcF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 May 2020 01:32:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725820AbgEIFcE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 May 2020 01:32:04 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B2D321775;
        Sat,  9 May 2020 05:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589002324;
        bh=9ZDCH7nd9Jy4YDZC64EIbgljIMh4xe8U/frqthy/qmk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OUkI++yE35vmcQMR1AbHbsLXYGnYXRdpUbD0yLcL1aOOx03QwRgerAOT2SRgyTIye
         Ox1jVgdxVzXUC+k5B0kcNWsvQD81R1o5vdfwSGvEiG8NgteE67Y9VYovK/ixQ5/M4S
         EY2y63NUTXxx2uXAtelFXTs6HlhrPIWTPgtkm3go=
Date:   Fri, 8 May 2020 22:32:02 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Samuel Zou <zou_wei@huawei.com>
Cc:     <olteanv@gmail.com>, <andrew@lunn.ch>, <vivien.didelot@gmail.com>,
        <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH -next] net: dsa: sja1105: remove set but not used
 variable 'prev_time'
Message-ID: <20200508223202.09e7849d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1588939255-58038-1-git-send-email-zou_wei@huawei.com>
References: <1588939255-58038-1-git-send-email-zou_wei@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 8 May 2020 20:00:55 +0800 Samuel Zou wrote:
> Fixes gcc '-Wunused-but-set-variable' warning:
>=20
> drivers/net/dsa/sja1105/sja1105_vl.c:468:6: warning: variable =E2=80=98pr=
ev_time=E2=80=99 set but not used [-Wunused-but-set-variable]
>   u32 prev_time =3D 0;
>       ^~~~~~~~~
>=20
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Samuel Zou <zou_wei@huawei.com>

Applied, thank you!
