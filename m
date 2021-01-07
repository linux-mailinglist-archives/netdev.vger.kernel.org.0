Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B62692ED51E
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 18:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729042AbhAGRHS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 12:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729030AbhAGRHR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 12:07:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4AE46233CE;
        Thu,  7 Jan 2021 17:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610039197;
        bh=kdpnak+VNvEOSjXNTuPWKOuRIn3wRbo6L9cOQwy23YU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SvE8TrY7rvGIWNVM13q406gFdCAJpeUSE83QwMh4q1FZhjQlKRhaa56MvmzaHmdte
         7LZNQBNXg1l4QMFVxGCQw3bcAJgPnNG8/RhaJTxMeQxJCYPyVC161jXLc1LdRPwavy
         6CJcjwZ8pyKsR3d/rFEm9232pSXTbdKx2K2sQ7Ivt4MDWZHSPn7O479tOsoFOkEMLy
         4eEdlDfQ8DaOOmKIX/US+t9btzV4mFr7uO4SusHcUiUANpYSPuobLW2sdWEWKGlZGK
         ODMkOxjyVW7j7isuegVDvvbyjcN4pNYVrPECbSU4uWGV2h028urIeJXag2QKdurUJg
         BgSCueQJycKnA==
Date:   Thu, 7 Jan 2021 09:06:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     lll <liyonglong@chinatelecom.cn>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        davem@davemloft.net, fw@strlen.de, soheil@google.com,
        ncardwell@google.com, ycheng@google.com
Subject: Re: [PATCH] tcp: remove obsolete paramter sysctl_tcp_low_latency
Message-ID: <20210107090635.440b1fc6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b3cb1c57-d992-72c1-dd24-5d594ff38561@chinatelecom.cn>
References: <1608271876-120934-1-git-send-email-liyonglong@chinatelecom.cn>
        <20201218164647.1bcc6cb9@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <b3cb1c57-d992-72c1-dd24-5d594ff38561@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 7 Jan 2021 11:08:16 +0800 lll wrote:
> =E5=9C=A8 2020/12/19 8:46, Jakub Kicinski =E5=86=99=E9=81=93:
> > On Fri, 18 Dec 2020 14:11:16 +0800 lyl wrote: =20
> >> Remove tcp_low_latency, since it is not functional After commit
> >> e7942d0633c4 (tcp: remove prequeue support)
> >>
> >> Signed-off-by: lyl <liyonglong@chinatelecom.cn> =20
> >=20
> > I don't think we can remove sysctls, even if they no longer control=20
> > the behavior of the kernel. The existence of the file itself is uAPI.
>
> Got it. But a question: why tcp_tw_recycle can be removed totally?
> it is also part of uAPI

Good question, perhaps with tcp_tw_recycle we wanted to make sure users
who depended on it notice removal, since the feature was broken by
design?=20

tcp_low_latency is an optimization, not functionality which users may
depend on.

But I may be wrong so CCing authors.
