Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F89956E91
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 18:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726465AbfFZQSo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 12:18:44 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37937 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726341AbfFZQSo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jun 2019 12:18:44 -0400
Received: by mail-qt1-f196.google.com with SMTP id n11so3005727qtl.5
        for <netdev@vger.kernel.org>; Wed, 26 Jun 2019 09:18:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=N9efE1dUheWMcuiyqvQjZCmEIhyTmacLrrlicl94Iew=;
        b=MU1URNcYye1685BSOKUyIVPNJMNJL0TJ/esUwEwe640A6KhrIkRlLgExKrVeTwRyaW
         +8VNMFCH/iScsLkhaoc82PAlj/djXVQpNkdG87rKLMz2BY0w93kZF09FEljlamzlboCf
         IoAoPzimMNnCnTUdakXCb74pYO/sQpysASx/L9ryU/IAltz6IVjpNPEm9LXC/jJl8pW/
         6qDQTdUj0H4w0kDOtNY/FGHQ9ShMEAMnBAlCVL4tGmgAaJMnqvTqkgXIdc4G+CW6v2ZQ
         jAAE9vwOY0ss8mKtImw+WGi2gdsaAEzeql8K28rjwtD507iLnJIaEMls9beKWI6HqyOw
         2tMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=N9efE1dUheWMcuiyqvQjZCmEIhyTmacLrrlicl94Iew=;
        b=hyy5PeE8QIuvJWVchG7GWzbij7+yAvLa7C2jC2DcLls55znI5C284a61XioxwRSnJD
         5So/P/iWsVrMINB5Yucg9HuJNGQpY0nb5olQk2qgz/yTG03TPF+oZ+cQW0dimU1DXc7O
         SEA7k6uLfZp3Q+KrMy+0QstGqrHX76oW4nQmRywHuSTM9ZiVVL5XzoasXIPU34Nl2Kr9
         x2mGB5VmOafs4vMRl4/vc/DaRxgi39OVIM5pfqcpmM08Jywpt7Ugs4Nm0tXD2E0V9S+h
         eePJDQVVQ/EP212FQ7mJnoTfi5eCJBWIDWEC9Kuhsqo9cQhUvHMfWmRv+5saQ3F97xPO
         VLsg==
X-Gm-Message-State: APjAAAWWPfTF+cLkTKWuo0N1NKB3Uj71X5/CF7Of2A2eL0udyct6Mwq+
        bk2oCCdUTMhGnDz1C9NgF+r6JQ==
X-Google-Smtp-Source: APXvYqy8HvKLDfYAQ44wE/xateVpCG2UfZXAD+ZNtGEM2vbgJJRMqo5pQWUNow5BRGqJp+s8t//oIA==
X-Received: by 2002:ac8:4687:: with SMTP id g7mr4115584qto.213.1561565923460;
        Wed, 26 Jun 2019 09:18:43 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id g54sm11522343qtc.61.2019.06.26.09.18.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 26 Jun 2019 09:18:43 -0700 (PDT)
Date:   Wed, 26 Jun 2019 09:18:38 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-next 13/18] ionic: Add initial ethtool support
Message-ID: <20190626091838.03dfca5b@cakuba.netronome.com>
In-Reply-To: <4ffa2c70-9ae7-15eb-3b21-34148de89b44@pensando.io>
References: <20190620202424.23215-1-snelson@pensando.io>
        <20190620202424.23215-14-snelson@pensando.io>
        <20190625165412.0e1206ce@cakuba.netronome.com>
        <4ffa2c70-9ae7-15eb-3b21-34148de89b44@pensando.io>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 26 Jun 2019 09:07:29 -0700, Shannon Nelson wrote:
> On 6/25/19 4:54 PM, Jakub Kicinski wrote:
> > On Thu, 20 Jun 2019 13:24:19 -0700, Shannon Nelson wrote: =20
> >> +	running =3D test_bit(LIF_UP, lif->state);
> >> +	if (running)
> >> +		ionic_stop(netdev);
> >> +
> >> +	lif->ntxq_descs =3D ring->tx_pending;
> >> +	lif->nrxq_descs =3D ring->rx_pending;
> >> +
> >> +	if (running)
> >> +		ionic_open(netdev);
> >> +	clear_bit(LIF_QUEUE_RESET, lif->state);
> >> +	running =3D test_bit(LIF_UP, lif->state);
> >> +	if (running)
> >> +		ionic_stop(netdev);
> >> +
> >> +	lif->nxqs =3D ch->combined_count;
> >> +
> >> +	if (running)
> >> +		ionic_open(netdev);
> >> +	clear_bit(LIF_QUEUE_RESET, lif->state); =20
> > I think we'd rather see the drivers allocate/reserve the resources
> > first, and then perform the configuration once they are as sure as
> > possible it will succeed :(  I'm not sure it's a hard requirement,
> > but I think certainly it'd be nice in new drivers. =20
> I think I know what you mean, but I suspect it depends upon which=20
> resources.=C2=A0 I think the point of the range checking already being do=
ne=20
> covers what the driver is pretty sure it can handle, as early on it went=
=20
> through some sizing work to figure out the max queues, interrupts,=20
> filters, etc.

Yes, hopefully those don't fail.

> If we're looking at memory resources, then it may be a little harder:=20
> should we try to allocate a whole new set of buffers before dropping=20
> what we have, straining memory resources even more, or do we try to=20
> extend or contract what we currently have, a little more complex=20
> depending on layout?
>=20
> Interesting...

Indeed. I think whichever is simpler :) Either way we get shorter
traffic disruption and avoid the risk of "half up" interfaces..
