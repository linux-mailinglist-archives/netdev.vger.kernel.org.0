Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320002CF401
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 19:27:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729494AbgLDS0p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 13:26:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:46558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727729AbgLDS0o (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 13:26:44 -0500
Date:   Fri, 4 Dec 2020 10:26:02 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607106364;
        bh=QF/pmCEL+RHZ4HjL1GuCjx1bK4he9AnSqrhTRpa1PL0=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=NIUYYkys/LacBql/Ry9BOnR8NcZ0K8WN4iApDkldUBFuC1kX9vAr8bJgVNb79tmY4
         B6UO6gn+8pgJXhpwegvwGEQwxNdmZ/Wm9eSwNNWrDMj1VMq7dQreAhajWbeSyt6yI3
         enTtrVd8e6dk7HPKkhv/69EG8PU+3BPuZrEBRj29UqNmKNkHc3x9RPXDXNZSmxHsXB
         RHxFf6BAT2mqKF4RiYqkCsbi6YWCWUZcB5IoBA1/YH9vPKOgNhyF00E7Y167Uh0+Qr
         xjtSXv2jb0qCkyExjXUJGgL/bOenodk6E8Jgd2oOw9DNDLugTjh6r6NdT/kBKFIlVW
         zj9vXgcws1ZOQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     davem@davemloft.net, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, kernel-team@fb.com
Subject: Re: pull-request: bpf-next 2020-12-03
Message-ID: <20201204102602.7c35cdbe@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201204021936.85653-1-alexei.starovoitov@gmail.com>
References: <20201204021936.85653-1-alexei.starovoitov@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 18:19:36 -0800 Alexei Starovoitov wrote:
> 1) Support BTF in kernel modules, from Andrii.
>=20
> 2) Introduce preferred busy-polling, from Bj=C3=B6rn.
>=20
> 3) bpf_ima_inode_hash() and bpf_bprm_opts_set() helpers, from KP Singh.
>=20
> 4) Memcg-based memory accounting for bpf objects, from Roman.
>=20
> 5) Allow bpf_{s,g}etsockopt from cgroup bind{4,6} hooks, from Stanislav.

Pulled, thanks!
