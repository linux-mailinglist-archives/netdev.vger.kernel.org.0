Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AD55BC2F9
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 08:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbiISGky (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 02:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229542AbiISGkx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 02:40:53 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4311B12AB2;
        Sun, 18 Sep 2022 23:40:49 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id t3so27048556ply.2;
        Sun, 18 Sep 2022 23:40:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=YEiig58+qWJEubWjd82ynXIeEWkoiIzc4IECjspcfCg=;
        b=PJzKxym4965jrzC4B0dnGv7xn/MOZ2cXgIeJloIb9w94S75MYRhyWhbuat4fgvnxua
         VpbA0AqKY2avC7FlGhXYb14sLb0eo/j07BTXv1BWLrQu08opYo8Du5Ns6PTtzhiy0PN9
         IvBFfrbS7H0cppd52lMt8Uf/vA/lEdEbkXJCFB4drlYLqNq/TbRsN1JRP27uYY0lk+Yg
         BA5+2LibsiE+eIxHQg9EtHLa8YACIQvWQlgbXI+mZ+z2yUNb8NXysB8km3mGss8E88SP
         b1f9Y9xNg05z/2cQ0VtkH4z7WG1d445u9upQLrcdrmkZaGzATl/LdFI3XVvAB2MasnAQ
         s9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=YEiig58+qWJEubWjd82ynXIeEWkoiIzc4IECjspcfCg=;
        b=iUC45LE0I4K0gqwoz8RhCUTYKvK2guM3wHlkWzLqebSingsyjuDq01FZopA4fAelc8
         KjrMGjc87xLi8o1nJD/AO9hUbYSaaLNAKHtzDhzc6ePNVdM6fXcMvCOZA7PjlRDMeieB
         OVZhhyVUn0OfjME7FxRH784EXFYlmb9JXzMSLBpJA7Lf5Q+6fdKJqVZh+x4S8fIWi24v
         4PXcf04UXr5mvSbIM3Hh2G52r10teBjBrjShY2a73t9whcdSBtE4Hd6nO68YxZCvkxiB
         pbSYS0iOBmqPsHUWbesaWl1iqRA4Yg+yagn4lxocVVFlcyljtbNWax08fBmdv2Qij+07
         wRVw==
X-Gm-Message-State: ACrzQf3quKzQG8bW0Lzb5e2D/Jslj+gqZ2xqRjtcDewDjTghymD29NiC
        moyfQsSksh6b2UwwinJlh4Q=
X-Google-Smtp-Source: AMsMyM4xOluHv8N5YynajFl4Vh6uwgnHfZOjzurCnlM59n7wOQ1g6UXa/AWvgcpEbKThYPq4sxrKXw==
X-Received: by 2002:a17:90a:5993:b0:202:be54:1689 with SMTP id l19-20020a17090a599300b00202be541689mr28227724pji.207.1663569648735;
        Sun, 18 Sep 2022 23:40:48 -0700 (PDT)
Received: from MacBook.stealien.com ([110.11.251.111])
        by smtp.gmail.com with ESMTPSA id z6-20020aa79906000000b0054c33d37c9fsm4582086pff.135.2022.09.18.23.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Sep 2022 23:40:48 -0700 (PDT)
From:   Ruffalo Lavoisier <ruffalolavoisier@gmail.com>
X-Google-Original-From: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
To:     Gregory Greenman <gregory.greenman@intel.com>,
        Kalle Valo <kvalo@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/3] iwlwifi: phy-ctxt: delete repeated words
Date:   Mon, 19 Sep 2022 15:40:42 +0900
Message-Id: <20220919064042.17865-1-RuffaloLavoisier@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- Delete the repeated word 'the' in the comment.

Signed-off-by: Ruffalo Lavoisier <RuffaloLavoisier@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
index a3cefbc43e80..abf8585bf3bd 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/phy-ctxt.c
@@ -29,7 +29,7 @@ u8 iwl_mvm_get_channel_width(struct cfg80211_chan_def *chandef)
 
 /*
  * Maps the driver specific control channel position (relative to the center
- * freq) definitions to the the fw values
+ * freq) definitions to the fw values
  */
 u8 iwl_mvm_get_ctrl_pos(struct cfg80211_chan_def *chandef)
 {
-- 
2.34.1

