Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5FB6536D3F
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 16:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236496AbiE1OIW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 10:08:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234895AbiE1OIV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 10:08:21 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 504EA2DF
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 07:08:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id t4so3603664pld.4
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 07:08:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=U/vkevZE9lbmvYtGdsuyS196oX/GLcytgtkfjv3FQTo=;
        b=Sf/nTRuL9rqJW/bPr2VAaFYKfuGIG5iLDei9JXxZPZj1W+HJW4UbZOa5SByj1/C2XX
         mB04jMJqk5nMEhVpEJ2A6dIbnGGNqwZX3/GkQEpF03Igk9OQ7KPAVxE2UjuX1T6Fz1/i
         PyF/D2L0nj3qG4sagCTj50PN/9QTpoanTj33EndPqtf1+fkXTeiUlTC7ZaJNe7xLkmGs
         zTCq4RdzWqpe7uMAOM492mfQfG1JmUblxZTDKAWXdFbQfftJ3qxGeZWjdFlJaQoYykQR
         kXQtyHoCiD6Y8H29Vd/VswOwtWN5p9htRAM/2johvaUD8YyqeZ+evne2Eot7EaYwy0d4
         OwEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=U/vkevZE9lbmvYtGdsuyS196oX/GLcytgtkfjv3FQTo=;
        b=NTJxtdC/Qv1Iez9261aoGWudLRfsr3CIgagt3iyTR7g14aBNmnDFZ/z2AB6m0nKLXn
         dC+T0dfh9+ByZanJZa+YrA5h090v7pFPvt13is86n3ZABS9o6qCaD4ewsk4tXMyACSBy
         W8iwComatUgR11dvWxPV5Ur7v8TrOBRf77Jih5k768gWlbEwcjLNRRJdB6ICie8GZQ/f
         uWST+jSYAiwhuqseVSEW9r1NEPukUrChxEWeY2L3pdgBQH0kx8DMlw7xlU+wHl9+VrY9
         MLr4rF00Ofp8rtnV1AHMCWxDz9nl7qviEE2V459nowL6z2Lmo9mDpzT9rlwxZnRd5KSC
         oDAA==
X-Gm-Message-State: AOAM5313es6VtH7eD8f8dCNR5OM/nRwYlX0E//YivoBKZ+QGJR5MRXQe
        zipoCgJyI4bkB6MYlUDyEPultnAkjJsE5VTvYrY=
X-Google-Smtp-Source: ABdhPJz1SAPRo1jGvDos4OYielWKRHMDIVUmtNnEvG14DKJBJ6nf2Jpb+Kh9YzeYAkkOL5vv5+rxSu0L4uIyw7zaCTM=
X-Received: by 2002:a17:903:40c5:b0:162:120:194b with SMTP id
 t5-20020a17090340c500b001620120194bmr37113081pld.80.1653746898287; Sat, 28
 May 2022 07:08:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:90a:9b04:0:0:0:0 with HTTP; Sat, 28 May 2022 07:08:17
 -0700 (PDT)
Reply-To: info.businessplan@mail.ee
From:   Paul Subrata <atanatchodie@gmail.com>
Date:   Sat, 28 May 2022 14:08:17 +0000
Message-ID: <CAP5vv+ZYZpN9NnV4xU4g5mT8kh8YRCQJYTyTNoTLtpfoBJ3sGA@mail.gmail.com>
Subject: =?UTF-8?B?2KrZhdmI2YrZhCDYsdij2LMg2KfZhNmF2KfZhA==?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=7.8 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:630 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [atanatchodie[at]gmail.com]
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  1.0 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2LPZitiv2Yog2KfZhNi52LLZitiyIC8g2LPZitiv2KrZitiMDQoNCtiq2YPZhdmE2Kkg2YTZgCAi
2KzYp9im2K3YqSDZgdmK2LHZiNizINmD2YjYsdmI2YbYpy4g2YXYuSDYp9iz2KrYptmG2KfZgSDY
p9mE2KPYudmF2KfZhCDYp9mE2KrYrNin2LHZitipINiMINmD2KfZhiDYqtmF2YjZitmEDQrYsdij
2LMg2KfZhNmF2KfZhCDZitmF2KvZhCDYqtit2K/ZitmL2Kcg2K3ZitirINiq2LnZitivINin2YTY
udiv2YrYryDZhdmGINin2YTYtNix2YPYp9iqINiq2YLZitmK2YUg2KrZhdmI2YrZhCDZhdmI2KfY
sdiv2YfYpw0K2KfZhNix2KPYs9mF2KfZhNmK2Kkg2KjYrdir2YvYpyDYudmGINiu2YrYp9ix2KfY
qiIg2KfZhNin2K7Yqtix2KfZgiAi2YTYstmK2KfYr9ipINiq2YXZiNmK2YQg2LHYo9izINin2YTZ
hdin2YQuDQoNCtmH2YQg2YTYr9mK2YMg2KPZiiDZhdi02LHZiNi5INmF2YbYtdipINij2LnZhdin
2YQg2YLYp9io2YQg2YTZhNiq2LfYqNmK2YIg2YjZitit2KrYp9isINil2YTZiSDYqtmF2YjZitmE
INmF2KfZhNmK2J8NCtin2LnYqtmF2KfYr9mL2Kcg2LnZhNmJINmF2LTYsdmI2LkgLyDZhdi02KfY
sdmK2Lkg2YXZhti12Kkg2KfZhNi52YXZhCDYp9mE2K7Yp9i12Kkg2KjZgyDYjCDZitmD2YjZhiDZ
hdiv2YrYsdmI2YbYpyDYudmE2YkNCtin2LPYqti52K/Yp9ivINmE2KrZgtiv2YrZhSDYsdij2LMg
2KfZhNmF2KfZhCDYpdmE2Ykg2KfZhNi02LHZitmDINin2YTZhdir2KfZhNmKINin2YTYrNin2YfY
siDZhNmE2LnZhdmEINmF2YYg2KPYrNmEDQrYp9mE2YXZhtmB2LnYqSDYp9mE2YXYqtio2KfYr9mE
2Kkg2YjYs9mK2KrZhSDYqtiz2YTZitmFINix2KPYsyDYp9mE2YXYp9mEINin2YTZhdin2YTZiiDY
pdmE2YrZgyDZhdmGINiu2YTYp9mEINmF2YbYtdipINiq2YXZiNmK2YQNCtio2K/ZiNmGINit2YIg
2KfZhNix2KzZiNi5Lg0KDQrZitiz2LnYr9mG2Yog2KPZhiDYo9ix2LTYr9mDINmB2Yog2KrYo9mF
2YrZhiDYp9iz2KrYq9mF2KfYsSDYsdij2LPZhdin2YTZiiDYtdi62YrYsSDYo9mIINmD2KjZitix
INmE2YTYtNix2YPYqSDYo9mIINiq2LnYstmK2LINCtix2KPYsyDYp9mE2YXYp9mEINin2YTYrtin
2LUuDQrZitix2KzZiSDYp9mE2LHYryDYudmE2Ykg2YfYsNinINin2YTYqNix2YrYryDYp9mE2KXZ
hNmD2KrYsdmI2YbZiiDZhNmF2LLZitivINmF2YYg2KfZhNmF2LnZhNmI2YXYp9iqINmI2KfZhNiq
2YHYp9i12YrZhC4NCg0K2KrZgdi22YTZiNinINio2YLYqNmI2YQg2YHYp9im2YIg2KfZhNin2K3Y
qtix2KfZhdiMDQrYqNmI2YQg2LPZiNio2LHYp9iq2KcuDQo9PT09PT09PT09PT09PT09PT09PT09
PT09PT09PT09PT09PT09PT09PT09PT0NCg0KRGVhciBTaXIvTWFkYW0sDQoNClNlcXVlbCB0byB0
aGUgImNvcm9uYSB2aXJ1cyBwYW5kZW1pYy4gQXMgYnVzaW5lc3MgcmVzdW1lcywgY2FwaXRhbA0K
ZnVuZGluZyBoYXMgYmVlbiBhIGNoYWxsZW5nZSBhcyBtYW55IGZpcm1zIGFyZSByZS1ldmFsdWF0
aW9uIHRoZWlyDQpjYXBpdGFsIHJlc291cmNlcyBmdW5kaW5nIGluIHRoZSBsb29rIGZvciAiYnJl
YWtvdXQiIG9wdGlvbnMgdG8NCmluY3JlYXNlIHRoZWlyIGNhcGl0YWwgZmluYW5jZS4NCg0KRG8g
eW91IGhhdmUgYW55IHZpYWJsZSBidXNpbmVzcyBwbGF0Zm9ybSBwcm9qZWN0IHRoYXQgbmVlZHMg
ZmluYW5jaWFsDQpmdW5kaW5nPyBEZXBlbmRpbmcgb24geW91ciBidXNpbmVzcyBwbGF0Zm9ybSBw
cm9qZWN0L3MsIG91ciBwcmluY2lwYWxzDQphcmUgd2lsbGluZyB0byBwcm92aWRlIHRoZSBDYXBp
dGFsIHRvIHRoZSBpZGVhbCBwYXJ0bmVyIHJlYWR5IHRvIHdvcmsNCmZvciBhIG11dHVhbCBiZW5l
Zml0IGFuZCBmaW5hbmNpYWwgY2FwaXRhbCB3aWxsIGJlIGRlbGl2ZXJlZCB0byB5b3UNCnVuZGVy
IGEgbm9uLXJlY291cnNlIGZpbmFuY2UgcGxhdGZvcm0uDQoNCkkgd2lsbCBiZSBnbGFkIHRvIGd1
aWRlIHlvdSBpbiBzZWN1cmluZyBhIGNvcnBvcmF0ZSBzbWFsbCBvciBsYXJnZQ0KY2FwaXRhbCBp
bnZlc3RtZW50IG9yIHByaXZhdGUgY2FwaXRhbCBlbmhhbmNlbWVudC4NCktpbmRseSByZXBseSB0
byB0aGlzIGVtYWlsIGZvciBtb3JlIGluZm9ybWF0aW9uIGFuZCBkZXRhaWxzLg0KDQpZb3VycyBT
aW5jZXJlbHksDQpQYXVsIFN1YnJhdGEuDQo=
