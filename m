Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A0C389D9C
	for <lists+netdev@lfdr.de>; Thu, 20 May 2021 08:20:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhETGV1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 May 2021 02:21:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58298 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhETGV0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 May 2021 02:21:26 -0400
Received: from galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE88AC061574;
        Wed, 19 May 2021 23:20:05 -0700 (PDT)
From:   Kurt Kanzenbach <kurt@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1621491602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uOWpubAeDjCq3jPJAikebk3RLTs9XtXurni2b2g7SlI=;
        b=iTnqVFsIA5J2cvm501sVzrkOic1IyiMj3G9oWvDY7pbtVpMcDBVpaxqfhJuvnds0HJa/km
        3UCEyPmC1WCBDD3VjzhK12G4HDrMpqXCjpr1Hne+3hOv8gCT4y2LwdG2eZaR6BAETWndna
        uadp1SDnpL+iemC3qMIzDZbHl3FqkixFN5Pw5QE+/yjSKh+iNj70/1givMuvqtAmnn0hMp
        WnB67S5cP5c91zSbhmdAQ86eP/Wn4RCMjzDx/v/iKI1w95j1yD6/vco6yLuQJa0TPL/Y1K
        meIULyfVuHksbMeiqjU/zhCP39BXq7SAO3QjEsKeop3zWaREue8ejBgFBGy2BQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1621491602;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=uOWpubAeDjCq3jPJAikebk3RLTs9XtXurni2b2g7SlI=;
        b=vIq9NEQZr2cyt2k/T3c+P9H3VOvIu1sJuNfexYOOAXlnHA4WexieJvZBntPDqJ05tEuOWM
        A/4MCLqE8eWOc/DA==
To:     "Nguyen, Anthony L" <anthony.l.nguyen@intel.com>,
        "brouer@redhat.com" <brouer@redhat.com>
Cc:     "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "Fijalkowski, Maciej" <maciej.fijalkowski@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "tylerjstachecki@gmail.com" <tylerjstachecki@gmail.com>,
        "ast@kernel.org" <ast@kernel.org>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "alexander.duyck@gmail.com" <alexander.duyck@gmail.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "ilias.apalodimas@linaro.org" <ilias.apalodimas@linaro.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sven.auhagen@voleatech.de" <sven.auhagen@voleatech.de>,
        "lorenzo@kernel.org" <lorenzo@kernel.org>
Subject: Re: [PATCH net v4] igb: Fix XDP with PTP enabled
In-Reply-To: <e4568dc225edd00122b35be37cef9fac68329508.camel@intel.com>
References: <20210503072800.79936-1-kurt@linutronix.de>
 <20210504102827.342f6302@carbon> <20210519153418.00c4cc42@carbon>
 <e4568dc225edd00122b35be37cef9fac68329508.camel@intel.com>
Date:   Thu, 20 May 2021 08:20:00 +0200
Message-ID: <87cztmgc4v.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed May 19 2021, Nguyen, Anthony L wrote:
> On Wed, 2021-05-19 at 15:34 +0200, Jesper Dangaard Brouer wrote:
>> Hi Maintainers,
>>=20
>> What is the status on this patch?
>
> I'm awaiting testing from our validation. They expect to finish by the
> end of the week; I'll send out the patch as soon as they've completed.
>

Thanks! I've got also a backport of this patch for v5.10.x, so that
people can use the latest LTS e.g., with PREEMPT_RT and working PTP and
XDP. Let me know if there's interest in it.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJHBAEBCgAxFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAmCl/5ATHGt1cnRAbGlu
dXRyb25peC5kZQAKCRB5KluBy5jwppJYEACQyg1sVvFCi0t+BRp4dhqyOclcGz7m
2Y90nHRqFTMYZDU49dd0G/gpWMJXea2mU3HBwzwyZPHUBOtE+G9auDQQJC1rayyb
Q+MslQGk7HpXchuQkTqaXbP3OKXBkP3vLLr+Acxkbo8gpemnGc9ADuwjn6YAcnSX
l6g3Ipeo02SMGQAWsbUXB2PVS5/+tw3SP+5tbZ75BMzH/qYkb3bt6rtVmtU0vw+H
5p82NH9Xc/lGAM4yELtjYSd4JCDwPMNnU69SVRK52xZ4UOv/+Kjh8Dh7Y7/nNa+Y
ud5AXuIrd8FyFS40dl0kxINK/dDsvYQDKuWHR0l8M9ViBif+fBLWBX5TYNIp4a+a
5vLc8S38QZ0Um7H+K47I17fGTXT6jnNMHvvtALMyTErFIOSa8ysHNom7NlBDCZ61
A4PZk5EGKLUBwSn3phSNdeT0RU3AL5LMZcn00LMnYZuNfUavF1mmCMPXvGExxvUN
c02ChNRLN1l23NdM13RnyaWR7X94qI51EPJYIQPm/NPflcCJDVwo6pfLsHSKKzOt
pBYmsKiQu4WKbrZ9/+12HVPL8RjjSKi5QIX74f2d/83Vl2qXiSVGpjEleaUrAJfk
rfVC6KI4kpvURMnl9hUr310Xm5oD97mKA1pIsgDmJsnuQtcjF6q++VUc7n+8Km1T
qVekB9Xhnv6kvg==
=a0rv
-----END PGP SIGNATURE-----
--=-=-=--
