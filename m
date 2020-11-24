Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FAB32C2CB8
	for <lists+netdev@lfdr.de>; Tue, 24 Nov 2020 17:22:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390378AbgKXQV5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 11:21:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:56038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390367AbgKXQV5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 11:21:57 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C8D120715;
        Tue, 24 Nov 2020 16:21:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606234916;
        bh=GjdpPd0YVe4JnlTabDKyPkCEnuLaEUJR5g0XA7bdCPw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=z0oZGxSSCfePGNVS/cWWmpOUBbcg0VMNghCgMmErBwTxIHmeBFnBC0W5ox4PLTFCg
         jqL+xfVJfgYxFaNIaAZcMTF1l+Sqxt9Jzxbbpl+wClp1UqjsqNwHx+YCKF6Rot++ib
         z/bH3k3Wp0lX/ZdQ+nYdrJrNAXF+BvGTF+C4UGAg=
Date:   Tue, 24 Nov 2020 08:21:55 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        =?UTF-8?B?QmrDtnJuIFQ=?= =?UTF-8?B?w7ZwZWw=?= 
        <bjorn.topel@intel.com>, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, maciej.fijalkowski@intel.com,
        sridhar.samudrala@intel.com, jesse.brandeburg@intel.com,
        qi.z.zhang@intel.com, edumazet@google.com,
        jonathan.lemon@gmail.com, maximmi@nvidia.com
Subject: Re: [PATCH bpf-next v3 02/10] net: add SO_BUSY_POLL_BUDGET socket
 option
Message-ID: <20201124082155.1642cf1f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119083024.119566-3-bjorn.topel@gmail.com>
References: <20201119083024.119566-1-bjorn.topel@gmail.com>
        <20201119083024.119566-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 09:30:16 +0100 Bj=C3=B6rn T=C3=B6pel wrote:
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>=20
> This option lets a user set a per socket NAPI budget for
> busy-polling. If the options is not set, it will use the default of 8.
>=20
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
