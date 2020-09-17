Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44EDE26E607
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 22:02:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726366AbgIQUCe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Sep 2020 16:02:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:60568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726236AbgIQUCe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Sep 2020 16:02:34 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0A0F206CA;
        Thu, 17 Sep 2020 20:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600372953;
        bh=V8boZKXwyXhlFi2SQ3QARv06uW1Z3L3xEG8orIUncV8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TBH+qdiTIGDvS0Tjqp0ba3p9OdjUXYYtV1IrGMrZa0tMdc2tKF3hGDdLzjv5v9/W8
         GtxW5j+Knm4eFPWhoWy1EhTgVRJvH7iDWMrFcg7ECzUyQi2wKed+aBHfjm6yeLVhD/
         WVrn8mznBJ0oTy2qEJfutQWpm9dTRKJMZP6BGwAA=
Date:   Thu, 17 Sep 2020 13:02:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [PATCH net-next] ionic: add DIMLIB to Kconfig
Message-ID: <20200917130231.65770423@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a17b550c-1db1-d32e-f69c-d51bb4a1ca2b@pensando.io>
References: <20200917184243.11994-1-snelson@pensando.io>
        <20200917120243.045975ac@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <a17b550c-1db1-d32e-f69c-d51bb4a1ca2b@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 17 Sep 2020 12:08:45 -0700 Shannon Nelson wrote:
> On 9/17/20 12:02 PM, Jakub Kicinski wrote:
> > On Thu, 17 Sep 2020 11:42:43 -0700 Shannon Nelson wrote: =20
> >>>> ld.lld: error: undefined symbol: net_dim_get_rx_moderation =20
> >>     >>> referenced by ionic_lif.c:52 (drivers/net/ethernet/pensando/io=
nic/ionic_lif.c:52)
> >>     >>> net/ethernet/pensando/ionic/ionic_lif.o:(ionic_dim_work) in ar=
chive drivers/built-in.a =20
> >> -- =20
> > This is going to cut off the commit message when patch is applied. =20
>=20
> Isn't the trigger a three dash string?=C2=A0 It is only two dashes, not=20
> three, and "git am" seems to work correctly for me.=C2=A0 Is there a=20
> different mechanism I need to watch out for?

I got a verify_signoff failure on this patch:

Commit a92faed54662 ("ionic: add DIMLIB to Kconfig")
	author Signed-off-by missing
	author email:    snelson@pensando.io

And in the tree I can see the commit got cut off.=20

Maybe it's some extra mangling my bot does. In any case, I wanted to
at least give Dave a heads up.
