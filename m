Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C5B327EE9B
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:11:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731265AbgI3QLO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:11:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:38252 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731051AbgI3QLO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:11:14 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 717A8206F7;
        Wed, 30 Sep 2020 16:11:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601482273;
        bh=cQWseiSFvdblbJ+r6zb6axVKMotJKNIdrHn7WRrsb+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uZoMpK72ah+m4mxBKtCeHY9qnznO6GWqF+Tw+rIRf8vSxDdOIzGTWDmxNw3yUGmsZ
         1MBJ1aOGzxlQ1ABbSQOgmFWLAsaEIXmvs3Rlq0qx2EfUISpRskPziYkrvGp5Hz5Mz3
         o5ym0oUOuMCW3idCIVL8L2A4YfVXOyHuxdV73vw8=
Date:   Wed, 30 Sep 2020 09:11:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jiri Pirko <jiri@resnulli.us>, johannes@sipsolutions.net,
        dsahern@kernel.org, pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930091112.49c216e2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200930160303.uymslyt5isgzcl67@lion.mk-sys.cz>
References: <20200930084955.71a8c0ba@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200930160303.uymslyt5isgzcl67@lion.mk-sys.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 18:03:03 +0200 Michal Kubecek wrote:
> On Wed, Sep 30, 2020 at 08:49:55AM -0700, Jakub Kicinski wrote:
> > Hi!
> >=20
> > I'd like to be able to dump ethtool nl policies, but right now policy
> > dumping is only supported for "global" family policies.
> >=20
> > Is there any reason not to put the policy in struct genl_ops,=20
> > or just nobody got to it, yet?
> >=20
> > I get the feeling that this must have been discussed before... =20
>=20
> It used to be per-cmd but with common maxattr which didn't make much
> sense. In 5.2 cycle, commit 3b0f31f2b8c9 ("genetlink: make policy common
> to family") changed it to common policy for each family.

Interesting =F0=9F=A4=94
