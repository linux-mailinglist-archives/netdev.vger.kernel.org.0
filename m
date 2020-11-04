Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56A622A5B26
	for <lists+netdev@lfdr.de>; Wed,  4 Nov 2020 01:46:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729949AbgKDAqM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 19:46:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:53760 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725811AbgKDAqM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Nov 2020 19:46:12 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 692D5223C7;
        Wed,  4 Nov 2020 00:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604450771;
        bh=ACtBQNFzamgoqru94IQJGQYBY4TmRzcALatfsvzo1jc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VxXVuKmRfP6d4L0ZzrHChp4tzrXQuf3kCErOgShbGdYzdM8Etbs2NtbzQnH5ny+4a
         OMLsAoV86nlbV2+1zHhJibTz8uI7hbm9ySVdSIP46I5KTKJnoxtq1mVzFyC5T9kYC7
         RE4ZWOxXf83xY+gyeJBefN6GMJDAnED+z34peahc=
Date:   Tue, 3 Nov 2020 16:46:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH 01/30] net: fddi: skfp: ecm: Protect 'if' when AIX_EVENT
 is not defined
Message-ID: <20201103164610.249af38c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201102114512.1062724-2-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
        <20201102114512.1062724-2-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Nov 2020 11:44:43 +0000 Lee Jones wrote:
> When AIX_EVENT is not defined, the 'if' body will be empty, which
> makes GCC complain.  Place bracketing around the invocation to protect
> it.
>=20
> Fixes the following W=3D1 kernel build warning(s):
>=20
>  drivers/net/fddi/skfp/ecm.c: In function =E2=80=98ecm_fsm=E2=80=99:
>  drivers/net/fddi/skfp/ecm.c:153:29: warning: suggest braces around empty=
 body in an =E2=80=98if=E2=80=99 statement [-Wempty-body]
>=20
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: netdev@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Okay, I applied most of these, but please don't post series larger than
15 patches in the future. Also each patch series should have a cover
letter.

I did not apply:

 - wimax - it should go to staging
 - tulip - does not apply
 - lan79xx - has checkpatch warnings
 - smsc - I'm expecting a patch from Andew there
