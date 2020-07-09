Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A52821A5E1
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 19:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGIReH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 13:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:52948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726615AbgGIReH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Jul 2020 13:34:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1999E20767;
        Thu,  9 Jul 2020 17:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594316047;
        bh=SPGQ1sa0JgfZY23ntRsbwfVMgGUawZLfsODhp/xcKtg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dgXSJ7lvMQp/gMblvapDtjgCKweQhoYiLJ5Is5mEUiUxCZ8ObCdP/44tmytexaq88
         gAdMtWgllnz4Cj7rjtDQPkO87l7su/C1YDINZRV4oF/i9KmsewH7YThr5318gVIH4X
         61cI538I6RNh1vH2xpJ2KybAwo7OcqbZ56DNdNuw=
Date:   Thu, 9 Jul 2020 10:34:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>, mptcp@lists.01.org
Subject: Re: [PATCH net-next 3/4] mptcp: add MPTCP socket diag interface
Message-ID: <20200709103405.0075678b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <7f9e6a085163dcb0669b9dd8aace1c62373279db.1594292774.git.pabeni@redhat.com>
References: <cover.1594292774.git.pabeni@redhat.com>
        <7f9e6a085163dcb0669b9dd8aace1c62373279db.1594292774.git.pabeni@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  9 Jul 2020 15:12:41 +0200 Paolo Abeni wrote:
> exposes basic inet socket attribute, plus some MPTCP socket
> fields comprising PM status and MPTCP-level sequence numbers.
>=20
> Reviewed-by: Mat Martineau <mathew.j.martineau@linux.intel.com>
> Signed-off-by: Paolo Abeni <pabeni@redhat.com>

Any idea why sparse says this:

include/net/sock.h:1612:31: warning: context imbalance in 'mptcp_diag_get_i=
nfo' - unexpected unlock

? =F0=9F=A4=A8
