Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 752D36EB88A
	for <lists+netdev@lfdr.de>; Sat, 22 Apr 2023 12:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbjDVKSh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Apr 2023 06:18:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229647AbjDVKS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Apr 2023 06:18:29 -0400
Received: from out203-205-251-73.mail.qq.com (out203-205-251-73.mail.qq.com [203.205.251.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B059BE70;
        Sat, 22 Apr 2023 03:18:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682158704;
        bh=30ajWGT6EQwG+HW7jNut3RYhnHFyXwCaTLvUmzUJsGk=;
        h=From:To:Cc:Subject:Date;
        b=HrrzVXi6OAXe70Vh24PSazGiyR0WclImLjijH9PZziqs5Wel2VZgqIK0HkEJqNCvS
         /VaGJ/eq1d0N5klT22PIRNhSeTJ1P29DZo6xn03e9O7QBfm5U4HOX+fjKArCHNa8Qi
         yqXGVD+xPLjLG7M30RoBUiyIKtWlK1+RXNxv7JMo=
Received: from localhost.localdomain ([49.7.199.72])
        by newxmesmtplogicsvrszb6-0.qq.com (NewEsmtp) with SMTP
        id 1402C0F4; Sat, 22 Apr 2023 18:05:00 +0800
X-QQ-mid: xmsmtpt1682157900tjkyvxgyk
Message-ID: <tencent_5C4AD0DC30D7D66CFD81A978542894A1C60A@qq.com>
X-QQ-XMAILINFO: OKKHiI6c9SH3yACehlrLtIHCpI8YR1YhG36+kjrU0hpA9/Y74DW+NqFxhsW1jZ
         GYHeU9FRlEpho3TxjRxkIFmddLInydXDkhrgphMccJ/qagdfgQDURUrO8wQQ1PJ2a9qhHkuiRI6x
         g/659zAoyyoJDjrGId/CeQAKCALtXiqSlG+GRnfPEa4c4cbBLzyTCst754HfWA5WnoSBdtCbbUfL
         6YSbsZcVBr4vGL1JOC3sPRtrh5bt5F/9y+LI42VP4hbAtv3jpLjJWhZtF++qv3ARWWFOeTQaCx5V
         dc0mpILkBjxboRjgLgu8l0MV81Retc7SXaqmGdOiywYakliGcBrF0WIOv2y+IKMlGdFewtexyT4D
         gV0wlkgsmUlFSVtPITXyGHpBu9HTbBOpGoNq+7UK/0BTfnW/LxOtw5SlbhKgorHMWp5wIJbIrmgM
         ISg5cP3jhBe3ouAaB1RLMqyFRWVE2zZx4FAL+LKkCaplbZoSQSViK0Ei305oWS0FqflBQs5Q5jdO
         IEwLwuKs1QVfySE/pt9kKj0XsftiFdpCNNIhhOHKg89hmRkzOnDUqYiBeMTrKgRXwfftdkfj78qI
         BayAy1R/CwQI1VCokfppnIOSwjQ/sUOzNSOCYqmZVsFg0K2nCwBDZnNnIS/uo9OwXPkd9SYkdE20
         sUNM7TB3u0JdK+oCaF18Wmz3sDHrRUCs6xLhZoxGYkRS5VeVCxI9zY3ld+HnFI1YGFWaKVWFYYCJ
         zDXiI7O7mHsYiJD8PSDH/QicmH7opRv4O+j1YND074bgkVJwxOxwf1enTU8G/NZDKVPNmMxFHvzF
         /iaaP8UGSkuP7iMabs4jBBmBJWM7LUya6g+J+g0/rPLINJdz6Z2HQPgc/GOPGz4zeqjAka60Rql6
         cTox0mZz+ZfL29ZAC21KSyjGOeCaYwQVHGERRtS/m3y+LcQcCbMOepiohiVxDdkQrl3NtwRImeXp
         txTp2/mnHmWZ/WEJ+3VK2LjZFFCoot
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH 00/10] wifi: rtw88: error codes fix patches
Date:   Sat, 22 Apr 2023 18:04:44 +0800
X-OQ-MSGID: <cover.1682156784.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

rtw88 does not handle the failure during copy_from_user or invalid
user-provided data. We fix such problems by first modifying the return
value of customized function rtw_debugfs_copy_from_user. Then for all 
the callers rtw_debugfs_set_*, we receive the returned error code. 
Moreover, negative code is returned if the user-provided data is invalid
instead of a positive value count.

Zhang Shurong (10):
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_write_reg
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_read_reg
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rsvd_page
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_single_input
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_h2c
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rf_write
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_rf_read
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_fix_rate
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_coex_enable
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_fw_crash

 drivers/net/wireless/realtek/rtw88/debug.c | 59 ++++++++++++++++------
 1 file changed, 43 insertions(+), 16 deletions(-)

-- 
2.40.0

