Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BD922BB10E
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 17:58:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730244AbgKTQ4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 11:56:55 -0500
Received: from pic75-3-78-194-244-226.fbxo.proxad.net ([78.194.244.226]:44782
        "EHLO mail.corsac.net" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1730233AbgKTQ4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Nov 2020 11:56:55 -0500
Received: from scapa.corsac.net (unknown [IPv6:2a01:e34:ec2f:4e20:6af7:28ff:fe8d:2119])
        by mail.corsac.net (Postfix) with ESMTPS id 639D39B
        for <netdev@vger.kernel.org>; Fri, 20 Nov 2020 17:56:48 +0100 (CET)
Received: from corsac (uid 1000)
        (envelope-from corsac@corsac.net)
        id a0181
        by scapa.corsac.net (DragonFly Mail Agent v0.12);
        Fri, 20 Nov 2020 17:56:47 +0100
Message-ID: <6266fe045aa8a1a0fc927c6e731a10dc64b41628.camel@corsac.net>
Subject: Re: [PATCH] usbnet: ipheth: fix connectivity with iOS 14
From:   Yves-Alexis Perez <corsac@corsac.net>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Martin Habets <mhabets@solarflare.com>,
        Luc Van Oostenryck <luc.vanoostenryck@gmail.com>,
        Shannon Nelson <snelson@pensando.io>,
        "Michael S. Tsirkin" <mst@redhat.com>, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Matti Vuorela <matti.vuorela@bitfactor.fi>, stable@vger.kernel.org
Date:   Fri, 20 Nov 2020 17:56:47 +0100
In-Reply-To: <22d938ab-babc-815a-f635-5025e871cf62@gmail.com>
References: <CAAn0qaXmysJ9vx3ZEMkViv_B19ju-_ExN8Yn_uSefxpjS6g4Lw@mail.gmail.com>
         <20201119172439.94988-1-corsac@corsac.net>
         <22d938ab-babc-815a-f635-5025e871cf62@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTExLTIwIGF0IDEyOjE1ICswMzAwLCBTZXJnZWkgU2h0eWx5b3Ygd3JvdGU6
Cj4gPiBJbnZlc3RpZ2F0aW9uIG9uIHRoZSBtYXR0ZXIgc2hvd3MgdGhhdCBVRFAgYW5kIElDTVAg
dHJhZmZpYyBmcm9tIHRoZQo+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIF4gIm5vIiBtaXNzaW5n
PwpZZXMgaW5kZWVkLiBUaGFua3MgYW5kIHNvcnJ5IGZvciB0aGUgdHlwby4KClJlZ2FyZHMsCi0t
IApZdmVzLUFsZXhpcwo=

