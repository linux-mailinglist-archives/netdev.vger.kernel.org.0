Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B602278A53
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 16:07:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728854AbgIYOHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 10:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYOHU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 10:07:20 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C8FC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 07:07:19 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e17so3189361wme.0
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 07:07:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=SDYuxl6P5MmFVHNoRCXiUclDzzcJxN4Z9cpUKPgKZDY=;
        b=eoK7LZc7ZwFs8utNOoQ3MKksf8wRFOw7b67PcrbGxFOuJK7AXMFp4LRp8x9/Zn0Yo4
         mZoCH6GKicFkpLQxeqzWmKo8ODGzErlWlYq5PMqlGbUfA9CVy16vXbcGMCrZGrE0xc4s
         QbXrbc08BIz/6+gJkQrbAgoUmzy30w1r8mbaS+65cdrAPHE7XgnQgKoVs5tJnkTA6eiS
         rmmWUIt3+ohZ9rTlCLZw8HpwdlcQQvnost6a01cSN26s7h3ec1Lb0IbSJFYSXoJnslhu
         7RW+xwrrQAYgf25ImDt5GN39MOqBp2JMnllMfP4tv6GNUjBV/jgKxfVwbjEOmpFcEmQU
         T3aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=SDYuxl6P5MmFVHNoRCXiUclDzzcJxN4Z9cpUKPgKZDY=;
        b=NNOQpYkIjx8E+73zU6TcTVxEss4WeWCmDqslkSprG84Y7XodRXWOLzYplfqhp8YvKr
         cnjs/0wXaP4H/2UYa5LOiLx4ZR5UP+UhFhtFuXSXqvTDkL8kQ7uAFiFHEHdBi+GOxyfS
         0VxYc7jCUBiEA5t6pWtc/ZY6exK+9xpJZP1bGsp4o4L1WF/2Pmju+Fm0ZXajVV3laF8+
         BMVzjZTdoIYJ+KAxP8RCA+Uoo5l/tuUDtmRy/vZ1adkW7A3RV9mlBeUoq/BFv/CzSl0X
         2YGgkQLajcDXAqbWu+X4evOedkqtExQPdQtUkONQvOyx9WDtymjxwrJlAhKOHYkmwBfU
         LU5Q==
X-Gm-Message-State: AOAM530iwglWK+MDHBi5NUtjeNUWsNx9S5dazL/xegTtd5lnmMdNfW43
        TCU3+qrI6DG2JzVJ15sTGek6diRxM++nBl0pjTE=
X-Google-Smtp-Source: ABdhPJwj+emcQlTpFm1+LJSgcM3ee5IVjvWKbhW7O5AP1x1Hk6d474n/qM6acwyn9Jfm5wCra+M/rkm7CAvmPQ5pqPI=
X-Received: by 2002:a1c:2e17:: with SMTP id u23mr3562128wmu.73.1601042838517;
 Fri, 25 Sep 2020 07:07:18 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:adf:f990:0:0:0:0:0 with HTTP; Fri, 25 Sep 2020 07:07:18
 -0700 (PDT)
Reply-To: mrs.esthernicolas@yahoo.com
From:   "Mrs. Esther Nicolas" <elizabethjohnson184@gmail.com>
Date:   Fri, 25 Sep 2020 07:07:18 -0700
Message-ID: <CAFDOM0Zp_zDgocA-zHFOYVUeHOSLWzwssV8Vervyc4wC7Oz5DQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TmVqZHJhxb7FocOtIHYgS3Jpc3R1LA0KUyBuw6FsZcW+aXRvdSDDumN0b3UgYSBsaWRza29zdMOt
IGpzZW0gYnlsIHDFmWludWNlbiB2w6FtIG5hcHNhdCBodW1hbml0w6FybsOtDQpwxa9kdS4gSm1l
bnVqaSBzZSBwYW7DrSBFc3RoZXIgTmljb2xhcy4gTmFyb2RpbCBqc2VtIHNlIHYgQXJpem9uxJsg
dmUNClBob2VuaXh1LiBKc2VtIMW+ZW5hdMO9IHMgcGFuZW0gSmFjb2IgTmljb2xhcywgxZllZGl0
ZWxlbSBKYWNvbiBJbmR1c3RyeQ0KVG9nby4gQnlsaSBqc21lIG1hbsW+ZWzDqSB0xZlpY2V0IMWh
ZXN0IGxldCBiZXogZMOtdMSbdGUuIFplbcWZZWwgcG8gb3BlcmFjaQ0Kc3JkZcSNbsOtY2ggdGVw
ZW4uIEEgbmVkw6F2bm8gbWkgZG9rdG9yIMWZZWtsLCDFvmUgbmV2eWRyxb7DrW0gZGFsxaHDrWNo
IMWhZXN0DQptxJtzw61jxa8ga3bFr2xpIG3DqW11IHByb2Jsw6ltdSBzIHJha292aW5vdSAocmFr
b3ZpbmEgamF0ZXIgYSBjw6l2bsOtIG1vemtvdsOpDQpwxZnDrWhvZHkpLiBOZcW+IG3Fr2ogbWFu
xb5lbCBsb25pIHplbcWZZWwsIGplIHR1IMSNw6FzdGthIGR2YSBtaWxpb255IG9zbSBzZXQNCnRp
c8OtYyBkb2xhcsWvLCBrdGVyw6kgdWxvxb5pbCB2IGJhbmNlIHpkZSB2IFRvZ3UuIFYgc291xI1h
c27DqSBkb2LEmyBqc291DQp0eXRvIHBlbsOtemUgc3TDoWxlIHYgYmFuY2UuIEtkecW+IGpzZW0g
dsSbZMSbbCBvIHN2w6ltIHN0YXZ1LCByb3pob2RsIGpzZW0NCnNlIGRhcm92YXQgdGVudG8gZm9u
ZCBqYWvDqW11a29saSBkb2Jyw6ltdSBicmF0cm92aSBuZWJvIHNlc3TFmWUgdiBvYmF2xJsNCnDF
mWVkIEJvaGVtLCBrdGVyw70gdGVudG8gZm9uZCB2eXXFvmlqZSB6cMWvc29iZW0sIGt0ZXLDvW0g
emRlIGJ1ZHUNCmluc3RydW92YXQuIENoY2kgbsSba29obywga2RvIHRlbnRvIGZvbmQgcG91xb5p
amUgcG9kbGUgcMWZw6Fuw60gbcOpaG8NCnplc251bMOpaG8gTWFuxb5lbGEsIGFieSBwb21vaGwg
bcOpbsSbIHByaXZpbGVnb3ZhbsO9bSBsaWRlbSwgc2lyb3TEjWluY8WvbSwNCnZkb3bDoW0gYSDF
ocOtxZlpbCBCb8W+w60gc2xvdm8uIFJvemhvZGwganNlbSBzZSBwcm90bywgxb5lIG5lbcOhbSDF
vsOhZG7DqSBkw610xJssDQprdGVyw6kgYnkgemTEm2RpbG8gdGVudG8gZm9uZC4gQSBuZWNoY2kg
enDFr3NvYiwgamFrIGJ1ZG91IHR5dG8gcGVuw616ZQ0KcG91xb5pdHkgYmV6Ym/Fvm7DvW0genDF
r3NvYmVtLiBQcm90byBwxZlpasOtbcOhbSB0b3RvIHJvemhvZG51dMOtIHDFmWVkYXQgdsOhbQ0K
dGVudG8gZm9uZC4gTmVib2rDrW0gc2Ugc21ydGksIHByb3RvIHbDrW0sIGthbSBqZHUuIENoY2ks
IGFieXN0ZSBuYSBtxJsNCnZlIHN2w71jaCBrYcW+ZG9kZW5uw61jaCBtb2RsaXRiw6FjaCB2xb5k
eSBwYW1hdG92YWxpIGt2xa9saSBtw6kgbmFkY2jDoXplasOtY8OtDQpjaGlydXJnaWNrw6kgbMOp
xI1ixJsgcmFrb3ZpbnkuIE9kZXBpxaF0ZSBjbyBuZWpkxZnDrXZlIGpha8Opa29saSB6cG/FvmTE
m27DrSB2ZQ0KdmHFocOtIG9kcG92xJtkaSBtaSBkw6EgcHJvc3RvciBwcm8gesOtc2vDoW7DrSBq
aW7DqSBvc29ieSBwcm8gc3Rlam7DvSDDusSNZWwgdg0KbmFkxJtqaSwgxb5lIG9kIHbDoXMgYnVk
dSDEjcOtc3QgY28gbmVqZMWZw612ZS4gQsWvaCB2w6FtIMW+ZWhuZWosIGtkecW+DQpwb3Nsb3Vj
aMOhdGUgaGxhcyB1dmHFvm92w6Fuw60sIHBhbsOtIEVzdGhlciBOaWNvbGFzLg0K
