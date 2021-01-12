Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 843DA2F407E
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 01:56:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404228AbhAMAmy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 19:42:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:45184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390144AbhALXoI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 18:44:08 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 27E972312F;
        Tue, 12 Jan 2021 23:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610495007;
        bh=sqMp/LI/6JLJMB7Mj/Nym0uVuhozEe+eZ7tk61SBsnI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=b4bqZedq/HxHQl7UEpD5I/ZcnjYvpyEkPhQ56hj2cc/AC12LYOEu6lJdtXY5ooMKv
         VqqomRl2pHO5/Fvxw85OIocQG0DrOGvNXBHohYJ7g2KE9zmcZF6m7+7QywzFAXt8PB
         JfZE5Ww3wbYVZ38GvlzuDx2a0ORgzq+yUwLH68pzx/4h/7a1ykIa4nOavZfeAFhHEe
         E4xgZXUjNWlXJSjBUNlrWfY9GbpPiH5O5Lg50i4o2Pe0ENRtyrIF2Ty4+OoB5jrXxG
         keMc+IPubtGAxpHqoEMNKeOLTs6vCcPzBxMhFbVFn0wEJOC06eB2iZq/Dcm31uPor3
         AX//VyQu0ZEBg==
Date:   Tue, 12 Jan 2021 15:43:26 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Praveen Chaudhary <praveen5582@gmail.com>
Cc:     davem@davemloft.net, corbet@lwn.net, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v0 net-next 1/1] Allow user to set metric on default
 route learned via Router Advertisement.
Message-ID: <20210112154326.00f45bf1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210112195511.13235-1-pchaudhary@linkedin.com>
References: <20210111151650.41ac7532@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20210112195511.13235-1-pchaudhary@linkedin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 Jan 2021 11:55:11 -0800 Praveen Chaudhary wrote:
> Hi Jakub
>=20
> Thanks for the review,
>=20
> Sure, I will reraise the patch (again v0i, sonce no code changes) after a=
dding space before '<'.
>=20
> This patch adds lines in 'include/uapi/', that requires ABI version chang=
es for debian build. I am not sure, if we need any such changes to avoid br=
eaking allmodconfig. It will be really helpful, if you can look at the patc=
h once 'https://lkml.org/lkml/2021/1/11/1668' and suggest on this. Thanks a=
 lot again.

The code doesn't build, AFAIK it's because:

net/ipv6/ndisc.c:1322:8: error: too few arguments to function =E2=80=98rt6_=
add_dflt_router=E2=80=99
