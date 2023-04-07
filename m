Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73C7E6DB111
	for <lists+netdev@lfdr.de>; Fri,  7 Apr 2023 19:01:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjDGRBz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Apr 2023 13:01:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjDGRBy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Apr 2023 13:01:54 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5B9A6A74
        for <netdev@vger.kernel.org>; Fri,  7 Apr 2023 10:01:53 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n21so9638372ejz.4
        for <netdev@vger.kernel.org>; Fri, 07 Apr 2023 10:01:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680886912; x=1683478912;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GwldnxxVZHZIeHVMt8UZiIsJemyEAuafmPtqrxMMBXQ=;
        b=N1azFjwtd4IHvlO0GFD0S7BWvyhucgQLplTUGhmHH06yG+BBi7dSPh/yHyHurdbJPN
         g2r8N6HjrFjkYXWMiHept6Hjo+15EwjVqcC7O5zQ5npO8ECtsdvX+SYTvV9UeYsTy8bn
         TO9FBkvUrZuusE15Eb41SevQCUu8NaZKhy4A3lhM5Wb9LDPnQTVg5EyKjWacpKQcNyPx
         W89rT/tHDIdGIQuEco0GSwA8/J9qi8OFyrp+KG9sc5FIRGegyjxUtyG0N7It1q/BHTaE
         lObjIlzLiw65itEPIGb2zfxgJ1F/jfNE+GyZuTYDaDwHCuvRfXp0/nKtPJgDEAUAgTrq
         gOBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680886912; x=1683478912;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GwldnxxVZHZIeHVMt8UZiIsJemyEAuafmPtqrxMMBXQ=;
        b=eOA8Zs6pOQbeAiDCXWmcK4qnyRNoW2U7S9ZAPZWka5oRTpV7rJoQoNYMpxQe7RlQIk
         Hgxf4PxEtQMBKk8mbzZLChYO7BDgwApXIT0CN4DxSJoKvkCJSr8W9nBXsiKj9650uQBQ
         KMEIsHb6LGZhL254AiatlRZEh0t5FgRnqVYbGfvfvZoLr4rr1DQlgJqkXbKWSbuJCr8U
         ELC8uLaRgLJ9oZxJBhHasWXZnGDjjgSBKFLzaC4fE0NTpMXZ2ACRlarTUtTTJyIThQ5f
         G0wgWSQ1/JzFkltaXL6hheaMNEziHUn/wvGME9U/OzOSo6uNVRiJ1B/rWIWinEc1776u
         mQ2w==
X-Gm-Message-State: AAQBX9e09av9exa76EoFMnOUwE3HnZq4I3drr7JfAqJns3/V0+u0aSSI
        L/4hkUVj413N2sPD5tcne+cqIQcKexdLZQ5B9NQ=
X-Google-Smtp-Source: AKy350Y3+z4iKFLewWhe0wAKvEwYNd2gvBZS+Rg8I6Rt4/Ikq/g3/C8fdBUmVCjJtwkV31j/isJ5Bsv9/ybpYKvz+Ks=
X-Received: by 2002:a17:907:76b1:b0:93b:b8d4:8d0e with SMTP id
 jw17-20020a17090776b100b0093bb8d48d0emr71524ejc.8.1680886911934; Fri, 07 Apr
 2023 10:01:51 -0700 (PDT)
MIME-Version: 1.0
Sender: richter89111@gmail.com
Received: by 2002:a05:7208:3ce:b0:66:70e3:992f with HTTP; Fri, 7 Apr 2023
 10:01:51 -0700 (PDT)
From:   mrs Annie Hyemin kim <mrsanniehyemink@gmail.com>
Date:   Fri, 7 Apr 2023 17:01:51 +0000
X-Google-Sender-Auth: BuB7_Y580zWON0PjS2NTuM5XxwM
Message-ID: <CAH4owT+HRW25tF685QRDK8kce2pTaY_C4LznNoeo9Q1ey7w=-A@mail.gmail.com>
Subject: salamlar,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

c2FsYW1sYXIsDQoNCkJ1IG3JmWt0dWJ1IHNpesmZIHNpemlubMmZIGV5bmkgc295YWTEsSBkYcWf
xLF5YW4gbcmZcmh1bSBtw7zFn3TJmXJpbWzJmSBiYcSfbMSxDQp5YXrEsXJhbS4gUsmZaG3JmXRs
aWsgbcO8xZ90yZlyaW0gYXZ0b21vYmlsIHHJmXphc8SxbmRhIGTDvG55YXPEsW7EsSBkyZl5acWf
aWIsDQpxb2h1bWxhcsSxIGlsyZkgaGXDpyBiaXIgxLByYWTJmWTJmW4gyZlsIMOnyZlrbcmZZGl5
aSDDvMOnw7xuIMmZbGFxyZkgc2F4bGF5YQ0KYmlsbWlyyZltIHbJmSBvLCBracOnaWsgdcWfYXEg
aWvJmW4gw7Zsa8mZbcmZIGfJmWxtacWfZGkuIE3JmW4gYnVudSBldG3JmWsNCm3JmWNidXJpeXnJ
mXRpbmTJmXnJmW0sIMOnw7xua2kgYmFua8SxbiBtw7zFn3TJmXJpbWluIHbJmXNhaXRsyZlyaW5p
IHTJmWzJmWINCm9sdW5tYW3EscWfIG1pcmFzIGtpbWkgYmFuayB4yZl6aW7JmXNpbsmZIGvDtsOn
w7xybcmZc2luaSBpc3TJmW3JmXpkaW0gdsmZIGPJmWxiDQpvbHVuYW4gbcmZYmzJmcSfIDYsOCBt
aWx5b24gZG9sbGFyIHbJmSB0yZlobMO8a8mZc2l6IHNheGxhbm1hc8SxIMO8w6fDvG4gYmFua8Sx
bg0KdMmZaGzDvGvJmXNpemxpayDFn8O2YsmZc2luyZkgcW95dWxtdcWfIDI1MCBraWxvcXJhbSBx
xLF6xLFsZMSxci4gTywgaGXDpyBiaXINCnFleWRpeXlhdGRhbiBrZcOnbWnFnyBxb2h1bXUgb2xt
YWRhbiDDtmxkw7wgdsmZIGJlbMmZbGlrbMmZLCBmb25kbGFyIGluZGkNCmHDp8SxcSBiZW5lZmlz
aWFyIG1hbmRhdMSxbmEgbWFsaWtkaXIuIFhvxZ9iyZl4dGxpa2TJmW4sIGjJmXIgaWtpbml6aW4g
c295YWTEsQ0KZXluaWRpciwgb25hIGfDtnLJmSBkyZkgc2l6aSBvbnVuIHLJmXNtaSBxb2h1bXUg
ZXRtyZlrIMOnb3ggYXNhbiBvbGFjYXEuDQrGj2fJmXIgbWFyYXFsYW7EsXJzxLFuxLF6c2EsIG3J
mW7JmSBiaWxkaXJpbiBraSwgc2l6yZkgbsmZIGVkyZljyZl5aW1peiBiYXLJmWTJmQ0KyZl0cmFm
bMSxIG3JmWx1bWF0IHZlcmltLg0KSMO2cm3JmXRsyZksDQpYYW7EsW0gQW5uaWUgSHllbWluIEtp
bQ0K
