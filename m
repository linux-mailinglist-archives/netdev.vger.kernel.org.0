Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E219E1B258
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 11:08:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728543AbfEMJIK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 05:08:10 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.61.142]:54480 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727873AbfEMJIJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 May 2019 05:08:09 -0400
Received: from mailhost.synopsys.com (dc2-mailhost2.synopsys.com [10.12.135.162])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 79581C010E;
        Mon, 13 May 2019 09:07:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1557738480; bh=gcTvcdOuIINVJKU6JW1SH1m0kFLmNwXaodiC6f8wND8=;
        h=From:To:CC:Subject:Date:References:In-Reply-To:From;
        b=W5DV7SrYvh52vMg7I21upmaOiMTjXcGvjQ2IgjMM1EQcHCZJ3OUV7SiB9vJHKQTM7
         5kk2yIwZSroB+Ums53ADIVMZKNEPvJSRngudhwGND2JahL5TkhzW2MW3cEEPO6JSOA
         s3h6uxqT9wzgL4DxNUp43gU1fUAsLwTZjxGWilRvNultOFbx9tqiUJG3svyi1Q3ydT
         l8PPzw9dCRqos1jmS5QCYdUzsfj/Wi7miPLHAR27pk08BIuP8nKzNM3jCIKZRtbmki
         QzvfX35tskHY3rLhRVFO0HkqkS1Bencj3V7c5CHkwoPHveulDNMifcBpzRldLfbnXy
         2RCS+BS4X4Xzw==
Received: from US01WXQAHTC1.internal.synopsys.com (us01wxqahtc1.internal.synopsys.com [10.12.238.230])
        (using TLSv1.2 with cipher AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        by mailhost.synopsys.com (Postfix) with ESMTPS id 0DE2EA0095;
        Mon, 13 May 2019 09:08:04 +0000 (UTC)
Received: from DE02WEHTCB.internal.synopsys.com (10.225.19.94) by
 US01WXQAHTC1.internal.synopsys.com (10.12.238.230) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 13 May 2019 02:08:04 -0700
Received: from DE02WEMBXB.internal.synopsys.com ([fe80::95ce:118a:8321:a099])
 by DE02WEHTCB.internal.synopsys.com ([::1]) with mapi id 14.03.0415.000; Mon,
 13 May 2019 11:07:56 +0200
From:   Jose Abreu <Jose.Abreu@synopsys.com>
To:     Simon Huelck <simonmail@gmx.de>,
        Jose Abreu <Jose.Abreu@synopsys.com>,
        Sebastian Gottschall <s.gottschall@newmedia-net.de>,
        Jerome Brunet <jbrunet@baylibre.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
CC:     "linux-amlogic@lists.infradead.org" 
        <linux-amlogic@lists.infradead.org>,
        "Gpeppe.cavallaro@st.com" <Gpeppe.cavallaro@st.com>,
        "alexandre.torgue@st.com" <alexandre.torgue@st.com>,
        Emiliano Ingrassia <ingrassia@epigenesys.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: stmmac / meson8b-dwmac
Thread-Topic: stmmac / meson8b-dwmac
Thread-Index: AQHUrqr/JQcHkqt1hEeAbkJJzJnwDKXPv22AgALiL4CAAidpgIAB8QYAgAP3ywCACX/eAIABK+6AgAAAwYCAAD/gAIAAAkYAgAAFzwCAACj3gIAAAKCAgAAGIgCAAAldgIAAA9KAgAAAxoCAAAIjAIAABCuAgAAQsQCAAPZwAIAAtp+AgALLNACAADQdgIAABVkAgASIe4CAAE72AIAADmsAgAQZCACAAIQtAIACgusAgG/hBQCAAuUU8A==
Date:   Mon, 13 May 2019 09:07:55 +0000
Message-ID: <78EB27739596EE489E55E81C33FEC33A0B91BAAE@DE02WEMBXB.internal.synopsys.com>
References: <a38e643c-ed9f-c306-cc95-84f70ebc1f10@gmx.de>
 <065407cd-c13b-e74c-7798-508650c12caf@gmx.de>
 <227be4e9-b0cc-a011-2558-71a17567246f@synopsys.com>
 <45e73e8c-a0fb-6f8f-8dc6-3aa2103fdda3@gmx.de>
 <e1d75e7f-1747-d0ce-0ee7-4fa688b90d13@synopsys.com>
 <4493b245-de93-46cd-327b-8091a3babc3a@gmx.de>
 <adafe6d7-e619-45e9-7ecb-76f003b0c7d9@synopsys.com>
 <cd0b3dec-af3f-af69-50b7-6ca6f7256900@gmx.de>
 <fa35fb4a-b9d5-9bbb-437d-47e8819d0f27@synopsys.com>
 <244d7c74-e0ca-a9c7-f4b0-3de7bec4024b@gmx.de>
 <1426d8ed40be0927c135aff25dcf989a11326932.camel@baylibre.com>
 <9074d29b-4cc9-87b6-009f-48280a4692c0@gmx.de>
 <d7de65c614ee788152300f6d3799fd537b438496.camel@baylibre.com>
 <8ec64936-c8fa-1f0e-68bf-2ad1d6e8f5d9@gmx.de>
 <f08f2659-dde0-41ec-9233-6b4d5f375ffe@newmedia-net.de>
 <3a040370-e7e5-990e-81dc-8e9bb0ab7761@gmx.de>
 <c21c30e9-e53e-02a5-c367-25898c4614e9@synopsys.com>
 <12d1d6de-2905-46a8-6481-d6f20c8e9d85@gmx.de>
 <2c4d9726-6c2a-cd95-0493-323f5f09e14a@synopsys.com>
 <2d7a5c80-3134-ebc0-3c44-9ca9900eade8@gmx.de>
In-Reply-To: <2d7a5c80-3134-ebc0-3c44-9ca9900eade8@gmx.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.107.19.176]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogU2ltb24gSHVlbGNrIDxzaW1vbm1haWxAZ214LmRlPg0KRGF0ZTogU2F0LCBNYXkgMTEs
IDIwMTkgYXQgMTU6NTM6MzQNCg0KPiBldGh0b29sIC1TIGdhdmUgbWUgc29tZSBjb3VudHMgZm9y
IG1tY19yeF9maWZvX292ZXJmbG93LCB3aGljaCBpIGRpZG50DQo+IHJlY29nbml6ZSBiZWZvcmUu
DQoNCkZsb3cgQ29udHJvbCBjYW4gcHJldmVudCB0aGlzIHRvIGhhcHBlbi4gUGxlYXNlIGNoZWNr
IGlmIHlvdXIgRFQgRklGTyANCmJpbmRpbmdzIGFyZSA+PSA0MDk2Lg0KDQo+IERvIHdlIGhhdmUg
bmV3IGlkZWFzIC8gbmV3IGRpcmVjdGlvbiB0byBkaWcgZm9yID8NCg0KR0lUIEJpc2VjdCBpcyB0
aGUgYmVzdCBkaXJlY3Rpb24gdG8gZm9sbG93Lg0KDQpUaGFua3MsDQpKb3NlIE1pZ3VlbCBBYnJl
dQ0K
