Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28B9C27EF40
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 18:31:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731132AbgI3Qbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 12:31:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:57842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgI3Qbd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 12:31:33 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A01622072E;
        Wed, 30 Sep 2020 16:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601483493;
        bh=17Hn8hunUNPsI/Ri//wOwZHoYL5wJOoQnIZ5rll1kes=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TKuDWCATDWTXUyc7HZrTUesf4kCW/GGl0lCPMPLvRimAHv2RlTP40FIkxTtZeP95d
         FU13AAss/8Zd7BZXb8dCJxA/518G1oxu4i8oPz1QE2RgikFop5qDW37ZIxPzbDrsJF
         c32gBNQHo431laHIaH0yaRcaDmYUDev4mKBMPr7w=
Date:   Wed, 30 Sep 2020 09:31:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        sameehj@amazon.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        ast@kernel.org, shayagr@amazon.com, brouer@redhat.com,
        echaudro@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: Re: [PATCH v3 net-next 00/12] mvneta: introduce XDP multi-buffer
 support
Message-ID: <20200930093130.3c589423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <cover.1601478613.git.lorenzo@kernel.org>
References: <cover.1601478613.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Sep 2020 17:41:51 +0200 Lorenzo Bianconi wrote:
> This series introduce XDP multi-buffer support. The mvneta driver is
> the first to support these new "non-linear" xdp_{buff,frame}. Reviewers
> please focus on how these new types of xdp_{buff,frame} packets
> traverse the different layers and the layout design. It is on purpose
> that BPF-helpers are kept simple, as we don't want to expose the
> internal layout to allow later changes.

This does not apply cleanly to net-next =F0=9F=A4=94
