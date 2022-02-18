Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA9A94BB95D
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 13:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235112AbiBRMmZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 07:42:25 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235129AbiBRMmX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 07:42:23 -0500
Received: from mail-qv1-xf33.google.com (mail-qv1-xf33.google.com [IPv6:2607:f8b0:4864:20::f33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36DE7222F17
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:42:06 -0800 (PST)
Received: by mail-qv1-xf33.google.com with SMTP id a19so14413336qvm.4
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 04:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=aSAF2sHKTwSF7j4fTH+p58wNfo1PeSQsVVnfk56UyRo=;
        b=aR7i7kvlEDJdqcKGkeZs2V6fpOVNk5tcIIJHPKsCXBtM65gYUM2wypC+NfXRdPdgG+
         22LVTnddfMEH6fMoBgct5rnIA5rDGEPZlyHgRwYWQtpWavWfUKV1+udtvYzhNiCb+wab
         zqWWPTdq5Ei15UUdJMhYBlea5q5LTp56+loynxfG8FETI1Md4km+rf0Ibeyo4Szdtanv
         rGrzP+U7ZZk9NRUoC99BqgS069Xjj38n+lRdAgs0Vqxh2UJLJj0/gK3slDnKK+OEAuAZ
         vDV1VHV9Dat8/rPFZB2NIBtBzJIqwkkLq33G6GHZEA/1U6cNS76TleQWLfmMlqNz4Thw
         PYVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=aSAF2sHKTwSF7j4fTH+p58wNfo1PeSQsVVnfk56UyRo=;
        b=Y12yymZjeN3JLbtiDGeLFHfX/P0IhbGh6ox+J1vNnROF+ZaHSn57WMjoM0dfXOaXSn
         VBk+Q/V2V7t3/kvuY1UZMFlSBLRsQX3VxDT5a6xyXX8CpZP0wVSHSugKxc4lpRCHBdU4
         tiBrsbVLnXDUc5ktC8WkoVm4Eod4bhVYHg8/tOgV39v905jSXY7ySrH4LWG3/yFJpCaq
         2C1QZj1hZXHywYBun9IuTzuFh+EKeqt/FvdZAVVQlv4c5/j2d0bfbzVWkDG0xRL+AbrE
         TtOIrMCCCLOO5ScRrzcHUZGrni+ikdS0zPdVWId7BlMojlAF8PksjHQvovf1mGaQ9JKe
         MdXA==
X-Gm-Message-State: AOAM533Qv6MyJdOclDEUkacutQXnTERyzfF6GadtZ2/B/C8x+L8ofJB1
        6iz8N4cupsJdlQQR40DvolSYKQS5zNHZDCkD5fY=
X-Google-Smtp-Source: ABdhPJwjUlHTSrIof2R9w1TEhpwVPi6lbX+jfEh8Fzz0Ny6SsinhqPAm5P9Vbdz9a41KqM5nTZatnmkxQjrxReI/VNQ=
X-Received: by 2002:ac8:5a03:0:b0:2d7:f146:1599 with SMTP id
 n3-20020ac85a03000000b002d7f1461599mr6459458qta.71.1645188125264; Fri, 18 Feb
 2022 04:42:05 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6214:234c:0:0:0:0 with HTTP; Fri, 18 Feb 2022 04:42:04
 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   Orlando Moris <jonesregina165@gmail.com>
Date:   Fri, 18 Feb 2022 12:42:04 +0000
Message-ID: <CAMWeqz2tzsABWPSgZRWFMzBeHk9+FFtir1XXUkf6jCUBQBYL8Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:f33 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5001]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [jonesregina165[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [orlandomoris56[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [jonesregina165[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

zprOkc6bzpfOnM6VzqHOkSwgzqPOsc+CIM61zr3Ot868zrXPgc+Ozr3Ov8+FzrzOtSDPjM+Ezrkg
zrHPhc+Ez4wgz4TOvyBlbWFpbCDPgM6/z4Ugzq7Pgc64zrUgz4PPhM6/DQrOs8+BzrHOvM68zrHP
hM6/zrrOuc6yz47PhM65z4wgz4POsc+CIM60zrXOvSDOtc6vzr3Osc65IM67zqzOuM6/z4IsIM6x
zrvOu86sIM6xz4DOtc+FzrjPjc69zrjOt866zrUgzrXOuc60zrnOus6sIM+DzrUgzrXPg86sz4IN
Cs6zzrnOsSDOrM68zrXPg863IM61zr7Orc+EzrHPg863LiDOiM+Hz4kgzrzOuc6xIM+Az4HPjM+E
zrHPg863IM+Nz4jOv8+Fz4IgKDcuNTAwLjAwMCwwMCAkKSwgz4DOv8+FIM6sz4bOt8+DzrUgzr8N
Cs6xzrXOr868zr3Ot8+Dz4TOv8+CIM+AzrXOu86sz4TOt8+CIM68zr/PhSwgzr8gzr/PgM6/zq/O
v8+CIM+Az4HOuc69IM6xz4DPjCDPhM6/IM64zqzOvc6xz4TPjCDPhM6/z4UgzrbOv8+Nz4POtSDO
us6xzrkNCs61z4HOs86xzrbPjM+EzrHOvSDOtc60z44gz4PPhM6/IM6bzr/OvM6tIM6kz4zOs866
zr8gzrzOrc+Hz4HOuSDPhM6/zr0gz4TPgc6xzrPOuc66z4wgzrjOrM69zrHPhM+MIM+Ezr/PhSDO
vM61IM+EzrfOvQ0Kzr/Ouc66zr/Os86tzr3Otc65zqwgz4TOv8+FIM+DzrUgz4TPgc6/z4fOsc6v
zr8gzrHPhM+Nz4fOt868zrEuIM6Vz4DOuc66zr/Ouc69z4nOvc+OIM68zrHOts6vIM+DzrHPgiDP
ic+CIM6/DQrPgM67zrfPg865zq3Pg8+EzrXPgc6/z4Igz4PPhc6zzrPOtc69zq7PgiDPhM6/z4Ug
zrHPgM6/zrjOsc69z4zOvc+Ezr/Pgiwgz47Pg8+EzrUgzr3OsSDOvM+Azr/Pgc61zq/PhM61IM69
zrEgzrvOrM6yzrXPhM61IM+EzrENCs+Hz4HOrs68zrHPhM6xIM68zrXPhM6sIM6xz4DPjCDOsc6+
zrnPjs+DzrXOuc+CLiDOnM61z4TOrCDPhM63zr0gz4TOsc+HzrXOr86xIM6xz4DOrM69z4TOt8+D
zq4gz4POsc+CIM64zrEgz4POsc+CDQrOtc69zrfOvM61z4HPjs+Dz4kgzrPOuc6xIM+Ezr/OvSDP
hM+Bz4zPgM6/IM67zrXOuc+Ezr/Phc+BzrPOr86xz4Igz4TOv8+FDQrOtc66z4TOrc67zrXPg863
IM6xz4XPhM6uz4Igz4TOt8+CIM+Dz4XOvM+Gz4nOvc6vzrHPgi4sIM61z4DOuc66zr/Ouc69z4nO
vc6uz4PPhM61IM68zrHOts6vIM68zr/PhSDPg861IM6xz4XPhM+MIM+Ezr8gZW1haWwNCihvcmxh
bmRvbW9yaXM1NkBnbWFpbC5jb20pDQo=
