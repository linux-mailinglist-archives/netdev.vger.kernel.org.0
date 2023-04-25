Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D6CC6EE5A8
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 18:24:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234497AbjDYQYY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Apr 2023 12:24:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234206AbjDYQYX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Apr 2023 12:24:23 -0400
Received: from out203-205-251-80.mail.qq.com (out203-205-251-80.mail.qq.com [203.205.251.80])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453D72685;
        Tue, 25 Apr 2023 09:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682439859;
        bh=XsL2Dclsx7DmTif8VKS1YjgcCrNjSmCJtxns4l8Om7Q=;
        h=From:To:Cc:Subject:Date;
        b=nTxz4Rdlb41QXFSdSMUKflWBGacUPSL0d9SK7Pmncjh5aq2HCIJjdW1zl69RgdOFH
         x9HqB+MTXKVQGZylLKZLxdk0qdl++vylh9NJeCxOOyY7zQuyuYjTvswTd1dhFNgaxc
         XEkOd3WBGbzBQ/t8hPbWBuE/d4hE8xcMn0i99spQ=
Received: from localhost.localdomain ([116.132.239.134])
        by newxmesmtplogicsvrsza12-0.qq.com (NewEsmtp) with SMTP
        id 60F0C276; Wed, 26 Apr 2023 00:24:15 +0800
X-QQ-mid: xmsmtpt1682439855taox1nrsy
Message-ID: <tencent_380A90A80212A8379CB5325B2A60731E8008@qq.com>
X-QQ-XMAILINFO: Nfm/+M6ONQ57a8QjiSl3OhPbt7+vlVTmjvAwMPDrCpRXv75rf6m3lo91FTE83W
         5386ppjKpium8du9LtjC6L1zyj8CIflSdKW/dn4pneNPiY0cz1ieolhr5NrKCx3I5AQXMOsoEtEU
         RWAlFm+6KRYQgqSFxR6R162VY5KG19CGKGNFcDePc0t8BoNZOnDzXLs+Shz7YTWy9Kk1mNdNwgjm
         kVIP/PDbG/c0gbh8MOrnIIs3zv6/0fWf7kgtWIJMU2AIb1TkbgvyWAoNVgkwpl2UmnvMlujqQCFN
         0jPfO5cBoXEb4llNECcqjiIUaZVEY63oWRGxRMER04aD4vQoGPyM9oAlgPft+6hWf7rOjP2+2sKQ
         TLflhKOpOB59x+wP0/xJESpNkHcBiXy9hWJMbkGosrc32vKc1ytW79/5Wrd4ZaSr7+1c+MK3Axuv
         eL5arzUIYAPrFynTMbVQOPKqO7GE2TsX3yOtEjfMvGxIj6cI6mAWUzORe0JRggGXcJ8LhVCs4kX7
         6j/62OrC0U3Df0hpoMWdPapmJv5f8c33uc92r/MGi6RK93h+KECoo6JX5Oi6J8MqqhCNGeArxh5L
         wO7jVemq2yfmCbUTY81ehx7qTZfLBhemPSxnbWwytGY+iWUMz6jDNXfViDxB6rxEbvX37iB5nrnH
         nmbdLF7KAZwdwWnLm96rrupXzlmpNKjsaP/7JTU5H8X/wg4w/9p4X0/UweI7+Mrp5HeMLS9IzLHM
         fBmic26KH+blz+y80LjDxf5IvloRh2d2N7xFB4C/yOYjq1GrZ5EOyYyuBlJgknHidDm6CwgY6sgl
         uQ39R6cria7kWo4kO8QSLK7ILBqVxKD/A7s77W2y01FUQAO+Bk8Tt+tlxbspqSwNa17jXZCNwWWH
         bKwf1MsjPOzZTs8qeB69XLmdTD5Rlha9fph1XCQgWizDZ3TLJ3oy7yolZsFg8QnGqJKUmu19WoR3
         5wCKrOs/KMmvrrhp5yGYLaqXvUl5FouHtp6OLHHko=
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     tony0620emma@gmail.com
Cc:     kvalo@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v2 0/2] wifi: rtw88: error codes fix patches
Date:   Wed, 26 Apr 2023 00:24:10 +0800
X-OQ-MSGID: <cover.1682438257.git.zhang_shurong@foxmail.com>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        HELO_DYNAMIC_IPADDR,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,RDNS_DYNAMIC,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no
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

The changes in this version:
- Fix rtw_debugfs_copy_from_user error code in first patch
- Squash other patches to second patch

Zhang Shurong (2):
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*

 drivers/net/wireless/realtek/rtw88/debug.c | 59 ++++++++++++++++------
 1 file changed, 43 insertions(+), 16 deletions(-)

-- 
2.40.0

