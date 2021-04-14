Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5335FB0A
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 20:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353126AbhDNSsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 14:48:08 -0400
Received: from box.ubports.com ([157.230.16.225]:46303 "EHLO box.ubports.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353113AbhDNSrc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 14:47:32 -0400
X-Greylist: delayed 463 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Apr 2021 14:47:32 EDT
Received: from authenticated-user (box.ubports.com [157.230.16.225])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.ubports.com (Postfix) with ESMTPSA id 94991FC141;
        Wed, 14 Apr 2021 20:39:23 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ubports.com; s=mail;
        t=1618425565; bh=IU9kl+tKHDI/AVZXyWUUVfrMt7KW8cClQ9lihOFs4JE=;
        h=Date:From:To:Cc:In-Reply-To:References:Subject:From;
        b=NGwnT2TMvB+8eLnHpKAfB4K+iytgjOwklPWnCgl0iTlhR7bUFPq6i1GyDQykBLhQr
         I81eLkrV4cSDtgBW6LHXcV3Z5S/9rdCBE7HNPXObEsfMEVOPgCMdoUy16xv1RsAO01
         RroQ+Xng1t7qtxIbek8nap1Ph2CjeryU8Q8uaHpPKeYfbukzlFtydw7xfb6OUoVfoK
         DIOZURS2beu98Jg9nFkqzd2F4k8eRh4fZaajB/aBPl3/d5fZO0DBxTM5kHSSVgA7S7
         mssUoAgenh7rBcSrxx8Pf63hWxKh1isQBo6e8RVH6AZ0eBhHrgKBrDIZ1L/g2zAuX+
         0PzPcvE3eu8mA==
Date:   Wed, 14 Apr 2021 18:39:11 +0000 (UTC)
From:   Marius Gripsgard <marius@ubports.com>
To:     Chris Talbot <chris@talbothome.com>
Cc:     ofono@ofono.org, netdev@vger.kernel.org,
        debian-on-mobile-maintainers@alioth-lists.debian.net,
        librem-5-dev@lists.community.puri.sm, 982250@bugs.debian.org,
        985893@bugs.debian.org
Message-ID: <9acefe05-29ab-4cb9-8fef-982eb9deb79a@ubports.com>
In-Reply-To: <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
References: <051ae8ae27f5288d64ec6ef2bd9f77c06b829b52.camel@talbothome.com> <634e0debea558b90af2cebfc99518071f1d630e9.camel@talbothome.com>
Subject: Re: Forking on MMSD
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Correlation-ID: <9acefe05-29ab-4cb9-8fef-982eb9deb79a@ubports.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

I would really like to avoid a fork, it's not worth doing dual work. Did yo=
u ping ofono devs at irc?=C2=A0 Also have you sendt upstream patches? If a =
fork is the way you want to go, you will need to rename it as the existing =
packages need to follow upstream, we can't just rip an existing packages aw=
ay from upstream.

Best regards,
Marius

Apr 14, 2021 20:21:18 Chris Talbot <chris@talbothome.com>:

> Hello All,
>=20
> In talking to the Debian Developer Mr. Federico Ceratto, since I have
> been unable to get a hold of the Ofono Maintainers, the best course of
> action for packaging mmsd into Debian is to simply fork the project and
> submit my version upstream for packaging in Debian. My repository is
> here: https://source.puri.sm/kop316/mmsd/
>=20
> I am sending this so the relavent parties are aware of this, and to
> indicate that I no longer intend on trying to get a hold of upstream
> mmsd to try and submit patches.
>=20
> For the Purism Employees, I am additionally asking for permission to
> keep hosting mmsd on https://source.puri.sm/ . I have been extremely
> appreciative in using it and I am happy to keep it there, but I want to
> be neighboorly and ask if it is okay for me to keep it there. If it is
> not, I completely understand and I am fine with moving it to a new
> host.
>=20
> If you have any questions, comments, or concern, please reach out to
> me.
>=20
> --=20
> Respectfully,
> Chris Talbot
> _______________________________________________
> ofono mailing list -- ofono@ofono.org
> To unsubscribe send an email to ofono-leave@ofono.org
