Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDB412E07B9
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 10:11:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725999AbgLVJLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 04:11:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:50316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725913AbgLVJL3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Dec 2020 04:11:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8466422AAA;
        Tue, 22 Dec 2020 09:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608628249;
        bh=3MGNn+T0DK/QA19xAfscv5HuM4Wtvho4k9kLk2WI6EY=;
        h=In-Reply-To:References:Cc:To:Subject:From:Date:From;
        b=dAzq632SFv6pqTs5DxKbcJ+FxzkNHbiKsA6yDUXEuSAuxZX4ibgNIBsSsjzv0QCbG
         TNCIUFlJx8dEtAYYkBFtGsnbCLfXNYBS31HUk4K8Z528WRTgjIjXyHbvhHunPYApgM
         3+/J4lki0JHOqW5p4oKZyFbFF/plJaSiCDZhCqGkNa1+CYTW25LKtLeR78iTM83gHw
         JXQiFhvD5FdKyUWgZd0Y3aCdKIaq+tTUgndn7JAb/HSx/zzx3edMqpZJRAKA6QVIJQ
         PIQ+UzlzRWBQ5ygZl4TpZH74XouQzwb8ie+KxKjYH1i9yEdsFJk+jRXb2FmhS5AnGl
         +MtM/2MMgbo1g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <CAKgT0UfsRY8zeYwhuy0kaMozTrfs+9RxTtXpyf2iD1Rcb-J52g@mail.gmail.com>
References: <20201221193644.1296933-1-atenart@kernel.org> <20201221193644.1296933-3-atenart@kernel.org> <CAKgT0UfsRY8zeYwhuy0kaMozTrfs+9RxTtXpyf2iD1Rcb-J52g@mail.gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Netdev <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>
To:     Alexander Duyck <alexander.duyck@gmail.com>
Subject: Re: [PATCH net v2 2/3] net: move the xps cpus retrieval out of net-sysfs
From:   Antoine Tenart <atenart@kernel.org>
Message-ID: <160862824605.1246462.184375210575519778@kwain.local>
Date:   Tue, 22 Dec 2020 10:10:46 +0100
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

Quoting Alexander Duyck (2020-12-21 23:33:15)
>=20
> One thing I might change is to actually bump this patch up in the
> patch set as I think it would probably make things a bit cleaner to
> read as you are going to be moving the other functions to this pattern
> as well.

Right. If it were not for net (vs net-next), I would have split the
patches a bit differently to make things easier to review. But those
patches are fixes and can be backported to older kernel versions.
They're fixing 2 commits that were introduced in different versions, so
this patch has to be made before the next one, as it is fixing older
kernels.

(I also did not give an hint in the commit message to what is done in
patch 3 for the same reason. But I agree that's arguable.)

Thanks,
Antoine
