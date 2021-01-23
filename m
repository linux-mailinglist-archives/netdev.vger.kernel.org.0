Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84B4A3011CB
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 01:56:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbhAWAwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 19:52:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:53562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725274AbhAWAws (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 19:52:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3B3AE235DD;
        Sat, 23 Jan 2021 00:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611363128;
        bh=m7n29xz8DBxb9rmkpsHdS/GE07DJCIej3TveI5mulSY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rh6DHaYWMh8QhJqOftUCmwgVWAm2TU3EU/xBVJSv9ma7sVKNjaasU8+cp/yHpfDYj
         dQIFEoVB6uYcd22xWfzc6xePX0pPai8/iZvo+DpE3KizjJn6BQcXO8h5phfBSDS8+E
         1QGrXMxJ7mcjP0v9IOtlOy0XyE+GurkOykpq6KZqgX66txxlEDgF/7AUXNZx0fyfT5
         84ywdorO4C9TWLglSUzh6KXca6sPUx3X0smZiMjONnnJ9kziLa0Itxi6AZEOJ0yV24
         Uo9JsHGIHFQRWRYXT8hp1vz1DKZAyHprA866tBaDJCcuuKSyeNKqClc/TR6K21Fkfh
         2aTOMCckjdkNA==
Date:   Fri, 22 Jan 2021 16:52:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        Giacinto Cifelli <gciofono@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v2] net: usb: qmi_wwan: added support for Thales
 Cinterion PLSx3 modem family
Message-ID: <20210122165207.12613038@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <877do51cj3.fsf@miraculix.mork.no>
References: <20210120045650.10855-1-gciofono@gmail.com>
        <20210121170957.49ed2513@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <877do51cj3.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Jan 2021 11:39:12 +0100 Bj=C3=B8rn Mork wrote:
> Jakub Kicinski <kuba@kernel.org> writes:
>=20
> > Bjorn, I think this was posted before you pointed out the missing CCs
> > and Giacinto didn't repost.
> >
> > Looks good? =20
>=20
> Yes, LGTM
>=20
> Acked-by: Bj=C3=B8rn Mork <bjorn@mork.no>

Applied, thanks!
