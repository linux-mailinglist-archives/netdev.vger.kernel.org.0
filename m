Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CBE5288CE1
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 17:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389411AbgJIPgB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 11:36:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:46396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389274AbgJIPf7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 11:35:59 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B745121D6C;
        Fri,  9 Oct 2020 15:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602257759;
        bh=0H16x2V8iZAQoZE7aD/P9YoBrk40NBtJWJGDqRGTtd4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=a87OBLOU2LKqBc3eu3qcOt8PEdQLL5Zhs6xz/0hOo5j76zIzTRzXrWXw3NKAiKhJm
         3TFKNzrkrp1JaX5HIPljz0o4vKsPj7d/rLqknK4Kf5qcCrPQQgPo4kY1fMeT/TDNLo
         sXgCt2Se7iVGXV51Fd0mk07HNaz/QIDIkWudt3CU=
Date:   Fri, 9 Oct 2020 08:35:56 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Davide Caratti <dcaratti@redhat.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        mptcp@lists.01.org, Christoph Paasch <cpaasch@apple.com>,
        pabeni@redhat.com, Matthieu Baerts <matthieu.baerts@tessares.net>
Subject: Re: [PATCH net] net: mptcp: make DACK4/DACK8 usage consistent among
 all subflows
Message-ID: <20201009083556.4fc32c0b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <70c96303d6d9931aae1b1028aed016d807df0e20.1602001119.git.dcaratti@redhat.com>
References: <70c96303d6d9931aae1b1028aed016d807df0e20.1602001119.git.dcaratti@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  6 Oct 2020 18:26:17 +0200 Davide Caratti wrote:
> using packetdrill it's possible to observe the same MPTCP DSN being acked
> by different subflows with DACK4 and DACK8. This is in contrast with what
> specified in RFC8684 =C2=A73.3.2: if an MPTCP endpoint transmits a 64-bit=
 wide
> DSN, it MUST be acknowledged with a 64-bit wide DACK. Fix 'use_64bit_ack'
> variable to make it a property of MPTCP sockets, not TCP subflows.
>=20
> Fixes: a0c1d0eafd1e ("mptcp: Use 32-bit DATA_ACK when possible")
> Acked-by: Paolo Abeni <pabeni@redhat.com>
> Signed-off-by: Davide Caratti <dcaratti@redhat.com>

Applied, thanks!
