Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA5852E744
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 10:26:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231959AbiETI0U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 04:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346954AbiETIZz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 04:25:55 -0400
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF1A426EB;
        Fri, 20 May 2022 01:25:53 -0700 (PDT)
Received: by mail-qt1-f171.google.com with SMTP id 11so4197347qtp.9;
        Fri, 20 May 2022 01:25:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lpc+d6x4SOEcD405DGgbTOQQkFjVoqNOdwqrdRsRrRM=;
        b=VAQ/5NVodqxcCerBBkx22DgVJS8Mluc3fqzjypI9iSbzS2b+2ArI3qgRs2RMfmQozz
         MIYcYTPNgva0Gr6jCxxv0PwjtjaC843tXXHFeq9ysIZKYAdEW9M25uiafVb0xPftUI6K
         Vd+9RVCQxf1s1M+udfjfpGzzc5jhB3dMH2PRKr8ymSw3Fr7E90CIYioTbagd0mzuI/A5
         P8Q+fF48TsjXW7dAaTeXK9EhI7mS5hcv6b/XbUe9DxB3R5i+3vZOxWAWjoju1Rty/B4y
         f6aW21vLGR6LhiswElwiaQmh7FxxiJt7wrlgR7FJvxyzBChcUQMiPzOjEjE3FZakzQf/
         1KCg==
X-Gm-Message-State: AOAM5339+hSamkb/Jn53aekxpC6MtRYcHv6k+giTsD80kqiyZU2YbiaW
        NnZTrxR/NLDHd0guyvTwHv0chyCSdvw4JQ==
X-Google-Smtp-Source: ABdhPJzwUaP7Y4ec+5aoUaKD4HiPfWmToZdhsk4CQRPEq7lwfjX3yBpZEbvntOPUR7J+24rk6M2p8g==
X-Received: by 2002:a05:622a:3d1:b0:2f3:cded:906a with SMTP id k17-20020a05622a03d100b002f3cded906amr6869170qtx.377.1653035151877;
        Fri, 20 May 2022 01:25:51 -0700 (PDT)
Received: from mail-yb1-f176.google.com (mail-yb1-f176.google.com. [209.85.219.176])
        by smtp.gmail.com with ESMTPSA id a192-20020a3766c9000000b006a0ffae114fsm2676281qkc.120.2022.05.20.01.25.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 01:25:51 -0700 (PDT)
Received: by mail-yb1-f176.google.com with SMTP id x2so12692348ybi.8;
        Fri, 20 May 2022 01:25:50 -0700 (PDT)
X-Received: by 2002:a25:4150:0:b0:64d:7747:9d93 with SMTP id
 o77-20020a254150000000b0064d77479d93mr8525905yba.36.1653035150569; Fri, 20
 May 2022 01:25:50 -0700 (PDT)
MIME-Version: 1.0
References: <20220519153107.696864-1-clement.leger@bootlin.com>
 <20220519153107.696864-12-clement.leger@bootlin.com> <CAMuHMdUJpNSyX0qK64+W1G6P1S-78mb_+D0-w3kHOFY3VVkANQ@mail.gmail.com>
 <20220520101332.0905739f@fixe.home>
In-Reply-To: <20220520101332.0905739f@fixe.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 20 May 2022 10:25:37 +0200
X-Gmail-Original-Message-ID: <CAMuHMdXTrZnGVt44hg5QUvuS5cZABmRncgNYtatkmk8VcH7gew@mail.gmail.com>
Message-ID: <CAMuHMdXTrZnGVt44hg5QUvuS5cZABmRncgNYtatkmk8VcH7gew@mail.gmail.com>
Subject: Re: [PATCH net-next v5 11/13] ARM: dts: r9a06g032: describe GMAC2
To:     =?UTF-8?B?Q2zDqW1lbnQgTMOpZ2Vy?= <clement.leger@bootlin.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Herve Codina <herve.codina@bootlin.com>,
        =?UTF-8?Q?Miqu=C3=A8l_Raynal?= <miquel.raynal@bootlin.com>,
        Milan Stevanovic <milan.stevanovic@se.com>,
        Jimmy Lalande <jimmy.lalande@se.com>,
        Pascal Eberhard <pascal.eberhard@se.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>,
        Linux-Renesas <linux-renesas-soc@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQ2zDqW1lbnQsDQoNCk9uIEZyaSwgTWF5IDIwLCAyMDIyIGF0IDEwOjE0IEFNIENsw6ltZW50
IEzDqWdlcg0KPGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+IHdyb3RlOg0KPiBMZSBGcmksIDIw
IE1heSAyMDIyIDA5OjE4OjU4ICswMjAwLA0KPiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxp
bnV4LW02OGsub3JnPiBhIMOpY3JpdCA6DQo+ID4gT24gVGh1LCBNYXkgMTksIDIwMjIgYXQgNToz
MiBQTSBDbMOpbWVudCBMw6lnZXIgPGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+IHdyb3RlOg0K
PiA+ID4gUlovTjEgU29DIGluY2x1ZGVzIHR3byBNQUMgbmFtZWQgR01BQ3ggdGhhdCBhcmUgY29t
cGF0aWJsZSB3aXRoIHRoZQ0KPiA+ID4gInNucHMsZHdtYWMiIGRyaXZlci4gR01BQzEgaXMgY29u
bmVjdGVkIGRpcmVjdGx5IHRvIHRoZSBNSUkgY29udmVydGVyDQo+ID4gPiBwb3J0IDEuIEdNQUMy
IGhvd2V2ZXIgY2FuIGJlIHVzZWQgYXMgdGhlIE1BQyBmb3IgdGhlIHN3aXRjaCBDUFUNCj4gPiA+
IG1hbmFnZW1lbnQgcG9ydCBvciBjYW4gYmUgbXV4ZWQgdG8gYmUgY29ubmVjdGVkIGRpcmVjdGx5
IHRvIHRoZSBNSUkNCj4gPiA+IGNvbnZlcnRlciBwb3J0IDIuIFRoaXMgY29tbWl0IGFkZCBkZXNj
cmlwdGlvbiBmb3IgdGhlIEdNQUMyIHdoaWNoIHdpbGwNCj4gPiA+IGJlIHVzZWQgYnkgdGhlIHN3
aXRjaCBkZXNjcmlwdGlvbi4NCj4gPiA+DQo+ID4gPiBTaWduZWQtb2ZmLWJ5OiBDbMOpbWVudCBM
w6lnZXIgPGNsZW1lbnQubGVnZXJAYm9vdGxpbi5jb20+DQoNCj4gPiA+IC0tLSBhL2FyY2gvYXJt
L2Jvb3QvZHRzL3I5YTA2ZzAzMi5kdHNpDQo+ID4gPiArKysgYi9hcmNoL2FybS9ib290L2R0cy9y
OWEwNmcwMzIuZHRzaQ0KPiA+ID4gQEAgLTIwMCw2ICsyMDAsMjMgQEAgbmFuZF9jb250cm9sbGVy
OiBuYW5kLWNvbnRyb2xsZXJANDAxMDIwMDAgew0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAg
ICAgc3RhdHVzID0gImRpc2FibGVkIjsNCj4gPiA+ICAgICAgICAgICAgICAgICB9Ow0KPiA+ID4N
Cj4gPiA+ICsgICAgICAgICAgICAgICBnbWFjMjogZXRoZXJuZXRANDQwMDIwMDAgew0KPiA+ID4g
KyAgICAgICAgICAgICAgICAgICAgICAgY29tcGF0aWJsZSA9ICJzbnBzLGR3bWFjIjsNCj4gPg0K
PiA+IERvZXMgdGhpcyBuZWVkIGFuIFNvQy1zcGVjaWZpYyBjb21wYXRpYmxlIHZhbHVlPw0KPg0K
PiBJbmRlZWQsIGl0IG1pZ2h0IGJlIHVzZWZ1bCB0byBpbnRyb2R1Y2UgYSBzcGVjaWZpYyBTb0Mg
Y29tcGF0aWJsZSBzaW5jZQ0KPiBpbiBhIG5lYXIgZnV0dXJlLCB0aGVyZSBtaWdodCBiZSBzb21l
IHNwZWNpZmljIHN1cHBvcnQgZm9yIHRoYXQgZ21hYy4NCj4gSGVyZSBpcyBhbiBvdmVydmlldyBv
ZiB0aGUgZ21hYyBjb25uZWN0aW9uIG9uIHRoZSBTb0M6DQo+DQo+ICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgIOKUjOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
kCAgIOKUjOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUkA0KPiAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICDilIIgICAgICAgICDilIIgICDilIIgICAgICAg
ICAg4pSCDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIOKUgiAg
R01BQzIgIOKUgiAgIOKUgiAgR01BQzEgICDilIINCj4gICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAg4pSCICAgICAgICAg4pSCICAg4pSCICAgICAgICAgIOKUgg0KPiAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICDilJTilIDilIDilIDilKzi
lIDilIDilIDilIDilIDilJggICDilJTilIDilIDilIDilIDilIDilKzilIDilIDilIDilIDilJgN
Cj4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIOKUgiAgICAg
ICAgICAgICAgIOKUgg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAg4pSCICAgICAgICAgICAgICAg4pSCDQo+ICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICDilIIgICAgICAgICAgICAgICDilIINCj4gICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICDilIzilIDilIDilIDilIDilrzilIDilIDilIDi
lIDilIDilIDilJAgICAgICAgIOKUgg0KPiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgIOKUgiAgICAgICAgICAg4pSCICAgICAgICDilIINCj4gICAgICAgICAgICAg4pSM
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSkICBTV0lUQ0ggICDilIIgICAgICAgIOKUgg0K
PiAgICAgICAgICAgICDilIIgICAgICAgICAgICAgICAgICAgICAgICAgICAg4pSCICAgICAgICAg
ICDilIIgICAgICAgIOKUgg0KPiAgICAgICAgICAgICDilIIgICAgICAgICAg4pSM4pSA4pSA4pSA
4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pS04pSA4pSs4pSA4pSA
4pSA4pSA4pSs4pSA4pSA4pSA4pSA4pSYICAgICAgICDilIINCj4gICAgICAgICAgICAg4pSCICAg
ICAgICAgIOKUgiAgICAgICAgICAgIOKUjOKUgOKUgOKUgOKUgOKUgOKUgOKUmCAgICDilIIgICAg
ICAgICAgICAg4pSCDQo+ICAgICAgICAgICAgIOKUgiAgICAgICAgICDilIIgICAgICAgICAgICDi
lIIgICAgICAgICAgIOKUgiAgICAgICAgICAgICDilIINCj4gICAgICAgIOKUjOKUgOKUgOKUgOKU
gOKWvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKWvOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKWvOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKWvOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKWvOKUgOKUgOKUgOKUgOKUkA0K
PiAgICAgICAg4pSCICAgICAgICAgICAgICAgICAgICAgIE1JSSBDb252ZXJ0ZXIgICAgICAgICAg
ICAgICAgICAgICAgICDilIINCj4gICAgICAgIOKUgiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg4pSCDQo+ICAgICAgICDilIIgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIOKUgg0K
PiAgICAgICAg4pSCIHBvcnQgMSAgICAgIHBvcnQgMiAgICAgICBwb3J0IDMgICAgICBwb3J0IDQg
ICAgICAgcG9ydCA1ICDilIINCj4gICAgICAgIOKUlOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKU
gOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUgOKUmA0KPg0KPiBBcyB5b3UgY2Fu
IHNlZSwgdGhlIEdNQUMxIGlzIGRpcmVjdGx5IGNvbm5lY3RlZCB0byBNSUlDIGNvbnZlcnRlciBh
bmQNCj4gdGh1cyB3aWxsIG5lZWQgYSAicGNzLWhhbmRsZSIgcHJvcGVydHkgdG8gcG9pbnQgb24g
dGhlIE1JSSBjb252ZXJ0ZXINCj4gcG9ydCB3aGVyZWFzIHRoZSBHTUFDMiBpcyBkaXJlY3RseSBj
b25uZWN0ZWQgdG8gdGhlIHN3aXRjaCBpbiBHTUlJLg0KPg0KPiBJcyAicmVuZXNhcyxyOWEwNmcw
MzItZ21hYzIiLCAicmVuZXNhcyxyem4xLXN3aXRjaC1nbWFjMiIgbG9va3Mgb2sgZm9yDQo+IHlv
dSBmb3IgdGhpcyBvbmUgPw0KDQpXaHkgInN3aXRjaCIgaW4gdGhlIGZhbWlseS1zcGVjaWZpYyB2
YWx1ZSwgYnV0IG5vdCBpbiB0aGUgU29DLXNwZWNpZmljDQp2YWx1ZT8NCg0KQXJlIEdNQUMxIGFu
ZCBHTUFDMiByZWFsbHkgZGlmZmVyZW50LCBvciBhcmUgdGhleSBpZGVudGljYWwsIGFuZCBpcw0K
dGhlIG9ubHkgZGlmZmVyZW5jZSBpbiB0aGUgd2lyaW5nLCB3aGljaCBjYW4gYmUgZGV0ZWN0ZWQg
YXQgcnVuLXRpbWUNCnVzaW5nIHRoaXMgInBjcy1oYW5kbGUiIHByb3BlcnR5PyBJZiB0aGV5J3Jl
IGlkZW50aWNhbCwgdGhleSBzaG91bGQNCnVzZSB0aGUgc2FtZSBjb21wYXRpYmxlIHZhbHVlLg0K
DQpUaGFua3MhDQoNCkdye29ldGplLGVldGluZ31zLA0KDQogICAgICAgICAgICAgICAgICAgICAg
ICBHZWVydA0KDQotLQ0KR2VlcnQgVXl0dGVyaG9ldmVuIC0tIFRoZXJlJ3MgbG90cyBvZiBMaW51
eCBiZXlvbmQgaWEzMiAtLSBnZWVydEBsaW51eC1tNjhrLm9yZw0KDQpJbiBwZXJzb25hbCBjb252
ZXJzYXRpb25zIHdpdGggdGVjaG5pY2FsIHBlb3BsZSwgSSBjYWxsIG15c2VsZiBhIGhhY2tlci4g
QnV0DQp3aGVuIEknbSB0YWxraW5nIHRvIGpvdXJuYWxpc3RzIEkganVzdCBzYXkgInByb2dyYW1t
ZXIiIG9yIHNvbWV0aGluZyBsaWtlIHRoYXQuDQogICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIC0tIExpbnVzIFRvcnZhbGRzDQo=
