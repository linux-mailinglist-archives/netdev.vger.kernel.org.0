Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619DD4A7127
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 13:58:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233005AbiBBM6x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 07:58:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229545AbiBBM6w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 07:58:52 -0500
Received: from mail-ua1-x932.google.com (mail-ua1-x932.google.com [IPv6:2607:f8b0:4864:20::932])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EEAC061714
        for <netdev@vger.kernel.org>; Wed,  2 Feb 2022 04:58:52 -0800 (PST)
Received: by mail-ua1-x932.google.com with SMTP id w21so18915347uan.7
        for <netdev@vger.kernel.org>; Wed, 02 Feb 2022 04:58:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=HMGYry/Z8hfaHLNwFqzEMNFDJCq2Xunj6FYUYgJNj+0=;
        b=F8/oT1YCAKz+OHBaCY0s6aLnmKHqTED0jJM8HzW+NZmRw8ZJlp7Sah2pMSCOFKpdhx
         Ut+ZN4X2hKam5OtnfXbsPP3sbUfdBnBA6C5hVZj0IHBAvp7dZxtd/cVFDFRMpyCJHqDn
         FzOZwGZPGqlsGKTE3J914cQiUntPBwFBP2ayrDh3GuWDpCBBHl+3dD14R5HUw+tyELgA
         26K4Hw5UhEqNoTYdFnigsG6um4rHk3ghJDvyqfxgh+p97xRcldEQbi+pzUk1QbXOr//1
         E4en8E506vO4ivw7G49f++nVjTHO0ytctkNPWBzrbc6U3s8gtke6oex4vbmYxjuaomnN
         ZFFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to:content-transfer-encoding;
        bh=HMGYry/Z8hfaHLNwFqzEMNFDJCq2Xunj6FYUYgJNj+0=;
        b=e9RThp0ntKvXyASjXNZFdz3qrQ7AO0fwYuPBenwB+0Gd6WSX6m60LsOBMRSfdqX11m
         JYjk2Asc7nA3S8iyncS8aAliHrL1BTFftenXZPtE8Cxwb7kvsJ8TvhRJRaE5TKalV3Nl
         F8Ui+vPFizIwxqqpZHa6o5H4opTPixeeS6wERsPD1r5hcDaD3RGGLYYUWkdl+4Tcnv8v
         afPtZn7lfkSaEK+bDsYnzT7RmT7Xc/0Q1FVMm9GtBDsvCBioRW/qtTWzmvuVg7pillPR
         P61NUMSiGcOSLs4lw6/cOxSCBX5NKo/QgNddE7I13d4j88SlsgdHhz/sHhvPkYIOwa0x
         SeNw==
X-Gm-Message-State: AOAM53282YCpAy/zHv2n7WEXu4STg5YtuOSyHWb1qkaTB3F+ZWNmWnH4
        MtIQSj+u82WomOUZ1nqRbWpIC/S/mqPp19j8vQg=
X-Google-Smtp-Source: ABdhPJyLlNDf98akU5Ea6s+MjZUGx+u0srWk5gfyZFnNJ7T5mkEmmBpNM58VBndMVm6rbUeZgvMVBKSGZmwgwd5RlR4=
X-Received: by 2002:a05:6102:3f45:: with SMTP id l5mr5674926vsv.2.1643806731634;
 Wed, 02 Feb 2022 04:58:51 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:8fc5:0:b0:282:56bb:311c with HTTP; Wed, 2 Feb 2022
 04:58:51 -0800 (PST)
Reply-To: orlandomoris56@gmail.com
From:   orlando moris <barristermusa32@gmail.com>
Date:   Wed, 2 Feb 2022 12:58:51 +0000
Message-ID: <CA+gLmc_1LVsg2v10DE8XZVpOzdJN4Q1zvUdE+PQ-ZG-DiRR0vQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGFiZGllbiEgSW5mb3JtxJNqYW0sIGthIMWhaXMgZS1wYXN0cywga2FzIHRpa2Egbm9zxat0xKt0
cyB1eiBqxatzdQ0KcGFzdGthc3TEq3RpLCBuYXYga8S8xatkYSwgYmV0IGJpamEgxKtwYcWhaSBh
ZHJlc8STdHMganVtcyBhcHN2xJNyxaFhbmFpLiBNYW4NCmlyIHBpZWTEgXbEgWp1bXMgKDfCoDUw
MMKgMDAwwqAwMMKgQVNWwqBkb2zEgXJ1KSwga28gYXRzdMSBamlzIG1hbnMgbmVsYWnEt2lzDQpr
bGllbnRzIGluxb5lbmllcmlzIEthcmxvc3MsIGt1cmFtIGlyIHTEgWRzIHBhdHMgdsSBcmRzIGvE
gSBqdW1zLCBrdXLFoQ0Kc3RyxIFkxIFqYSB1biBkesSrdm9qYSDFoWVpdCwgTG9tZSBUb2dvLiBN
YW5zIG5lbGFpxLdpcyBrbGllbnRzIHVuIMSjaW1lbmUNCnRpa2EgaWVzYWlzdMSrdGkgYXV0b2F2
xIFyaWrEgSwga2FzIHBhxYbEk21hIHZpxYZ1IGR6xKt2xKtiYXMgLiBFcyBzYXppbm9zIGFyDQpq
dW1zIGvEgSBtaXJ1xaHEgSB0dXbEgWtvIHJhZGluaWVrdSwgbGFpIGrFq3MgdmFyxJN0dSBzYcWG
ZW10IGzEq2R6ZWvEvHVzIHDEk2MNCnByYXPEq2LEgW0uIFDEk2MgasWrc3UgxIF0csSBcyBhdGJp
bGRlcyBlcyBqxatzIGluZm9ybcSTxaF1IHBhciBkYXJixKtiYXMNCnZlaWRpZW0NCsWhxKtzIGRl
csSrYmFzIGl6cGlsZGUuLCBzYXppbmlldGllcyBhciBtYW5pIHBhIMWhaWVtIGUtcGFzdGllbQ0K
KG9ybGFuZG9tb3JpczU2QGdtYWlsLmNvbSkNCg==
