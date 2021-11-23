Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5269C459F0F
	for <lists+netdev@lfdr.de>; Tue, 23 Nov 2021 10:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbhKWJS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 04:18:28 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:58941 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230306AbhKWJS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Nov 2021 04:18:27 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 3395F5C00E8;
        Tue, 23 Nov 2021 04:15:12 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 23 Nov 2021 04:15:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; bh=F3vX88aVOVx8OXXCHIjAEyKki6Zq3T71802Dd6SOn
        BM=; b=OgPiZnOwlWxgYuJvUAVKk5VFMEzi0BFk2xRpcSTOJmEgsG22UWTybpzT1
        B7oNKiyNfLo0N0YofaWo+0a6zdyHi9kCvXNkpShrT1r94Mus0bOGQqD48RG5oGvY
        03gHs2uW5ZGWzN0nKytAJONG1YEKZ3HBUAc1M0tbf/cqNGBNWxhw0qpJ4L7ZH3J8
        xZn7bwJGktc1NJEyQOgsQInwOHbe/CAVyEQ2SuxTFMwWWw5a+uU13oV2hkgMRhOL
        EcHgIc58gUMskEtqfHV2KRmLWnrz3LWd9DRv4z1kTfm7mG2aqT+5Ylkk7v9RYrWq
        fzyO/VgdAGGxpwSuTdHYx8LkIlYvA==
X-ME-Sender: <xms:H7GcYSTDOzkQ6TeJaeu9GXhRK2zpcEtTj1QBDEyhn4yHp_svhet8OA>
    <xme:H7GcYXyK6nTaXx0R4k3MwXhOvwjkQFQoUn4_sCXoGdxQ_Sqv1XT8qghUn4cAmMDnQ
    s0oT9KaWVFpe0E>
X-ME-Received: <xmr:H7GcYf22-Klx0qFuYGxWPyNYL2usybZ5_fDFtfFu1MLgKhB8p5BMTTa0_KpkZe_FgmTdliTlAGYoOVXlSqixhqhA120cYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrgeeigddtudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeugfejfeeviedvkedtgfeghfegvedugeevgfetudfgteevveeutdfghfekgfeg
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:H7GcYeCjbC9bGkxYQxIqi7hsjYHyQIqAFHgXb7TxsjaIKIvYulVwiA>
    <xmx:H7GcYbjKQFuxWEqI1LjEumNsutCM48ULlZ91pbOVSMJVBZw4PxnB2g>
    <xmx:H7GcYao8PgMHQegC29dDz8F5_ybddZeUpcm8OI6XaqoOVdFk4LAnuw>
    <xmx:ILGcYWU5cJdksToKhMh5rszWcEu3xn3eIMTrnX9nUMvW0ka5WCy9Sg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 23 Nov 2021 04:15:11 -0500 (EST)
Date:   Tue, 23 Nov 2021 11:15:08 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     Denis Kirjanov <dkirjanov@suse.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jiri@nvidia.com, mlxsw@nvidia.com,
        Danielle Ratson <danieller@nvidia.com>,
        Eric Biederman <ebiederm@xmission.com>,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next 2/2] mlxsw: pci: Add shutdown method in PCI
 driver
Message-ID: <YZyxHPsiWMYdAkb2@shredder>
References: <20211123075447.3083579-1-idosch@idosch.org>
 <20211123075447.3083579-3-idosch@idosch.org>
 <34c443a5-c36b-2a16-adda-222da6dc5238@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <34c443a5-c36b-2a16-adda-222da6dc5238@suse.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 23, 2021 at 11:47:34AM +0300, Denis Kirjanov wrote:
> 
> 
> 11/23/21 10:54 AM, Ido Schimmel пишет:
> > From: Danielle Ratson <danieller@nvidia.com>
> > 
> > On an arm64 platform with the Spectrum ASIC, after loading and executing
> > a new kernel via kexec, the following trace [1] is observed. This seems
> > to be caused by the fact that the device is not properly shutdown before
> > executing the new kernel.
> 
> This should be sent to net tree instead of net-next with Fixes tag added.

This is not a regression (never worked) and the system does not crash.
The trace is only observed on a specific platform and only with kexec
which I assume nobody is using but our team (for development purposes).

Therefore, I prefer to route it via net-next. If users complain
(unlikely), I will send backports to stable kernels.
