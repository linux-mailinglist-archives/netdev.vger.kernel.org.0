Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A79D052AC1A
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 21:41:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352811AbiEQTk5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 15:40:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352795AbiEQTkv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 15:40:51 -0400
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1C7D62EE;
        Tue, 17 May 2022 12:40:49 -0700 (PDT)
Received: by mail-ed1-x531.google.com with SMTP id i40so218438eda.7;
        Tue, 17 May 2022 12:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H5g0Q7JY1CBp8W0/BbPeaYjO4nW8MBaGkU9+wWCykbk=;
        b=MpHbxZ+UYiSFoH3gyZ+Lgk+fOM5r+pi1qgMxgjZ5Ps0AYbN1nqh4V/9iBpvYOICT+c
         HFWL1+brukfuDVVop/pUWFnD8pCpxkSPhFlhv+E7asllX7wacB1MXqvYYprlpQfpenUk
         YhJW50Pf6ja+Q6fW4dRu6GcDKC8Tpy5lCQhxFx3Cr26gupNnM1fFS9GzH3PW+R8O/AHb
         r7HpS+YYplrhq9FSRRJGpe8vYLRvYFZ2Ak/0pfKivmoUpGwutq5z5hGVpigGfEmZt+b/
         2xk8e8R2hFNTygWGOD50DcPBIUndf/mF055CblSwKrp+h7xrs5lKrPw9YJNEqSQSpN4H
         whuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=H5g0Q7JY1CBp8W0/BbPeaYjO4nW8MBaGkU9+wWCykbk=;
        b=p23vnhBnwGAtlk9wWuB9TGqDTTm7tWbOWrZkHJ2VnV6dzsOXdB3qI2eNpkpPCKkBpl
         tuChCd2OtLVtwxGlrhlMKUF1eLUqOStN68/GAXjuUd19LxGb1KF6QF8tiizukzx8CbfG
         NIv4W8uHoqDG2jae6I9e71HLfP/ps9rkYmCG8L8mYfQ9+Qc/0H+5D78XAkTGVyWrOS1f
         ImnD9cfMAPxTpOYWOvZTUAX48ZRd8qGO5zN/cutfO0Z+P+bnFUIhom1rmackgTcb3omm
         45AcBwWeJWluC5CwO1UtVGie83SgbRBoBda2mD8lSQ6ynTz69BoIMPc1dxILUcI5kZe5
         aiFw==
X-Gm-Message-State: AOAM531c3NHStXDbUUZaqOi4w49y4X4AHPXb7478ZilTPo47an7uo5E8
        K+tUpg4ZRpjfIvRDp0bshqhgG3somg8=
X-Google-Smtp-Source: ABdhPJw3XmugaGMEItfuPjiyFobKLm3o/ku7h0/A3/jh+8eRwDplRla4Je0xOJECrDpvQcB4FpscFQ==
X-Received: by 2002:aa7:cd70:0:b0:426:49a3:9533 with SMTP id ca16-20020aa7cd70000000b0042649a39533mr20826763edb.34.1652816448007;
        Tue, 17 May 2022 12:40:48 -0700 (PDT)
Received: from localhost.localdomain (dynamic-095-118-074-246.95.118.pool.telefonica.de. [95.118.74.246])
        by smtp.googlemail.com with ESMTPSA id 25-20020a17090600d900b006fe0abb00f0sm40669eji.209.2022.05.17.12.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:40:47 -0700 (PDT)
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To:     netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch,
        vivien.didelot@gmail.com, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Subject: [PATCH net v1 0/2] lantiq_gswip: Two small fixes
Date:   Tue, 17 May 2022 21:40:13 +0200
Message-Id: <20220517194015.1081632-1-martin.blumenstingl@googlemail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While updating the Lantiq target in OpenWrt to Linux 5.15 I came across
an FDB related error message. While that still needs to be solved I
found two other small issues on the way.

This series fixes the two minor issues found while revisiting the FDB
code in the lantiq_gswip driver:
- The first patch fixes the start index used in gswip_port_fdb() to
  find the entry with the matching bridge. The updated logic is now
  consistent with the rest of the driver.
- The second patch fixes a typo in a dev_err() message.

Hauke gave his Acked-by off-list to me before I sent the patches.


Martin Blumenstingl (2):
  net: dsa: lantiq_gswip: Fix start index in gswip_port_fdb()
  net: dsa: lantiq_gswip: Fix typo in gswip_port_fdb_dump() error print

 drivers/net/dsa/lantiq_gswip.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

-- 
2.36.1

