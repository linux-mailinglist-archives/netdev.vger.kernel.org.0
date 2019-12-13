Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5D4111DBBF
	for <lists+netdev@lfdr.de>; Fri, 13 Dec 2019 02:37:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731825AbfLMBh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Dec 2019 20:37:29 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:41492 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727070AbfLMBh3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Dec 2019 20:37:29 -0500
Received: by mail-pg1-f196.google.com with SMTP id x8so684165pgk.8
        for <netdev@vger.kernel.org>; Thu, 12 Dec 2019 17:37:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=KOiRk1GvUmbAW7om9IhrODhWlT9GJilv/uiLD9Q5hoI=;
        b=L5vDaTv+SMKK37n1rYxlY3kIR3g2f+ns2UcWf4TBFTz6Pw6Xg0XL98dD4EVPp2rfPM
         voJ2ZJHRYu9OcaK6bGdY0vIBZoxRTQmQtcOg7OQ0WPfuKwAw2gf3VET/G5+9A1kNO1FQ
         96LEOOBvYuVgT3QStuYh+Z6Km5CLZwgTHzHe6UddZpkMJloPc0o/lJshf3xX+D6m+5Ti
         8GllpA81MMa4p9ARd0XHZse3BerXaVmrUAG4IhTp0CROpUtLlaui4PplBrYLVHxyiVpI
         WaksF4uU03TxVbnXhaO/u0UImlab2ZxoDJo+1Zp4Ew1YVw1htCd2n4CMBha2rNpxpl1O
         014Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=KOiRk1GvUmbAW7om9IhrODhWlT9GJilv/uiLD9Q5hoI=;
        b=tL7QgLHx0c3MCsExGf9OJs6xSKF4s5/rVQHNYEWGOUjsmdEZZiwm84LvfoTcW5SEY9
         r5KY2AzbtYc856boGPqu9nFnYMfpbyKHNDpy72L6gsim80Emljm+TJQ5mpJ+aGDP1Iad
         +DU694yLQmIwrBrS8gU3uvjo6CJLs8DgzOVWa9y596EiE65qKQ40PxnulZHvLtDGGFiq
         82yKb3wYxTK5sX/p0D5SnlnhemBnLf/VrtdiD4etKbMt/GYHOuNS6mKCwH53VC/IzNz9
         3NYM++qzfzjr503xYljZ4xL6ubxThtIfQaWoy1hscTiJri36qdCL+k8qT9Baa94Pe9yz
         iWEw==
X-Gm-Message-State: APjAAAX7KpRKUqycujkVK66S0I3GV03oCoqzERVso/TyEm995qga8yTv
        vKiFZV6NRxRBvmtQKt2pQA6Qqw==
X-Google-Smtp-Source: APXvYqw0Qgbf13n0sRKVffhOqXPMptHjCbdX9bY75FUCVzTnxHEkowdHyKuu25wQmVaAvY9SlcMCcw==
X-Received: by 2002:a63:150d:: with SMTP id v13mr4541542pgl.342.1576201048604;
        Thu, 12 Dec 2019 17:37:28 -0800 (PST)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id u18sm8699083pgn.9.2019.12.12.17.37.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Dec 2019 17:37:28 -0800 (PST)
Date:   Thu, 12 Dec 2019 17:37:24 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Yuval Avnery <yuvalav@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andy Gospodarek <andy@greyhouse.net>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191212173724.3708e9a4@cakuba.netronome.com>
In-Reply-To: <20191212184732.GA570918@splinter>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211154952.50109494@cakuba.netronome.com>
        <AM6PR05MB51425B74E736C5D765356DC8C5550@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191212102517.602a8a5d@cakuba.netronome.com>
        <20191212184732.GA570918@splinter>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Dec 2019 20:47:32 +0200, Ido Schimmel wrote:
> On Thu, Dec 12, 2019 at 10:25:17AM -0800, Jakub Kicinski wrote:
> > I'd like to see netdevsim to also serve as sort of a reference model
> > for device behaviour. Vendors who are not first to implement a feature
> > always complain that there is no documentation on how things should
> > work. =20
>=20
> +1
>=20
> I have a patch set that adds FIB offload implementation to netdevsim and
> a gazillion of test cases that I share between netdevsim and mlxsw. Can
> be used by more drivers when they land.
>=20
> It's also very convenient for fuzzing now that syzkaller supports
> netdevsim instances thanks to Jiri. I've been running syzkaller for a
> few weeks now to test the FIB implementation.

=F0=9F=98=AF=F0=9F=98=AF very cool!
