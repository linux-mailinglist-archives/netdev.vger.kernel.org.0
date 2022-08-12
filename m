Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85F9B590CE8
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 09:53:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237660AbiHLHxp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 03:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236480AbiHLHxp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 03:53:45 -0400
Received: from m1391.mail.163.com (m1391.mail.163.com [220.181.13.91])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 720FFA7224
        for <netdev@vger.kernel.org>; Fri, 12 Aug 2022 00:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=Date:From:Subject:MIME-Version:Message-ID; bh=avNxx
        pYmKBOVq/0yVvumS+JmOyug8DQ6TQjVlgwCY9E=; b=Y0ZIY7EyjDScrqL/O5iym
        t05cflAUuflV232FMu0QBGvIUDUAgai6UW3r+yolVnDou4mGdLDOfKCIePFAx+vy
        X992rxz64ldWMDv0DphzEKCOLjG231V3X5wFWUHJqH9BrT0IlBLF1bvbnCmi+c4R
        GXeQVm8T4LhLXtnnUbQv74=
Received: from 15720603159$163.com ( [119.3.119.21] ) by
 ajax-webmail-wmsvr91 (Coremail) ; Fri, 12 Aug 2022 15:53:38 +0800 (CST)
X-Originating-IP: [119.3.119.21]
Date:   Fri, 12 Aug 2022 15:53:38 +0800 (CST)
From:   jiangheng <15720603159@163.com>
To:     netdev@vger.kernel.org
Subject: [PATCH iproute2]rdma: modify the command output message of rdma
 statistic help based on man manual
X-Priority: 3
X-Mailer: Coremail Webmail Server Version XT5.0.13 build 20220113(9671e152)
 Copyright (c) 2002-2022 www.mailtech.cn 163com
Content-Transfer-Encoding: base64
Content-Type: text/plain; charset=UTF-8
MIME-Version: 1.0
Message-ID: <25ce8a4f.6db0.182910b625a.Coremail.15720603159@163.com>
X-Coremail-Locale: zh_CN
X-CM-TRANSID: W8GowAB35BYCB_ZieY2bAA--.57648W
X-CM-SenderInfo: jprvljyqwqjievzbjqqrwthudrp/xtbCqRtbhV0DgnPd9QAAsr
X-Coremail-Antispam: 1U5529EdanIXcx71UUUUU7vcSsGvfC2KfnxnUU==
X-Spam-Status: No, score=-1.5 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FROM_LOCAL_DIGITS,
        FROM_LOCAL_HEX,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

CkZyb20gNGNlOGQ2MGYzNGM1Y2RjZmY4YjI1ZTNjMzg5MWZjMDUzNzM2MjI1YiBNb24gU2VwIDE3
IDAwOjAwOjAwIDIwMDEKRnJvbTogamluYWcgPGppbmFnMTIxMzhAZ21haWwuY29tPgpEYXRlOiBG
cmksIDEyIEF1ZyAyMDIyIDE1OjQ4OjA3ICswODAwClN1YmplY3Q6IFtQQVRDSF0gcmRtYTogbW9k
aWZ5IHRoZSBjb21tYW5kIG91dHB1dCBtZXNzYWdlIG9mIHJkbWEgc3RhdGlzdGljIGhlbHAKwqBi
YXNlZCBvbiBtYW4gbWFudWFsCgoKLS0tCsKgcmRtYS9zdGF0LmMgfCA2ICsrKy0tLQrCoDEgZmls
ZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgoKZGlmZiAtLWdpdCBh
L3JkbWEvc3RhdC5jIGIvcmRtYS9zdGF0LmMKaW5kZXggYWFkODgxNWMuLjFlODY5YzI1IDEwMDY0
NAotLS0gYS9yZG1hL3N0YXQuYworKysgYi9yZG1hL3N0YXQuYwpAQCAtMjQsMTAgKzI0LDEwIEBA
IHN0YXRpYyBpbnQgc3RhdF9oZWxwKHN0cnVjdCByZCAqcmQpCsKgIMKgIHByX291dCgiwqAgwqAg
wqAgwqAlcyBzdGF0aXN0aWMgbW9kZSBbIHN1cHBvcnRlZCBdIGxpbmsgWyBERVYvUE9SVF9JTkRF
WCBdXG4iLCByZC0+ZmlsZW5hbWUpOwrCoCDCoCBwcl9vdXQoIsKgIMKgIMKgIMKgJXMgc3RhdGlz
dGljIHNldCBsaW5rIFsgREVWL1BPUlRfSU5ERVggXSBvcHRpb25hbC1jb3VudGVycyBbIE9QVElP
TkFMLUNPVU5URVJTIF1cbiIsIHJkLT5maWxlbmFtZSk7CsKgIMKgIHByX291dCgiwqAgwqAgwqAg
wqAlcyBzdGF0aXN0aWMgdW5zZXQgbGluayBbIERFVi9QT1JUX0lOREVYIF0gb3B0aW9uYWwtY291
bnRlcnNcbiIsIHJkLT5maWxlbmFtZSk7Ci3CoCDCoHByX291dCgid2hlcmXCoCBPQkpFQ1Q6ID0g
eyBxcCB9XG4iKTsKLcKgIMKgcHJfb3V0KCLCoCDCoCDCoCDCoENSSVRFUklBIDogPSB7IHR5cGUg
fVxuIik7CivCoCDCoHByX291dCgid2hlcmXCoCBPQkpFQ1Q6ID0geyBxcCB8IG1yIH1cbiIpOwor
wqAgwqBwcl9vdXQoIsKgIMKgIMKgIMKgQ1JJVEVSSUEgOiA9IHsgdHlwZSB8IHBpZCB9XG4iKTsK
wqAgwqAgcHJfb3V0KCLCoCDCoCDCoCDCoENPVU5URVJfU0NPUEU6ID0geyBsaW5rIHwgZGV2IH1c
biIpOwotwqAgwqBwcl9vdXQoIsKgIMKgIMKgIMKgRklMVEVSX05BTUU6ID0geyBjbnRuIHwgbHFw
biB8IHBpZCB9XG4iKTsKK8KgIMKgcHJfb3V0KCLCoCDCoCDCoCDCoEZJTFRFUl9OQU1FOiA9IHsg
Y250biB8IGxxcG4gfCBwaWQgfCBxcF90eXBlIH1cbiIpOwrCoCDCoCBwcl9vdXQoIkV4YW1wbGVz
OlxuIik7CsKgIMKgIHByX291dCgiwqAgwqAgwqAgwqAlcyBzdGF0aXN0aWMgcXAgc2hvd1xuIiwg
cmQtPmZpbGVuYW1lKTsKwqAgwqAgcHJfb3V0KCLCoCDCoCDCoCDCoCVzIHN0YXRpc3RpYyBxcCBz
aG93IGxpbmsgbWx4NV8yLzFcbiIsIHJkLT5maWxlbmFtZSk7Ci0tCjIuMjMuMA==
