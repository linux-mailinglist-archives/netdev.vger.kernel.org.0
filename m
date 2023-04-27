Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415F26F00F8
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 08:42:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243052AbjD0GmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Apr 2023 02:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242883AbjD0GmC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Apr 2023 02:42:02 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF54189;
        Wed, 26 Apr 2023 23:42:01 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-5ed99ebe076so79143776d6.2;
        Wed, 26 Apr 2023 23:42:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682577720; x=1685169720;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hUY9Ucco++sG78RHMizLj+zEgER0yWkVH+fsX/Cg59I=;
        b=dXtZGLE0tEkGM/piYB/CO5qklyOPvcEeuM11HqAFXFfJqLUwMjcVPdmODrWgVv3gw0
         wgsvDElQwdqYMBmApG2dCGx5XYvkgqBhGPDbzlWs39jGAzwbBiVC0v7Q32ChrvCn89qi
         xMsidnayNt8RejQitHQlQdqqYuvx+hVdOZbThdhP/nO5JEKZTunUOlrpOu9xrrbA1kfZ
         5LFWJS8ip5QfysnlHAoMmaKsb7//ARSK81mRwrAzceh+eg1/iCqUlh++kEDyFgl7S9U7
         +Avr/PsDSVOVhLC9PsrZYYecsw5LsaPUz/wC52Wm2AglIAiqxzIFSRb9Qfwt4J+pO6qb
         xtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682577720; x=1685169720;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hUY9Ucco++sG78RHMizLj+zEgER0yWkVH+fsX/Cg59I=;
        b=gaeltmzG54T5HzTblIlPl4ZP52X2kXcm12eHUY9bg28SBZlFNCPchysYiSt+/LGMGq
         3pIylag6jhXPUXvf2SRM0k5l4oCPam8i5NVsUFig2KqtiTVhSiFBQO9A5l6VbRLt6JSP
         8mtmT7wN0myJ01OolEeVLwOr45lpnDCDyPIgcH5HeC96B9g+1lCvW9gDEo/TbYGx99yM
         ANTEQtZF+wg2l55uoeeJDpEhhYwaOwNE28vP42f8OO/cb7OiAUnFpsIYGsKYuG1bpuki
         IMqiYWRzmvB9aS2K89x9jQSorOhg/LGBsvrLgr1EZIWJOtlJNobfxW8nAIhxbRarMp2c
         EdqA==
X-Gm-Message-State: AC+VfDxuLYPjsFUHMrTSy//qZRrQNwTOJPozks4FUjR5j0nRdTHer9f7
        ZFtbsHlFskc28Heoo7cNRjwx9hhfBDC3cJ2HAojnIgyB5fY=
X-Google-Smtp-Source: ACHHUZ6hs6iKRwlsVo3xP3+HN8ozyMFdoR8aTWLMSlGeSXcok5rp4uqlqooS3et25ZaUq5x9wTHy/7FTKlTWXv3NQxY=
X-Received: by 2002:a05:6214:5293:b0:5dd:aee7:e016 with SMTP id
 kj19-20020a056214529300b005ddaee7e016mr374675qvb.8.1682577720202; Wed, 26 Apr
 2023 23:42:00 -0700 (PDT)
MIME-Version: 1.0
From:   Bilal Khan <bilalkhanrecovered@gmail.com>
Date:   Thu, 27 Apr 2023 11:41:48 +0500
Message-ID: <CA++M5e+Edbq8qnYgGvG=oR_=Cecou_NTqxH2Z-Ld9=SdhQQLQg@mail.gmail.com>
Subject: [PATCH] Fix grammar in ip-rule(8) man page
To:     majordomo@vger.kernel.org
Cc:     netdev@vger.kernel.org
Content-Type: multipart/mixed; boundary="00000000000052101e05fa4ba724"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--00000000000052101e05fa4ba724
Content-Type: text/plain; charset="UTF-8"

Hey there,

I have identified a small grammatical error in the ip-rule(8) man
page, and have created a patch to fix it. The current first line of
the DESCRIPTION section reads:

> ip rule manipulates rules in the routing policy database control the route selection algorithm.

This sentence contains a grammatical error, as "control" should either
be changed to "that controls" (to apply to "database") or "to control"
(to apply to "manipulates"). I have updated the sentence to read:

> ip rule manipulates rules in the routing policy database that controls the route selection algorithm.

This change improves the readability and clarity of the ip-rule(8) man
page and makes it easier for users to understand how to use the ip
rule command.

I have attached the patch file
"0001-Fix-grammar-in-ip-rule-8-man-page.patch" to this email and would
appreciate any feedback or suggestions for improvement.

--00000000000052101e05fa4ba724
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-Fix-grammar-in-ip-rule-8-man-page.patch"
Content-Disposition: attachment; 
	filename="0001-Fix-grammar-in-ip-rule-8-man-page.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_lgyr8zkp0>
X-Attachment-Id: f_lgyr8zkp0

RnJvbSBiZThmNWJhMjM2MDk3N2I2YmU2OTdkMDM2YmQ5NTE1YWJlNTFkYzg1IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBCaWxhbCBLaGFuIDxiaWxhbGtoYW5yZWNvdmVyZWRAZ21haWwu
Y29tPgpEYXRlOiBXZWQsIDI2IEFwciAyMDIzIDE4OjE1OjAzICswNTAwClN1YmplY3Q6IFtQQVRD
SF0gRml4IGdyYW1tYXIgaW4gaXAtcnVsZSg4KSBtYW4gcGFnZQoKVGhlIGN1cnJlbnQgZGVzY3Jp
cHRpb24gb2YgdGhlIGlwLXJ1bGUoOCkgbWFuIHBhZ2UgY29udGFpbnMgYSBncmFtbWF0aWNhbCBl
cnJvciB0aGF0IG1ha2VzIGl0IGRpZmZpY3VsdCB0byB1bmRlcnN0YW5kLgoKVGhpcyBjb21taXQg
Zml4ZXMgdGhlIGVycm9yIGJ5IGNoYW5naW5nIHRoZSB3b3JkICdjb250cm9sJyB0byAndGhhdCBj
b250cm9scycsIHdoaWNoIGNsYXJpZmllcyB0aGUgbWVhbmluZyBvZiB0aGUgc2VudGVuY2UuIFRo
ZSBjaGFuZ2Ugd2FzIG1hZGUgaW4gdGhlIERFU0NSSVBUSU9OIHNlY3Rpb24gb2YgdGhlIG1hbiBw
YWdlLgoKVGhpcyBjb21taXQgd2lsbCBpbXByb3ZlIHRoZSByZWFkYWJpbGl0eSBhbmQgY2xhcml0
eSBvZiB0aGUgaXAtcnVsZSg4KSBtYW4gcGFnZSBhbmQgbWFrZSBpdCBlYXNpZXIgZm9yIHVzZXJz
IHRvIHVuZGVyc3RhbmQgaG93IHRvIHVzZSB0aGUgaXAgcnVsZSBjb21tYW5kLgotLS0KIG1hbi9t
YW44L2lwLXJ1bGUuOCB8IDIgKy0KIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlvbigrKSwgMSBk
ZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL21hbi9tYW44L2lwLXJ1bGUuOCBiL21hbi9tYW44L2lw
LXJ1bGUuOAppbmRleCA3NDNkODhjNi4uYzkwZDBlODcgMTAwNjQ0Ci0tLSBhL21hbi9tYW44L2lw
LXJ1bGUuOAorKysgYi9tYW4vbWFuOC9pcC1ydWxlLjgKQEAgLTg4LDcgKzg4LDcgQEAgaXAtcnVs
ZSBcLSByb3V0aW5nIHBvbGljeSBkYXRhYmFzZSBtYW5hZ2VtZW50CiAuU0ggREVTQ1JJUFRJT04K
IC5JIGlwIHJ1bGUKIG1hbmlwdWxhdGVzIHJ1bGVzCi1pbiB0aGUgcm91dGluZyBwb2xpY3kgZGF0
YWJhc2UgY29udHJvbCB0aGUgcm91dGUgc2VsZWN0aW9uIGFsZ29yaXRobS4KK2luIHRoZSByb3V0
aW5nIHBvbGljeSBkYXRhYmFzZSB0aGF0IGNvbnRyb2xzIHRoZSByb3V0ZSBzZWxlY3Rpb24gYWxn
b3JpdGhtLgogCiAuUAogQ2xhc3NpYyByb3V0aW5nIGFsZ29yaXRobXMgdXNlZCBpbiB0aGUgSW50
ZXJuZXQgbWFrZSByb3V0aW5nIGRlY2lzaW9ucwotLSAKMi4yNS4xCgo=
--00000000000052101e05fa4ba724--
