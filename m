Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EDC344EDA4
	for <lists+netdev@lfdr.de>; Fri, 12 Nov 2021 20:58:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhKLUBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 15:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbhKLUBM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 15:01:12 -0500
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF6DC061767
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 11:58:21 -0800 (PST)
Received: by mail-oi1-x22d.google.com with SMTP id o83so19873900oif.4
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 11:58:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=OG+083V6tKlKMwvIsmyHrk8e+vRUb8a/Sxa88eSnKj0=;
        b=mX5NwhSPxd6sKkrwnXx0HOeOD3AH6mYxu5G7BwR3bkyuuyfd4LNQuh9XH/lhl5CzP/
         Uc8aHJ6i6vojT2MBfRBP+IxYpcz7GBhqkXPEbBi5jKs1Ana9glsBJSKw2T0/tLYjEaCg
         LgaYYzocxLHV0WnBQ7hvvA1aH2cOmmamjS6M+AfTk0JjiL1vsFiKb04vp0dJEoKErhMa
         I+EVmyBAHN9TmNuOAnu5rgwdXjsa35AlH8q5KPDwStPN87faGuTLPvGFW9QxEqF78gpP
         YTcox0cv1TtdCDjRktyOULorC7Q8WDCsvkOW1/cOWa9hoDEFKURALe69Dag9vBMVfhs9
         HUfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=OG+083V6tKlKMwvIsmyHrk8e+vRUb8a/Sxa88eSnKj0=;
        b=xFhqiEAC55RgJ2Bt6G6Y8W9qFXgfzHYfNxmF2ReYzKbBWKsyaie3Va05sN0C1V/whS
         1JrVTuYnRvWrFEWAlDWQEa7SUh6XI+Falt3P6Mo5OXPEiDnoYkujGUd3tP//8W+inWHt
         BloRrrb99JZimEo6b6JjCtKq2eo6E2gfQaIYlYfbKEQ6KPPY2NPlnRNAJAjgSKXvRoWQ
         Edc1HA+JMcbbdNzse7eWiUtrmZ7+z6aKUdAwNeDyA1WR0jfcCQxLivOeiZdhg5bMEnLN
         cwHXglocZEfg5xzEnmFn/t6wm4xICNTpedfKfJbXA4PF6Bqq7Pkq+lqog4K5ro5bSiF4
         Ye+A==
X-Gm-Message-State: AOAM5323lU6L0HBsTlJ8Fn5PUFgtZONxTppbV22KYNr587LyC5QAT3Ls
        PYZanybt4XoxfiHb+MAqLMiiRA9cIy9oF9DVpa4=
X-Google-Smtp-Source: ABdhPJxQQJoNH1L+ZqdfNSCsP0QMX4i5D3Fcu/XtXF1bRD8xuFWyCn8Y/6v2Z5rhzhMYR+Rs31CeeyYPwvVv5HZEuUw=
X-Received: by 2002:aca:1a05:: with SMTP id a5mr16071302oia.146.1636747100383;
 Fri, 12 Nov 2021 11:58:20 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a4a:e381:0:0:0:0:0 with HTTP; Fri, 12 Nov 2021 11:58:19
 -0800 (PST)
Reply-To: mr.luisfernando5050@gmail.com
From:   "Mr. Luis Fernando" <drjubrilubaro36@gmail.com>
Date:   Fri, 12 Nov 2021 11:58:19 -0800
Message-ID: <CA+7yYtPigJB7bUvzoJhS1FNeHaggKF-_emDU3DQVLB4fCtdDjA@mail.gmail.com>
Subject: GOOD DAY
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0gDQoNCuy5nOq1rOyXkOqyjCwNCg0K7J247IKs66eQLg0KDQrsmKTripgg7J6YIOyngOuCtOqz
oCDsnojrgpjsmpQ/DQoNCuuPhOybgOydtCDtlYTsmpTtlaAg65WMIOqwnOyduCDqsoDsg4nsnYQg
7ZWY6riwIOyghOyXkCDqt4DtlZjsnZgg7J2066mU7J28IOyXsOudveyymOulvCDrsJzqsqztlojs
irXri4jri6QuDQrri7nsi6DsnZgg64+E7JuALiDrgrQg7J2066aE7J2AIE1yLmx1aXMgZmVybmFu
ZG8gJ+yZgCDtlajqu5gg7J287ZWp64uI64ukLg0KVUJBIEJhbmsgb2YgQWZyaWNh7J2YIOqwkOyC
rCDrsI8g7ZqM6rOEIOq0gOumrOyekCwNCuuqhyDrhYQg7KCE7JeQIOygnOqwgCDrs7TqtIDtlZjq
s6Ag7J6I642YIOydtCDquLDquIjsnbQg7J6I7Iq164uI64ukLg0K7J20IOyekOq4iOydhCDqt4Dt
lZjsnZgg7J2A7ZaJIOqzhOyijOuhnCDsnbTssrTtlZjquLAg7JyE7ZWcIOq3gO2VmOydmCDsp4Ds
m5ANCuyasOumrCDrqqjrkZDsl5Dqsowg7Y+J7IOdIO2IrOyekOyXkCDrjIDtlZwg7Zic7YOd6rO8
IOq4iOyVoeydgCAo66+46rWtDQoyNyw1MDDri6zrn6wuIOuwseunjCDri6zrn6wpLg0KDQrrgpjr
ipQg7J2A7ZaJ7J20IOuLueyLoOydhCDrr7/qs6Ag66a066as7Iqk7ZWY64+E66GdIOuqqOuToCDr
rLjsnZgg7IS467aAIOyCrO2VreydhCDqsIDsp4Dqs6Ag7J6I7Iq164uI64ukLg0K7J2A7ZaJIOyX
heustOydvCDquLDspIAgN+ydvCDsnbTrgrTsl5Ag6reA7ZWY7J2YIOydgO2WiSDqs4TsoozroZwg
7J6Q6riI7J2EDQrshLHqs7Ug7ZuEIOuCmOyZgOydmCDsmYTsoITtlZwg7ZiR66ClDQrsnYDtlons
nLzroZwg7J6Q6riIIOydtOyytCDshLHqs7Ug7ZuEIDUwJQ0K6rOE7KCVIOq0nOywruyVhC4NCg0K
6reA7ZWY7J2YIOydmOqyrOydhCDquLDri6Trpqzqs6Ag7J6I7Iq164uI64ukLg0K6rCQ7IKsIO2V
tOyalC4NCg0K66Oo7J207IqkIO2OmOultOuCnOuPhCDslKgNCg0KDQoNCg0KDQoNCg0KRGVhciBG
cmllbmQsDQoNCkdyZWV0aW5ncy4NCg0KSG93IGFyZSB5b3UgZG9pbmcgdG9kYXkgaSBob3BlIGZp
bmU/DQoNCkkgY2FtZSBhY3Jvc3MgeW91ciBlLW1haWwgY29udGFjdCBwcmlvciBhIHByaXZhdGUg
c2VhcmNoIHdoaWxlIGluIG5lZWQNCm9mIHlvdXIgYXNzaXN0YW5jZS4gTXkgbmFtZSBNci5sdWlz
IGZlcm5hbmRvIOKAmSBJIHdvcmsgd2l0aCB0aGUNCmRlcGFydG1lbnQgb2YgQXVkaXQgYW5kIGFj
Y291bnRpbmcgbWFuYWdlciBoZXJlIGluIFVCQSBCYW5rIG9mIEFmcmljYSwNClRoZXJlIGlzIHRo
aXMgZnVuZCB0aGF0IHdhcyBrZWVwIGluIG15IGN1c3RvZHkgeWVhcnMgYWdvIGFuZCBJIG5lZWQN
CnlvdXIgYXNzaXN0YW5jZSBmb3IgdGhlIHRyYW5zZmVycmluZyBvZiB0aGlzIGZ1bmQgdG8geW91
ciBiYW5rIGFjY291bnQNCmZvciBib3RoIG9mIHVzIGJlbmVmaXQgZm9yIGxpZmUgdGltZSBpbnZl
c3RtZW50IGFuZCB0aGUgYW1vdW50IGlzIChVUw0KJDI3LDUwMC4gTWlsbGlvbiBEb2xsYXJzKS4N
Cg0KSSBoYXZlIGV2ZXJ5IGlucXVpcnkgZGV0YWlscyB0byBtYWtlIHRoZSBiYW5rIGJlbGlldmUg
eW91IGFuZCByZWxlYXNlDQp0aGUgZnVuZCB0byB5b3VyIGJhbmsgYWNjb3VudCBpbiB3aXRoaW4g
NyBiYW5raW5nIHdvcmtpbmcgZGF5cyB3aXRoDQp5b3VyIGZ1bGwgY28tb3BlcmF0aW9uIHdpdGgg
bWUgYWZ0ZXIgc3VjY2VzcyBOb3RlIDUwJSBmb3IgeW91IHdoaWxlDQo1MCUgZm9yIG1lIGFmdGVy
IHN1Y2Nlc3Mgb2YgdGhlIHRyYW5zZmVyIG9mIHRoZSBmdW5kcyB0byB5b3VyIGJhbmsNCmFjY291
bnQgb2theS4NCg0KV0FJVElORyBUTyBIRUFSIEZST00gWU9VLg0KVEhBTktTLg0KDQpNci5sdWlz
IGZlcm5hbmRvDQo=
