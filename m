Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444C72B9CFB
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 22:34:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726433AbgKSVdP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Nov 2020 16:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:46706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726386AbgKSVdP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Nov 2020 16:33:15 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBEF821D40;
        Thu, 19 Nov 2020 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605821595;
        bh=fqBFH7PuSbAUTJQNaIEKNd0erUlAGzPvzxcoqSn3Hmg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UelAQT8MkhUdKSXICgrHUHsPAuBXCxMZLTCx1Ck0OpYG+VzMNQc6hALwptgh1d3Rp
         TFlWupuGvyTZCfR61MBzW/zm2XN79KbzOAVT3u6FOpYLKGEdAPJLV/vW0pcj1i7yK/
         tuFjQKcLI7tMAibOc3Wph8ci8IxLGpD0Vu5t0lk4=
Date:   Thu, 19 Nov 2020 13:33:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf 2020-11-19
Message-ID: <20201119133313.1ec2a196@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201119200721.288-1-alexei.starovoitov@gmail.com>
References: <20201119200721.288-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 12:07:21 -0800 Alexei Starovoitov wrote:
> Hi David, hi Jakub,
>=20
> The following pull-request contains BPF updates for your *net* tree.
>=20
> We've added 18 non-merge commits during the last 12 day(s) which contain
> a total of 17 files changed, 301 insertions(+), 49 deletions(-).
>=20
> The main changes are:
>=20
> 1) libbpf should not attempt to load unused subprogs, from Andrii.
>=20
> 2) Make strncpy_from_user() mask out bytes after NUL terminator, from Dan=
iel.
>=20
> 3) Relax return code check for subprograms in the BPF verifier, from Dmit=
rii.
>=20
> 4) Fix several sockmap issues, from John.

Looks like the bot didn't register the merge because I didn't set the
delegate before pushing =F0=9F=A4=94

In any case - pulled, thanks!
