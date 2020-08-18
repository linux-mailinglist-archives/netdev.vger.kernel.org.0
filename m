Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA03A2489FE
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 17:37:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728000AbgHRPhS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 11:37:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726585AbgHRPhR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 18 Aug 2020 11:37:17 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED2D020786;
        Tue, 18 Aug 2020 15:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597765037;
        bh=MAFNON2hoxA7JMZPJzIk8T3rPJSmyITITona5n96o6w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=BkUCmiSKdQSIOgj6VXjPSb6vLBPevwrQyYVtcpyYtLYjse2rPJ94odnJPhumVCEPs
         DKFmFhO65zEct2I8D3Ui7CMCmU78ixU06xUECjIFa3l7SSAWJEtf2UphWKkimU6WHi
         qIcHeUD4OPMHnHGquAL3wsLDpGN6r2rEqJfL1uzg=
Date:   Tue, 18 Aug 2020 08:37:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@nvidia.com>
Cc:     Moshe Shemesh <moshe@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next RFC v2 01/13] devlink: Add reload action option
 to devlink reload command
Message-ID: <20200818083715.041b1b54@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9fbad1d6-7052-225a-7d62-9d29548d6342@nvidia.com>
References: <1597657072-3130-1-git-send-email-moshe@mellanox.com>
        <1597657072-3130-2-git-send-email-moshe@mellanox.com>
        <20200817091615.37e76ca3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <9fbad1d6-7052-225a-7d62-9d29548d6342@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 18 Aug 2020 12:06:13 +0300 Moshe Shemesh wrote:
> Or maybe better than "live" say explicitly "no reset":
>=20
>  =C2=A0=C2=A0=C2=A0 devlink dev reload DEV [ netns { PID | NAME | ID } ] =
[ action {=20
> driver_reinit | fw_activate [--no_reset] } ]

SGTM
