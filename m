Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DA625BFC6F
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 12:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiIUKfz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 06:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbiIUKfy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 06:35:54 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 321B4883F0
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 03:35:53 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id lh5so12562020ejb.10
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 03:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=vWTx9waxxwXRcamt4ePCJ74t1njaL9ZrGOeuhdI5nro=;
        b=s3/zWeZf0K6JlcMz68yA4amBwBVAratLAs4TitSGSWrUF7jSEaercPgB435AdKIgST
         sU8Cc96EMdJuaaW/RujVYHjga3Tr8y/70utRZgnSsbQzEop5DUn23X2gDJCY8SBXHfb1
         ungajh15QI0Y7prHu+d6033i8RFixVFx3TmgGZsO43LhbV3MPeT96iQxUOjeVIr/3VD7
         qzFQDhqSNN8OlLHWogZut17ZNQJVSkz70x03KufUaYFQQxgSKZlSvLx9K/HImbSUblo9
         xajMFezGzHdmBMQlx7t5faxa12Fq5yMrTEJ8Ajo7QGcTvLQQtqcI08BvazMyGk7078ET
         ZYTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=vWTx9waxxwXRcamt4ePCJ74t1njaL9ZrGOeuhdI5nro=;
        b=iOIDtzPGBAqXpuHpgfOvdsBREai7g5Csy642PQR4n2ciobuPA1NXFZfKjyPnP9MC7F
         A5SoC1V9k6PNgSk7QVCwLL1vrsgEeV7LeI4D6mx6q3z1A+h5bkpjB3nTpfeKmNR7wdq2
         b6aY8K85h3dfiDRg37DCrZhYYhyMasUaki8do0cx0T0bwQO7r12uMh5niBaopofcmNui
         75BKM8U60wF0Qj2NfCq6vjXHbB2pJYIuTjOqEatoQmEtRxVPXcllDOya9jq9XlbxP6/M
         wCAOfG1SlltUOtMssRtDz90DUBZRVtseVU0XA7xCAtq2ZlCghlLkdKBXJ5EhTPc9bakg
         Pxqw==
X-Gm-Message-State: ACrzQf0GQHCYQgembjC+Dt6vHNb+mejW5qFhpYOaM+Iktgn9tcZLmQ9B
        +uZab8Gi6shfRWI+bbueYYiDU/6GjTqIeyTWYtPEQIYOSc+5mQ==
X-Google-Smtp-Source: AMsMyM6GsnvJLODMjJ0WjzFJpNLKJiNkDrnFRW/CCvYMgJEzL+qkZOkteO9eA3X5swG3BfiW9LgeeqdRo/NsYE3W/2w=
X-Received: by 2002:a17:906:4fce:b0:780:e1d8:eacc with SMTP id
 i14-20020a1709064fce00b00780e1d8eaccmr15423597ejw.366.1663756550698; Wed, 21
 Sep 2022 03:35:50 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 21 Sep 2022 16:05:39 +0530
Message-ID: <CA+G9fYsZ_qypa=jHY_dJ=tqX4515+qrV9n2SWXVDHve826nF7Q@mail.gmail.com>
Subject: drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning:
 'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size 0
To:     Netdev <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Cc:     Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, ath11k@lists.infradead.org,
        regressions@lists.linux.dev, lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Following build warnings noticed while building arm64 on Linux next-20220921

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2238:29: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2238 |                         v = ath11k_peer_assoc_h_he_limit(v,
he_mcs_mask);
      |                             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2238:29: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2251:21: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2251 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2251:21: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2264:21: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2264 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2264:21: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
In function 'ath11k_peer_assoc_h_he',
    inlined from 'ath11k_peer_assoc_prepare' at
drivers/net/wireless/ath/ath11k/mac.c:2662:2:
drivers/net/wireless/ath/ath11k/mac.c:2251:21: warning:
'ath11k_peer_assoc_h_he_limit' reading 16 bytes from a region of size
0 [-Wstringop-overread]
 2251 |                 v = ath11k_peer_assoc_h_he_limit(v, he_mcs_mask);
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
drivers/net/wireless/ath/ath11k/mac.c: In function 'ath11k_peer_assoc_prepare':
drivers/net/wireless/ath/ath11k/mac.c:2251:21: note: referencing
argument 2 of type 'const u16 *' {aka 'const short unsigned int *'}
drivers/net/wireless/ath/ath11k/mac.c:2019:12: note: in a call to
function 'ath11k_peer_assoc_h_he_limit'
 2019 | static u16 ath11k_peer_assoc_h_he_limit(u16 tx_mcs_set,
      |            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~

Build log: https://builds.tuxbuild.com/2F4W7nZHNx3T88RB0gaCZ9hBX6c/

--
Linaro LKFT
https://lkft.linaro.org
