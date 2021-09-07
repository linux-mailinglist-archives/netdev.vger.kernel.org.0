Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BECA5402A98
	for <lists+netdev@lfdr.de>; Tue,  7 Sep 2021 16:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237256AbhIGOS5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Sep 2021 10:18:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233562AbhIGOS4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 7 Sep 2021 10:18:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EB98360F13;
        Tue,  7 Sep 2021 14:17:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631024270;
        bh=dcmRPyL/PJfIGpNDTnlKx6lkCRoO9BTFpskCg4UYFJQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cMccWyUlo5knceXzOBu4yKbsW6n3e+L0TLv8y85Umc9EWqQpLynUzb9manjsoRn4U
         Eb2ZZWsgOFqtlVEHfSNlA5cFRHJIDyTaMI6d/IRagTNTDTRwLDqEKuQ761/nK5TDvQ
         FymSlQ+wt7Vb/UpCocDkIHTNk47leI4jGCFC5ZPyoDhGB5hIgEWLQbaHAcirqO72WU
         GelZIw4YjbKq32j3PXImeIAVZ5Ee+03MmwBYtmQJfT08XrTPxSN2jo3wWCKd+rhlLp
         0cy0UrOEVyqAah6aDIoIGHxkfFzVgQax6NON25GQiQ+LSK2rbe90rZ+RzjdidKIOLe
         nB9vTU8evC12A==
Date:   Tue, 7 Sep 2021 07:17:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        patchwork-bot+netdevbpf@kernel.org, vivien.didelot@gmail.com,
        olteanv@gmail.com, davem@davemloft.net, netdev@vger.kernel.org,
        rafal@milecki.pl
Subject: Re: [PATCH] net: dsa: b53: Fix IMP port setup on BCM5301x
Message-ID: <20210907071749.69225d50@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8c81f173-88da-64e6-69e1-bf824b3a99ab@gmail.com>
References: <20210905172328.26281-1-zajec5@gmail.com>
        <163086540526.12372.2831878860317230975.git-patchwork-notify@kernel.org>
        <5de7487c-4ffe-bca4-f9a3-e437fc63926b@gmail.com>
        <YTVlYqzeKckGfqu0@lunn.ch>
        <20210906184838.2ebf3dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8c81f173-88da-64e6-69e1-bf824b3a99ab@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Sep 2021 07:35:09 +0200 Rafa=C5=82 Mi=C5=82ecki wrote:
> Do you already have some special meaning for the "Under Review"? That
> sounds (compared to the "New") like someone actually planning to (n)ack
> a patch.

Under Review means patch has passed the basic triage and will be applied
to netdev trees unless instructed otherwise. Practically speaking it's=20
not expected to go via any sub-tree and the patchwork build bot=20
results look sane.

At least that's what it used to mean, with the advances in automatic
delegation it seems that Dave is using the state less these days, I
still follow the old protocol.

Sub-maintainers in netdev are historically asked not to change
patchwork state. The review delegation does not really work great for
netdev, since there can only be one delegate and we use it to split
user space tools vs netdev vs bpf. A more flexible scheme where
maintainer remains as a delegate but multiple reviewers can be attached
would be great, that's what I was alluding to earlier.
