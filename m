Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03947680B75
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 11:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236440AbjA3K7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 05:59:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236277AbjA3K7t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 05:59:49 -0500
X-Greylist: delayed 51401 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 30 Jan 2023 02:59:46 PST
Received: from polaris.svanheule.net (polaris.svanheule.net [IPv6:2a00:c98:2060:a004:1::200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA56518A8E
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 02:59:46 -0800 (PST)
Received: from vanadium.ugent.be (vanadium.ugent.be [157.193.99.61])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: sander@svanheule.net)
        by polaris.svanheule.net (Postfix) with ESMTPSA id CFD31374C99;
        Mon, 30 Jan 2023 11:59:43 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=svanheule.net;
        s=mail1707; t=1675076384;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=U1Ys43pCbQ47P6jE4khaS6ODOc8bcDkfqNdijwTb2hE=;
        b=3EI+iUbrpNLzheskeLDNNEE4YLkOUF3NcXPXUDMKIiRBjUxPmYvBRGGhH5gPyL/alC7EZ+
        0D9L2sCDXIw+x6VEusgemZxiUeB2A6irBKb1K23mgiHL06Ub7YXAIKE+z9At31GaGslm78
        vaLCLrf0Z+/IBDaB0YY0I/KuSlDNhZG5oRw/YnXTIeQPFmgeYoMKcLufWzm/UyBqEHaMUI
        otTV8Xx+1j3T1FS2KxiCcgePfpGXKoE+nhlXOiRgEgmr1vlDWWWYj+uth6rNgUrDB0BjPi
        8xNnmbKYWYHHepw2rYeh4oAwR51OtXMymPzNKXav+PTysmiPTRQ6+bR6ZwkXEA==
Message-ID: <f854183545a6ff55235c9f2264af97c1a7f530c3.camel@svanheule.net>
Subject: Re: [PATCH v7 11/11] dt-bindings: net: dsa: qca8k: add LEDs
 definition example
From:   Sander Vanheule <sander@svanheule.net>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Christian Marangi <ansuelsmth@gmail.com>,
        Rob Herring <robh@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Tim Harvey <tharvey@gateworks.com>,
        Alexander Stein <alexander.stein@ew.tq-group.com>,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Date:   Mon, 30 Jan 2023 11:59:42 +0100
In-Reply-To: <Y9bs53a9zyqEU9Xw@lunn.ch>
References: <20221214235438.30271-1-ansuelsmth@gmail.com>
         <20221214235438.30271-12-ansuelsmth@gmail.com>
         <20221220173958.GA784285-robh@kernel.org> <Y6JDOFmcEQ3FjFKq@lunn.ch>
         <Y6JkXnp0/lF4p0N1@lunn.ch> <63a30221.050a0220.16e5f.653a@mx.google.com>
         <c609a7f865ab48f858adafdd9c1014dda8ec82d6.camel@svanheule.net>
         <Y9bs53a9zyqEU9Xw@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.3 (3.46.3-1.fc37) 
MIME-Version: 1.0
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQW5kcmV3LAoKT24gU3VuLCAyMDIzLTAxLTI5IGF0IDIzOjAyICswMTAwLCBBbmRyZXcgTHVu
biB3cm90ZToKPiA+ID4gVGhpcyBpcyBhbiBleGFtcGxlIG9mIHRoZSBkdCBpbXBsZW1lbnRlZCBv
biBhIHJlYWwgZGV2aWNlLgo+ID4gPiAKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqBtZGlvIHsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgI2FkZHJlc3MtY2VsbHMgPSA8MT47Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCNzaXplLWNlbGxzID0gPDA+Owo+ID4gPiAKPiA+
ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcGh5X3Bv
cnQxOiBwaHlAMCB7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqByZWcgPSA8MD47Cj4gPiA+IAo+ID4gPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
bGVkcyB7Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgI2FkZHJlc3MtY2VsbHMgPSA8MT47
Cj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgI3NpemUtY2VsbHMgPSA8MD47Cj4gPiBbLi4u
XQo+ID4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgfTsKPiA+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgfTsKPiA+IFsuLi5dCj4gPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgfTsKPiA+ID4gCj4gPiA+IEluIHRoZSBmb2xsb3dpbmcgaW1wbGVtZW50YXRpb24u
IEVhY2ggcG9ydCBoYXZlIDIgbGVkcyBhdHRhY2hlZCAob3V0IG9mCj4gPiA+IDMpIG9uZSB3aGl0
ZSBhbmQgb25lIGFtYmVyLiBUaGUgZHJpdmVyIHBhcnNlIHRoZSByZWcgYW5kIGNhbGN1bGF0ZSB0
aGUKPiA+ID4gb2Zmc2V0IHRvIHNldCB0aGUgY29ycmVjdCBvcHRpb24gd2l0aCB0aGUgcmVncyBi
eSBhbHNvIGNoZWNraW5nIHRoZSBwaHkKPiA+ID4gbnVtYmVyLgo+ID4gCj4gPiBXaXRoIHN3aXRj
aCBzaWxpY29uIGFsbG93aW5nIHVzZXIgY29udHJvbCBvZiB0aGUgTEVEcywgdmVuZG9ycyBjYW4g
KGFuZAo+ID4gd2lsbCkKPiA+IHVzZSB0aGUgc3dpdGNoJ3MgTEVEIHBlcmlwaGVyYWwgdG8gZHJp
dmUgb3RoZXIgTEVEcyAob3Igd29yc2UpLiBFLmcuIG9uIGEKPiA+IENpc2NvCj4gPiBTRzIyMC0y
NiBzd2l0Y2gsIHVzaW5nIGEgUmVhbHRlayBSVEw4MzgyIFNvQywgdGhlIExFRHMgYXNzb2NpYXRl
ZCB3aXRoIHNvbWUKPiA+IHVudXNlZCBzd2l0Y2ggcG9ydHMgYXJlIHVzZWQgdG8gZGlzcGxheSBh
IGdsb2JhbCBkZXZpY2Ugc3RhdHVzLiBNeSBjb25jZXJuCj4gPiBoZXJlCj4gPiBpcyB0aGF0IG9u
ZSB3b3VsZCBoYXZlIHRvIHNwZWNpZnkgc3dpdGNoIHBvcnRzLCB0aGF0IGFyZW4ndCBjb25uZWN0
ZWQgdG8KPiA+IGFueXRoaW5nLCBqdXN0IHRvIGRlc2NyaWJlIHRob3NlIG5vbi1ldGhlcm5ldCBM
RURzLgo+IAo+IE5vdGUgdGhhdCB0aGUgYmluZGluZyBpcyBhZGRpbmcgcHJvcGVydGllcyB0byB0
aGUgUEhZIG5vZGVzLCBub3QgdGhlCj4gc3dpdGNoIHBvcnQgbm9kZXMuIElzIHRoaXMgaG93IHRo
ZSBSVEw4MzgyIHdvcmtzPyBNYXJ2ZWxsIFN3aXRjaGVzCj4gaGF2ZSBMRUQgcmVnaXN0ZXJzIHdo
aWNoIGFyZSBub3QgaW4gdGhlIFBIWSByZWdpc3RlciBzcGFjZS4KClRoYW5rcyBmb3IgdGhlIHF1
aWNrIGNsYXJpZmljYXRpb24uIEJlY2F1c2UgeW91IG1lbnRpb24gdGhpcywgSSByZWFsaXNlZCB0
aGF0CnRoZSBSVEw4MzgyJ3MgTEVEIGNvbnRyb2xsZXIgaXMgYWN0dWFsbHkgbm90IGluIHRoZSBQ
SFlzLiBUaGVzZSBTb0NzIHVzZQpleHRlcm5hbCBQSFlzLCB3aGljaCBtYXkgaGF2ZSB0aGVpciBv
d24sIGluZGVwZW5kZW50LCBMRUQgY29udHJvbGxlcnMuIEZvcgpleGFtcGxlIHRoZSBSVEw4MjEy
RCBbMV0uCgpbMV0KaHR0cHM6Ly9kYXRhc2hlZXQubGNzYy5jb20vbGNzYy8yMjAzMjUyMjUzX1Jl
YWx0ZWstU2VtaWNvbi1SVEw4MjE4RC1DR19DMjkwMTg5OC5wZGYKCj4gCj4gQnV0IHRoZSBwb2lu
dCBpcywgdGhlIFBIWXMgd2lsbCBwcm9iZSBpZiBsaXN0ZWQuIFRoZXkgZG9uJ3QgaGF2ZSB0bwo+
IGhhdmUgYSBNQUMgcG9pbnRpbmcgdG8gdGhlbSB3aXRoIGEgcGhhbmRsZS4gU28gdGhlIHBoeWRl
diB3aWxsIGV4aXN0LAo+IGFuZCB0aGF0IHNob3VsZCBiZSBlbm91Z2ggdG8gZ2V0IHRoZSBMRUQg
Y2xhc3MgZGV2aWNlIHJlZ2lzdGVyZWQuIElmCj4gdGhlcmUgaXMgYmFzaWMgb24vb2ZmIHN1cHBv
cnQsIHRoYXQgc2hvdWxkIGJlIGVub3VnaCBmb3IgeW91IHRvIGF0dGFjaAo+IHRoZSBNb3JzZSBj
b2RlIHBhbmljIHRyaWdnZXIsIHRoZSBoZWFydGJlYXQgaGFuZGxlciwgb3IgYW55IG90aGVyIExF
RAo+IHRyaWdnZXIuCgpPSywgdGhpcyBtYWtlcyBzZW5zZSBmb3IgKGV4dGVybmFsKSBQSFlzIHdo
aWNoIG5lZWQgdG8gYmUgcHJvYmVkIGFueXdheSB0byBoYXZlCmFjY2VzcyB0byB0aGUgTEVEcy4K
Ckxvb2tpbmcgYXQgdGhlIFJUTDgyMTJEJ3MgZGF0YXNoZWV0IChUYWJsZSAxMSwgcC4gMjQpLCBp
dCBhcHBlYXJzIHRvIGJlIHBvc3NpYmxlCnRvIGFzc2lnbiBhbiBMRUQgdG8gYW55IG9mIHRoZSBl
aWdodCBQSFlzLiBQZXJoYXBzIHRvIGFsbG93IG1vcmUgZnJlZWRvbSBpbiB0aGUKYm9hcmQgbGF5
b3V0LiBNYXliZSBJJ20ganVzdCBub3Qgc2VlaW5nIGl0LCBidXQgSSBkb24ndCB0aGluayB0aGUg
ZXhhbXBsZSB3aXRoCmFuICdsZWRzJyBub2RlIHVuZGVyIGEgUEhZIGNvbnRhaW5zIGVub3VnaCBp
bmZvcm1hdGlvbiB0byBwZXJmb3JtIHN1Y2ggYSBub24tCnRyaXZpYWwgbWFwcGluZy4gT24gdGhl
IG90aGVyIGhhbmQsIEknbSBub3Qgc3VyZSB3aGVyZSBlbHNlIHRoYXQgaW5mbyBtaWdodCBnby4K
TWF5YmUgYSAndHJpZ2dlci1zb3VyY2VzJyBwcm9wZXJ0eSBjcm9zcy1yZWZlcmVuY2luZyBhbm90
aGVyIFBIWSBpbiB0aGUgc2FtZQpwYWNrYWdlPwoKQmVzdCwKU2FuZGVyCg==

