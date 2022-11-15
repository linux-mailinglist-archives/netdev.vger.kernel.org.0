Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51908629BFF
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 15:24:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiKOOYc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 09:24:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbiKOOY2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 09:24:28 -0500
Received: from mail-yw1-x112a.google.com (mail-yw1-x112a.google.com [IPv6:2607:f8b0:4864:20::112a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2265522537
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:24:27 -0800 (PST)
Received: by mail-yw1-x112a.google.com with SMTP id 00721157ae682-37063f855e5so138375737b3.3
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 06:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=j1fPL+nMBhiiMv7wUlO9WZriEt9grZuM8SVZB1W8ZQ4=;
        b=qPp0f+6GLqfGfP15pWUOHK/dJugx2vBVe0of8jlEgnc9p0V4x6ZPdbdf1ikBvGn9xM
         DBCCSmOtgrLVgGF2zPfur97lhHFHB6W2SSfBMpDj72JDmC6vFfEW4egt32VHQZ/HnihC
         oVBK9pFvdwtlDsCwJFZNgGYTVgxBs1QTYkoFoRcMGMFlL6orrdshjI5tV7SpAhhEjE9R
         rvJ4wY92JWRPHMC4yYwPix7XLr4SD5all2BiCbnR3X9ksEYDzXI2AeiELlpYDDuXd5FM
         C6kHfX2zmGUS2mtA5EoPCgfHQ5Nlki13omVzeictAvcvd/wkkFacIIsdUbFlrSrBNtrH
         Ecog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=j1fPL+nMBhiiMv7wUlO9WZriEt9grZuM8SVZB1W8ZQ4=;
        b=Hl5Qb0gkI/GpXdPkCHYV0ii+bmebLIhOs16BA2cil9qxIZZyBFY3+vq9Zv6YXlAI79
         TzfZ1oNq8ute8sWkyxqZ8jJj3DK8uC6cIUBdZ62m7qi3E+1sO6bwP0il7lIx8Akxcc7F
         7l4MsxpqmiwHIZ3CXwhpqE+DmV4jJOl76O9n174JbKHmeNDwjYjzvRCB2krNi7WOB6zB
         2VSvkIfbGNxvUi8ysu2kVj/91x1kuzo0PalqvrS8xE0Y1KbT74PVQXyE/qombNQaFPyC
         0SblQecf2iFOC+k3IeSwJCithyiZRTQ1dVmC77KZYumGjuIYbG7Ys1b7Ri76vhV8rAd2
         IOwQ==
X-Gm-Message-State: ANoB5pklvDUCHOBZNqRpxJvhy1xuZJmd5PiQ/p9+hS+IEoqUpuxyO1ce
        Q32YgCTOOsO6C8/yJHZzgY6qmKTnIbQNEluOEDg=
X-Google-Smtp-Source: AA0mqf6LKyis6E14AIsUpXGtuPvG8x7RqpIZZXVHpjAHCUM6g86mpy5rvUEr/g8GtfhpFHUJrjXR1YVsn40LTLG6sEU=
X-Received: by 2002:a81:9bc1:0:b0:370:4a99:df7d with SMTP id
 s184-20020a819bc1000000b003704a99df7dmr17206747ywg.308.1668522266327; Tue, 15
 Nov 2022 06:24:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6919:c70d:b0:f0:aad8:4678 with HTTP; Tue, 15 Nov 2022
 06:24:26 -0800 (PST)
Reply-To: westernuniontg453@gmail.com
From:   POST OFFICE <westernuniontogorepublic55@gmail.com>
Date:   Tue, 15 Nov 2022 14:24:26 +0000
Message-ID: <CACT2zkrhiHF1zOW2_m5dKv5LTNLzQakUs2VkHd-jiFFVA6haxQ@mail.gmail.com>
Subject: =?UTF-8?B?R8O8bsO8bsO8eiB4ZXlpciDJmXppemlt?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [westernuniontogorepublic55[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [westernuniontg453[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [westernuniontogorepublic55[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SMO2cm3JmXRsaSBFLXBvw6d0IFNhaGliaTsNCg0KQmV5bsmZbHhhbHEgVmFseXV0YSBGb25kdSAo
QlZGKSBiw7x0w7xuIGTJmWzJmWR1emx1cSBxdXJiYW5sYXLEsW5hIHbJmSB0yZlsyZliDQpvbHVu
bWFtxLHFnyB2yZlzYWl0bMmZcmkgb2xhbmxhcmEga29tcGVuc2FzaXlhIMO2ZMmZeWlyIHbJmSBz
aXppbiBlLXBvw6d0DQrDvG52YW7EsW7EsXogdMmZbMmZYiBvbHVubWF5YW4gZm9uZCBzaXlhaMSx
c8SxbmRhIHRhcMSxbGTEsS4gQnUgV2VzdGVybiBVbmlvbg0Kb2Zpc2kgQlZGIHTJmXLJmWZpbmTJ
mW4ga29tcGVuc2FzaXlhbsSxesSxIFdlc3Rlcm4gVW5pb24gTW9uZXkgVHJhbnNmZXINCnZhc2l0
yZlzaWzJmSBzaXrJmSBrw7bDp8O8cm3JmWsgdGFwxZ/EsXLEscSfxLEgdmVyaWIuIEJpeiBhcmHF
n2TEsXJkxLFxIHbJmSBidSBmb25kdW4NCnFhbnVuaSBzYWhpYmkgb2xkdcSfdW51enUgbcO8yZl5
ecmZbiBldGRpay4NCg0KQnVudW5sYSBiZWzJmSwgw7xtdW1pIG3JmWJsyZnEnyA4MDAsMDAwLjAw
IEFCxZ4gZG9sbGFyxLEgdGFtYW1pbMmZIHNpesmZDQprw7bDp8O8csO8bMmZbsmZIHHJmWTJmXIg
Yml6IMO2eiDDtmTJmW5pxZ9pbml6aSBXZXN0ZXJuIFVuaW9uIE1vbmV5IFRyYW5zZmVyDQp2YXNp
dMmZc2lsyZkgaMmZciBnw7xuICQ1MDAwIGvDtsOnw7xybcmZayBxyZlyYXLEsW5hIGfJmWxkaWsu
DQoNCkJpeiBidSDDtmTJmW5pxZ9pIHlhbG7EsXogZS1wb8OndCDDvG52YW7EsW7EsXpsYSBnw7Zu
ZMmZcsmZIGJpbG3JmXnJmWPJmXlpaywgb25hDQpnw7ZyyZkgZMmZIHNpesmZIGfDvG5kyZlsaWsg
NTAwMCBkb2xsYXIgZ8O2bmTJmXLJmWPJmXlpbWl6IHllcsmZIG3JmWx1bWF0xLFuxLF6DQpsYXrE
sW1kxLFyLCBtyZlzyZlsyZluOw0KDQpBbMSxY8SxbsSxbiBhZMSxOiBfX19fX19fX19fX19fX19f
DQrDnG52YW46IF9fX19fX19fX19fX19fX18NCsOWbGvJmTogX19fX19fX19fX19fX19fXw0KUGXF
n8mZOiBfX19fX19fX19fX19fX19fDQpUZWxlZm9uIG7Dtm1yyZlzaTpfX19fX19fX19fX19fX19f
DQrFnsmZeHNpeXnJmXQgdsmZc2lxyZluaXppbiDJmWxhdsmZIGVkaWxtacWfIHN1csmZdGk6IF9f
X19fX19fX19fDQpZYcWfOiBfX19fX19fX19fX19fX19fX19fX19fDQoNCll1eGFyxLFkYWvEsSBt
yZlsdW1hdMSxbsSxesSxIGFsYW4ga2ltaSBrw7bDp8O8cm3JmXnJmSBiYcWfbGF5YWNhxJ/EsXEs
IMaPbGFxyZkNCkUtcG/Dp3R1OiAod2VzdGVybnVuaW9udGc0NTNAZ21haWwuY29tKQ0KDQpzyZlk
YXHJmXRsyZkgdMmZxZ/JmWtrw7xyIGVkaXLJmW0sDQoNClhhbsSxbSBNYXJ0aW5zIE5hbm55LCBX
ZXN0ZXJuIFVuaW9uIE1vbmV5IFRyYW5zZmVyIMWfaXJryZl0aW5pbiBkaXJla3RvcnUsDQpCYcWf
IG9maXMgTG9tZSBUb3FvLg0K
