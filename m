Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B4062A3752
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 00:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbgKBXva (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 18:51:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:36072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725841AbgKBXv3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Nov 2020 18:51:29 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E051206F1;
        Mon,  2 Nov 2020 23:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604361089;
        bh=JlgNscAve9Tt0wHdpqYkGkC4PGKpbrAToUCGy2BQ+W4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HVX3/33esn8YduXv+bWjwsNcmBe5hUbDQHJgsER79nKHJqJFWEloev+HrkvSWk6uo
         bEyQtKfL+f1byMfeLWMUzHGJZw4t3BD99PYxi9Y5yHIAQKztlVKN9PVsUYMu4k52eN
         mkZBIyzhaFT6tfmPUZ/xDUEBSIRgvWpkGjfitX2M=
Date:   Mon, 2 Nov 2020 15:51:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] drivers: net: tulip: Fix set but not used with
 W=1
Message-ID: <20201102155128.5c80974e@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201031005445.1060112-1-andrew@lunn.ch>
References: <20201031005445.1060112-1-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 31 Oct 2020 01:54:45 +0100 Andrew Lunn wrote:
> When compiled for platforms other than __i386__ or __x86_64__:
>=20
> drivers/net/ethernet/dec/tulip/tulip_core.c: In function =E2=80=98tulip_i=
nit_one=E2=80=99:
> drivers/net/ethernet/dec/tulip/tulip_core.c:1296:13: warning: variable =
=E2=80=98last_irq=E2=80=99 set but not used [-Wunused-but-set-variable]
>  1296 |  static int last_irq;
>=20
> Add more #if defined() to totally remove the code when not needed.
>=20
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Applied, thanks!
