Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DCAE422C47
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 17:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235921AbhJEPXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 11:23:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229936AbhJEPXx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 11:23:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 219E061165;
        Tue,  5 Oct 2021 15:22:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633447322;
        bh=dy4Pbx/u37op3cyiFKAO9wWej5io68NapucgdT7CYc8=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=Kr/8i3vCV7AmEplVPGdeBOmvLWQ7fi7qh/yFaqvIbqGAlUNVukVve5rdCJnnbK9/A
         I1eXyhu0HzohsdObHQfdQlmM/nRRKBB/D1ruF1woiPy9RGQdya01//b0ZQwA4QXMuI
         ulARi8iIo3WXKvySAsYSzlsCHGfbeLup0XVl3Br94vkod6gR/gSbRMU/AQo1WwYly8
         Hf4Pksg1d/YLx4APeDRHgAaaXnsrMfDWHeDBYmXC8XCWqjDkalWeRsRyIpfYwOzPpS
         GWnV7OJjptoM8noKRna2zo4W85k+a4w7b2FsIBgCqGoGJXSFCq3bBCcV1EQyta1ntn
         q4jblzFNecc3g==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20210928125500.167943-1-atenart@kernel.org> <20210928125500.167943-9-atenart@kernel.org> <20210928170229.4c1431c7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com> <163290399584.3047.8100336131824633098@kwain> <20210929063126.4a702dbd@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Subject: Re: [RFC PATCH net-next 8/9] net: delay device_del until run_todo
From:   Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, pabeni@redhat.com, gregkh@linuxfoundation.org,
        ebiederm@xmission.com, stephen@networkplumber.org,
        herbert@gondor.apana.org.au, juri.lelli@redhat.com,
        netdev@vger.kernel.org
To:     Jakub Kicinski <kuba@kernel.org>
Message-ID: <163344731953.4226.7213722603777320810@kwain>
Date:   Tue, 05 Oct 2021 17:21:59 +0200
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Jakub Kicinski (2021-09-29 15:31:26)
>=20
> Well, it's a little wobbly but I think the direction is sane.

> FWIW the other two pieces of feedback I have is try to avoid the
> synchronize_net() in patch 7 and add a new helper for the name
> checking, which would return bool. The callers don't have any=20
> business getting the struct.

I'll work on an RFC v2 including modifications discussed in this thread
(especially the ones raised about queues attributes; investigating if it
can be fixed). I might send the patches about the name checking helper
separately to reduce the size of the series, as I think they bring value
outside of it.

(In the meantime suggestions or reviews from others are still welcomed).

BTW, what are your thoughts on patch 1? It is not strictly linked to the
others (or to other solutions that might arise).

Thanks!
Antoine
