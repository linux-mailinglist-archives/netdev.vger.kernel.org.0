Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E972326B6
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbgG2VWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:22:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:39162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgG2VWQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:22:16 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1DAF22068F;
        Wed, 29 Jul 2020 21:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596057736;
        bh=R/SnA4dy+M9pXvEY2O6moF3uJYjIOkLplQgLwCZ5Olk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=w4w94eACwq+XKCsLMBbuDk21lsKQfSX5lzTsv3u3U/J+lMaxoNv0lSQ8JokzUW/Ak
         69CQa0WI0zdVDSD/5geJO4JUJa2NSdSINo31GlySTR2MBQ30qfJBf6VVdnrQ0H1OjS
         MSFpzo8DdUiqrNaUeX0sKtNWJA3CU6XKzrsedgk0=
Date:   Wed, 29 Jul 2020 14:22:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        netdev@vger.kernel.org, nhorman@redhat.com, sassmann@redhat.com,
        jeffrey.t.kirsher@intel.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: Re: [net-next 5/6] i40e, xsk: increase budget for AF_XDP path
Message-ID: <20200729142214.312fd108@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <0439597f-9c1f-a289-edd9-c890baa687da@intel.com>
References: <20200728190842.1284145-1-anthony.l.nguyen@intel.com>
        <20200728190842.1284145-6-anthony.l.nguyen@intel.com>
        <20200728131512.17c41621@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <0439597f-9c1f-a289-edd9-c890baa687da@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jul 2020 12:43:46 +0200 Bj=C3=B6rn T=C3=B6pel wrote:
> > Should this perhaps be a common things that drivers do?
> >=20
> > Should we define a "XSK_NAPI_WEIGHT_MULT 4" instead of hard coding the
> > value in a driver?
>=20
> Yes, that's a good idea. I can generalize for the AF_XDP paths in the=20
> other drivers as a follow up!

I don't like followups 'cause there's no way I can track if everyone
actually does what I asked them to - but since you're in vacation mode,
let's say this one's fine as a follow up ;)
