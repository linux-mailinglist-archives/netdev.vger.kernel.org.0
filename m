Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EFF101886CE
	for <lists+netdev@lfdr.de>; Tue, 17 Mar 2020 15:06:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726652AbgCQOGS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Mar 2020 10:06:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726187AbgCQOGS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Mar 2020 10:06:18 -0400
Received: from coco.lan (ip5f5ad4e9.dynamic.kabel-deutschland.de [95.90.212.233])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 81860205ED;
        Tue, 17 Mar 2020 14:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584453977;
        bh=DmaqvTgO1fmmMqgI6fMIcL8ag6suzOfDR3kPhV4+PwA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MCWCwGfnU+jb8ce35ywWcM47WdZTqfv4Ej/STM9Dw7MqFKaQ9sFNBXUhH0PJA7pE9
         qTD2mYziACOoGGIwTyBYLbP0CLGQc8ez0gbcnEvy2hBD4NHBP7z+lFwIPgGDCGPJ9D
         IettSkaEBTtKSQEL/Vf+Z+7EDfgo9+zMzzMQrC6Y=
Date:   Tue, 17 Mar 2020 15:06:09 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     Marc Kleine-Budde <mkl@pengutronix.de>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Benjamin Gaignard <benjamin.gaignard@st.com>,
        <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>
Subject: Re: [PATCH 04/12] docs: dt: fix references to m_can.txt file
Message-ID: <20200317150609.4d5c7c71@coco.lan>
In-Reply-To: <60f77c6f-0536-1f50-1b49-2f604026a5cb@ti.com>
References: <cover.1584450500.git.mchehab+huawei@kernel.org>
        <db67f9bc93f062179942f1e095a46b572a442b76.1584450500.git.mchehab+huawei@kernel.org>
        <376dba43-84cc-6bf9-6c69-270c689caf37@pengutronix.de>
        <60f77c6f-0536-1f50-1b49-2f604026a5cb@ti.com>
X-Mailer: Claws Mail 3.17.5 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Tue, 17 Mar 2020 08:29:45 -0500
Dan Murphy <dmurphy@ti.com> escreveu:

> Hello
>=20
> On 3/17/20 8:17 AM, Marc Kleine-Budde wrote:
> > On 3/17/20 2:10 PM, Mauro Carvalho Chehab wrote: =20
> >> This file was converted to json and renamed. Update its
> >> references accordingly.
> >>
> >> Fixes: 824674b59f72 ("dt-bindings: net: can: Convert M_CAN to json-sch=
ema") =20
>=20
> I am trying to find out where the above commit was applied
>=20
> I don't see it in can-next or linux-can. I need to update the tcan dt=20
> binding file as it was missed.
>=20
> And I am not sure why the maintainers of these files were not CC'd on=20
> the conversion of this binding.

=46rom Next/merge.log:

Merging devicetree/for-next (d047cd8a2760 scripts/dtc: Update to upstream v=
ersion v1.6.0-2-g87a656ae5ff9)
$ git merge devicetree/for-next
Removing scripts/dtc/libfdt/Makefile.libfdt
Removing scripts/dtc/Makefile.dtc
...
 create mode 100644 Documentation/devicetree/bindings/net/can/bosch,m_can.y=
aml
 delete mode 100644 Documentation/devicetree/bindings/net/can/m_can.txt

It sounds that those came from DT for-next branch.

Thanks,
Mauro
