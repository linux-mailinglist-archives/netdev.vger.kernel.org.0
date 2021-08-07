Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 320243E3632
	for <lists+netdev@lfdr.de>; Sat,  7 Aug 2021 17:47:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232487AbhHGPsI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Aug 2021 11:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhHGPsG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Aug 2021 11:48:06 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C423C0613CF
        for <netdev@vger.kernel.org>; Sat,  7 Aug 2021 08:47:49 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id g30so20201387lfv.4
        for <netdev@vger.kernel.org>; Sat, 07 Aug 2021 08:47:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=zbcvHOKJjSACLUOVyfnOfu33Qbf5GQgheJ5sWpOrJk0=;
        b=GFEu1tOvFIE6JrqKFQateeUj/nmq0xRYpsG6+w+e2Q0pGbkJ73hcEJ6t7YTxlj7nAX
         1+HPh18grUuMsf/MPPp/nSwWzptkACzgICCv8qjeM1knuCPX3y2dq42nBoTwyq7jwQmT
         gl1tQgYR/oR2pPBe0sy2HSKJznI+sTP59AmtWKgDdgYbinmilPYJ5pYpei/kJKyFpM69
         ENsQLatLBIiOI4J1TLQ5NVUdkTfH+99NWVOs1WWjF0Dgo0DI4w+P2JqFy6NQ1AyheAck
         /gPob4dnSto4GrZTdcJRDAuXYsPV+YMcWjH6YsMDKIxrOT1L94lKOJMxZmnrGtGzsd55
         HQvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=zbcvHOKJjSACLUOVyfnOfu33Qbf5GQgheJ5sWpOrJk0=;
        b=bnDSzi4clzePBGu6N7tCQ2SxcFhrIY+kamnoTdI/D9wowhVaM235cM6ckMa7XPUfSx
         fCBT3TGS519hBzZjRdnJnH3Wmliff9d7GT0/oSfIR0neFzZ5wT2QW+B3z5rEInTjZf1j
         QPSWn/k+4LJnbmk7JO+4Ie3Zaw5adecnCY3HBePEoUs1kneImFqOLWipHZVY51VfndP4
         CXDs2x6nyMt3jmv5SzcR4lFbptTXQn7KQ7mBwiD1Kvl7Fi1EnH6nOqOi+xTeNOa0YNYi
         f0kEz7EBdJ6uf+WLvTYfWFavBTlrbO/opuCBXlLokXNhyj56yaqEE9jTgsOjohg2KLpd
         BtBA==
X-Gm-Message-State: AOAM531DvgxIqP5mBAiGxUUfk70qxUGKUsBFD0QOz8ETem0oDwDYCHYY
        2XeA4gnjRfieGxx2HBL7B+c29JQt60liQCcGWg8=
X-Google-Smtp-Source: ABdhPJxBTZ5lp1EGCnCNnFKRNtrsLSIr+GYfO7/RgIUOa/6fPQntxU4ZsVyvxvjoIupzAktE4jcy6Po/7r/Z14akMBc=
X-Received: by 2002:a19:dc57:: with SMTP id f23mr11287696lfj.294.1628351267051;
 Sat, 07 Aug 2021 08:47:47 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6512:3108:0:0:0:0 with HTTP; Sat, 7 Aug 2021 08:47:46
 -0700 (PDT)
Reply-To: mr.tobiasadrian_imf1956@aol.com
From:   "Mr. Tobias Adrian" <yusufhasiya68@gmail.com>
Date:   Sat, 7 Aug 2021 16:47:46 +0100
Message-ID: <CALD3vyNNT1UajWK-xJbON17-v=CVrxiKwsoxJMa4Jc+HNimwcg@mail.gmail.com>
Subject: GOOD NEWS
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SU5URVJOQVRJT05BTMKgTU9ORVRBUlnCoEZVTkTCoChJTUYpDQo3MDDCoDE5dGjCoFN0cmVldCzC
oE4uVy7CoFdhc2hpbmd0b24swqBELkMuwqAyMDQzMcKgVVNBDQpXZWJzaXRlOsKgwqB3d3cuaW1m
Lm9yZw0KRmF4OsKgK8KgMcKgKDIwMinCoDYyMy03MDAwLg0KDQpEZWFywqBGdW5kwqBCZW5lZmlj
aWFyeSwNCg0KQ09NUEVOU0FUSU9OwqBGVU5EU8KgUEFZTUVOVMKgT1JERVLCoFZJQcKgQVRNwqBD
QVJEDQoNClRoaXPCoGlzwqB0b8KgaW5mb3JtwqB5b3XCoHRoYXQswqBXZcKgaGF2ZcKgYmVlbsKg
d29ya2luZ8KgdG93YXJkc8KgdGhlDQplcmFkaWNhdGlvbsKgb2bCoGZyYXVkc3RlcnPCoGFuZMKg
c2NhbcKgQXJ0aXN0c8KgaW7CoEFmcmljYcKgd2l0aMKgdGhlwqBoZWxwwqBvZg0KdGhlwqBPcmdh
bml6YXRpb27CoG9mwqBBZnJpY2FuwqBVbml0ecKgKE9BVSkswqBVbml0ZWTCoE5hdGlvbnPCoChV
TikswqBFdXJvcGVhbg0KVW5pb27CoChFVSkswqBGZWRlcmFswqBCdXJlYXXCoG9mwqBJbnZlc3Rp
Z2F0aW9uwqAoRkJJKcKgYW5kwqB3ZcKgdGhlDQpJbnRlcm5hdGlvbmFswqBNb25ldGFyecKgRnVu
ZMKgKElNRikuwqBXZcKgaGF2ZcKgYmVlbsKgYWJsZcKgdG/CoHRyYWNrwqBkb3duwqBzbw0KbWFu
ecKgb2bCoHRoaXPCoHNjYW3CoGFydGlzdMKgaW7CoHZhcmlvdXPCoHBhcnRzwqBvZsKgQWZyaWNh
bsKgY291bnRyaWVzwqB3aGljaA0KaW5jbHVkZXPCoChOaWdlcmlhLMKgUmVwdWJsaWPCoG9mwqBC
ZW5pbizCoEdoYW5hLMKgQ2FtZXJvb27CoFNvdXRowqBBZnJpY2HCoGFuZA0KU2VuZWdhbCnCoGFu
ZMKgdGhlecKgYXJlwqBhbGzCoGluIEdvdmVybm1lbnTCoGN1c3RvZHnCoG5vdyzCoHRoZXnCoHdp
bGzCoGFwcGVhcg0KYXTCoEludGVybmF0aW9uYWzCoENyaW1pbmFswqBDb3VydMKgKElDQynCoEhh
Z3VlwqAoTmV0aGVybGFuZHMpwqBzb29uwqBmb3INCkNyaW1pbmFsL0ZyYXVkwqBKdXN0aWNlLg0K
DQpEdXJpbmfCoHRoZcKgY291cnNlwqBvZsKgb3VywqBpbnZlc3RpZ2F0aW9ucyzCoHdlwqBoYXZl
wqBiZWVuwqBhYmxlwqB0b8KgcmVjb3Zlcg0Kc2/CoG11Y2jCoG1vbmV5wqBmcm9twqB0aGVzZcKg
c2NhbcKgYXJ0aXN0cy7CoFRoZcKgVW5pdGVkwqBOYXRpb25zwqBBbnRpLUNyaW1lDQpDb21taXNz
aW9uwqBhbmTCoHRoZcKgSW50ZXJuYXRpb25hbMKgTW9uZXRhcnnCoEZ1bmTCoChJTUYpwqBoYXZl
wqBvcmRlcmVkwqB0aGUNCm1vbmV5wqByZWNvdmVyZWTCoGZyb23CoHRoZcKgU2NhbW1lcnPCoHRv
wqBiZcKgc2hhcmVkwqBhbW9uZ8KgMTAsMDAwwqBMdWNreQ0KQmVuZWZpY2lhcmllc8KgYXJvdW5k
wqB0aGXCoFdvcmxkwqBmb3LCoGNvbXBlbnNhdGlvbi7CoFRoaXPCoEVtYWlsL0xldHRlcsKgaXMN
CmJlZW7CoGRpcmVjdGVkwqB0b8KgeW91wqBiZWNhdXNlwqB5b3VywqBlbWFpbMKgYWRkcmVzc8Kg
d2FzwqBmb3VuZMKgaW7CoG9uZcKgb2YNCnRoZcKgU2NhbcKgQXJ0aXN0c8KgZmlsZcKgYW5kwqBj
b21wdXRlcsKgaGFyZC1kaXNrwqBkdXJpbmfCoG91csKgaW52ZXN0aWdhdGlvbiwNCm1heWJlwqB5
b3XCoGhhdmXCoGJlZW7CoHNjYW1tZWTCoG9ywqBub3QswqB5b3XCoGFyZcKgdGhlcmVmb3JlwqBi
ZWluZw0KY29tcGVuc2F0ZWTCoHdpdGjCoHRoZcKgc3VtwqBvZsKgJDUsMDAwLMKgMDAwLjAwVVNE
wqAoRml2ZcKgTWlsbGlvbsKgVW5pdGVkDQpTdGF0ZcKgRG9sbGFycykuDQoNCldlwqBoYXZlwqBh
bHNvwqBhcnJlc3RlZMKgc29tZcKgb2bCoHRob3NlwqB3aG/CoGNsYWltwqB0aGF0wqB0aGV5wqBh
cmUNCkJhcnJpc3RlcnMswqBCYW5rwqBPZmZpY2lhbHMswqBEZWxpdmVyecKgQWdlbnRzwqBEaXBs
b21hdHPCoGFuZMKgTG90dGVyeQ0KQWdlbnRzwqB3aG/CoGhhdmXCoGJlZW7CoHNlbmRpbmfCoHlv
dcKgU01TwqBvbsKgeW91csKgcGhvbmXCoGFuZMKgZW1haWzCoHRoYXTCoHlvdQ0KaGF2ZcKgd29u
wqBhwqBsb3R0ZXJ5wqB3aGljaMKgZG9lc8Kgbm90wqBleGlzdC7CoE5vdyzCoHNpbmNlwqB5b3Vy
wqBlbWFpbMKgYWRkcmVzcw0KYXBwZWFyZWTCoGFtb25nwqB0aGXCoGx1Y2t5wqBiZW5lZmljaWFy
aWVzwqB3aG/CoHdpbGzCoHJlY2VpdmXCoHRoZQ0KY29tcGVuc2F0aW9uwqBmdW5kcyzCoHdlwqBo
YXZlwqBhcnJhbmdlZMKgeW91csKgcGF5bWVudMKgdG/CoGJlwqBwYWlkwqB0b8KgeW91DQp0aHJv
dWdowqBBVE3CoFZJU0HCoENBUkQuwqBUaGXCoEFUTcKgVmlzYcKgQ2FyZMKgd2lsbMKgYmXCoGlz
c3VlZMKgaW7CoHlvdXLCoE5hbWUNCndpdGjCoHRoZcKgJDUsMDAwLDAwMC4wMMKgVVNEwqBsb2Fk
ZWTCoGluwqBpdCzCoGFuZMKgZGVsaXZlcsKgdG/CoHlvdXLCoHBvc3RhbA0KYWRkcmVzc8Kgd2l0
aMKgdGhlwqBQaW7CoE51bWJlcizCoGFzwqB0b8KgZW5hYmxlwqB5b3XCoHdpdGhkcmF3YWzCoHlv
dXLCoGZ1bmRzDQpmcm9twqBhbnnCoEJhbmvCoEFUTcKgTWFjaGluZcKgd29ybGR3aWRlLg0KDQpO
b3RlOsKgVGhlwqBBVE3CoFZpc2HCoENhcmTCoGlzwqBhwqBnbG9iYWzCoHBheW1lbnRzwqB0ZWNo
bm9sb2d5wqB0aGF0wqBlbmFibGVzDQpjb25zdW1lcnMswqBidXNpbmVzc2VzLMKgZmluYW5jaWFs
wqBpbnN0aXR1dGlvbnPCoGFuZMKgZ292ZXJubWVudHPCoHRvwqB1c2UNCmRpZ2l0YWzCoGN1cnJl
bmN5wqBpbnN0ZWFkwqBvZsKgY2FzaMKgYW5kwqBjaGVja3MuwqBUb8KgcmVjZWl2ZcKgeW91csKg
QVRNwqBWaXNhDQpDYXJkLMKgeW91wqBhcmXCoHRoZXJlZm9yZcKgYWR2aXNlZMKgdG/CoGNvbnRh
Y3TCoHRoZcKgQVRNwqBDYXJkwqBDZW50ZXLCoGluDQpjaGFyZ2XCoG9mwqB5b3VywqBwYXltZW50
LMKgdGhpc8KgaXPCoGJlY2F1c2XCoHRoZcKgVW5pdGVkwqBOYXRpb25zwqBBbnRpLUNyaW1lDQpD
b21taXNzaW9uLMKgdGhlwqBJbnRlcm5hdGlvbmFswqBNb25ldGFyecKgRnVuZMKgYW5kwqB0aGXC
oFVuaXRlZMKgU3RhdGVzDQpHb3Zlcm5tZW50wqBoYXPCoGNob3NlbsKgdGhlbcKgdG/CoHBheW91
dMKgYWxswqB0aGXCoGNvbXBlbnNhdGlvbsKgZnVuZHPCoHRvwqB0aGUNCjEwLDAwMMKgTHVja3nC
oGJlbmVmaWNpYXJpZXMuDQoNCktpbmRsecKgY29udGFjdMKgdGhlwqBBVE3CoENhcmTCoElzc3Vh
bmNlwqBEZXBhcnRtZW50wqBDaXRpYmFuayBub3fCoHdpdGgNCnRoZXJlwqBiZWxsb3fCoGNvbnRh
Y3TCoGRldGFpbHMgZm9yIHRoZSBhY3RpdmF0aW9uIGFuZCBkZWxpdmVyeSBvZiB5b3VyDQpDYXJk
Lg0KDQpBVE3CoENhcmTCoERlcGFydG1lbnQNCkNvbnRhY3TCoFBlcnNvbjrCoE1yLsKgUmF5wqBD
aGFybGVzwqBTbWl0aA0KVGV4YXPCoFVuaXRlZMKgU3RhdGVzDQpFbWFpbDrCoHJheS5jaGFybGVz
c21pdGhfY2l0aWJhbmt0eDIwMjFAYW9sLmNvbQ0KKFdoYXRzQXBwIG9ubHkpOiArMSA5MTQtNTc1
LTI0NDcNCg0KDQpDb250YWN0wqB0aGXCoEFUTcKgRGVwYXJ0bWVudMKgZm9ywqB0aGXCoGFjdGl2
YXRpb27CoGFuZMKgZGVsaXZlcnnCoG9mwqB5b3VyDQpDYXJkwqB0b8KgeW91csKgYWRkcmVzc8Kg
d2l0aG91dMKgYW55wqBkZWxhecKgYW5kwqBwbGVhc2XCoGJlwqB3YXJuZWTCoHRoYXTCoHRoZQ0K
VW5pdGVkwqBOYXRpb25zwqBBbnRpLUNyaW1lwqBDb21taXNzaW9uwqBhbmTCoHRoZcKgSW50ZXJu
YXRpb25hbMKgTW9uZXRhcnkNCkZ1bmTCoChJTUYpwqBkb2VzwqBub3TCoGluc3RydWN0wqBhbnnC
oG90aGVywqBCYW5rwqBvcsKgYWdlbnTCoGZvcsKgdGhpc8KgcGF5bWVudA0KZXhjZXB0wqB0aGXC
oENJVElCQU5LIEFUTcKgRGVwYXJ0bWVudA0KDQpUaGFua3PCoGZvcsKgeW91csKgdW5kZXJzdGFu
ZGluZ8KgYXPCoHlvdcKgZm9sbG93wqBpbnN0cnVjdGlvbnMuDQoNCllPVVJTwqBJTsKgU0VSVklD
RVMsDQpNUi7CoFRPQklBU8KgQURSSUFODQpESVJFQ1RPUiBGSU5BTkNJQUzCoENPVU5TRUxMT1LC
oEFORMKgTU9ORVRBUlnCoENBUElUQUwNCklOVEVSTkFUSU9OQUzCoE1PTkVUQVJZwqBGVU5EDQo=
