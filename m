Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DAE2BB0EB
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:49:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730107AbgKTQss (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:48:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:53292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728827AbgKTQsr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 11:48:47 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 12967206FB;
        Fri, 20 Nov 2020 16:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605890927;
        bh=6cdfz+OjsJnQfPPCPsvdKO4ZVbm0K5mHBtIQ/09+5+4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=vIWlkUuvfsVuH48gK0aO72ldd19TDIvPf7N0oi7bmtfcD7+SMgDLCur1HPyYOs5pr
         cbvxKcDZR73ewrOFjK4g7zKUpW7LCgtT4dCTb8XUqkt9AYd5wkdHrAn7xKdvHCHmgY
         hUjyidx9QNtoNwqai/qufcoIERax/rjfhLcHPVyo=
Date:   Fri, 20 Nov 2020 08:48:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     Jiri Pirko <jiri@mellanox.com>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: Is test_offload.py supposed to work?
Message-ID: <20201120084846.710549e8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <87y2iwqbdg.fsf@toke.dk>
References: <87y2iwqbdg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 16:46:51 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> Hi Jakub and Jiri
>=20
> I am investigating an error with XDP offload mode, and figured I'd run
> 'test_offload.py' from selftests. However, I'm unable to get it to run
> successfully; am I missing some config options, or has it simply
> bit-rotted to the point where it no longer works?

Yeah it must have bit rotted, there are no config options to get
wrong there AFAIK.

It shouldn't be too hard to fix tho, it's just a python script...
