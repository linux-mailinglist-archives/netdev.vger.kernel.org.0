Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2EEC6EF910
	for <lists+netdev@lfdr.de>; Wed, 26 Apr 2023 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234641AbjDZRNm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 13:13:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233954AbjDZRNl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 13:13:41 -0400
Received: from out203-205-221-235.mail.qq.com (out203-205-221-235.mail.qq.com [203.205.221.235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BEF194;
        Wed, 26 Apr 2023 10:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1682528918;
        bh=o4udH8OtqEoEDrOP/aTcDA81yzBb2ltJxkP46cbFh5c=;
        h=From:To:Cc:Subject:Date;
        b=juYhBBtayxtuIEglDGpYtnMn1Yo2+GoJLV+2HWEXQvlNFlG1rVAudJ2AwTCs8RsQr
         /CSTwa/e828C7Nfh7R+WkSLHD9hxmtx0FxMf1rM/ci9K5rKh85P207+PvjkTDFvKnq
         8GqUzAm/xOZzXdx4dDmo/mnZbXSFbYfcw7BQzmco=
Received: from localhost.localdomain ([220.243.191.11])
        by newxmesmtplogicsvrsza10-0.qq.com (NewEsmtp) with SMTP
        id 9828290; Thu, 27 Apr 2023 01:02:24 +0800
X-QQ-mid: xmsmtpt1682528544th5jveq67
Message-ID: <tencent_1BB7243C6EDA6B2BB6E2C1563C1614D45009@qq.com>
X-QQ-XMAILINFO: MyIXMys/8kCtWl9GEkWfk7hP4f0VtV8+04aQymT3xHvU/k9TTahy9VKkPLTZh5
         io2CmzhrX4cceDZ4N2WgF/3ovWk18EE0wqMuvpvRwH5obr5nms3Q/5ESB3vwADixLKudkx4p2LuD
         pb9UaO/BlXQO2ikEufIf3a8lg0/v3gHJrTO2jWf0iytxddhI8pKPBtLW5uY/7tYiKcm9R4ntfCR9
         4Cgw+fek5uN+bqMrhoPPHhSNXbkhUNj+PwId7N5M4IVJ+WrPZBla+cxttjEL+QWGbGc/14NnqWol
         EcuPtlw+zLMf2bErM2Z3FSu562Btc9EXwAO8MgmGGG1HYdUhjneGYT0IpXhzZe4UgEzdM8J1RO9l
         2LSb/RYImejWvvayVWY2lwwppzv3lP01v4Izus6klBQAkfoaE4KTT2X38u9JB9LHJdQQ9rE0sLqi
         3vD0UOye0N2SUj30JItjV/IokQ3hQ0LEiyaSR7GD76baekW2SxHERHXfIL7CZmwDty2R3H5HE5qE
         l3WHhBYkY7Hh1VJBDIyZdoVuoYfa/f0dlrOs5evtx48Vzc9yEkFNXQgtS07THzeSZm+xIAcpYD/n
         rUJXRShMObCcgvdmH6KN7JzAjaAm2UaxbA7tEKMB5ILlJWWs0PUZpWLkVAT4B7oo0/eqb6x3xVFb
         f5UlRSh33XlUdp3KG3zEjOVlLkcsh3fQqHaRLCZ1hBX53IB0+N3avaCP9j005HMEt4Nc/VIZHtD5
         a7BmXZpx+UXd52yPmYCAt8o2Pfy7yv3pervDd4KNEs/506byGSaP+TgHEWJX9PxeSVJFZGseD8Uy
         dQnBJnmJ23G3jaeP0Fq1iOY/8ZH6UnewlZW0SR8uCCBmtJzFhkKirHw4JQ6oOqI1rFRh6QR1H2HD
         g12zkHKui5E9nbRK8dA9dqRuLfk1RauAE6SDdFgEEETt7TgIhGOEzCIJOgxa0os/Dd00xwE84oEj
         IPD5C5IXqi11/mddotZhP4h0J+4+QcEQ9ZQz+pS4N4/aBDZI45qA==
From:   Zhang Shurong <zhang_shurong@foxmail.com>
To:     pkshih@realtek.com
Cc:     tony0620emma@gmail.com, kvalo@kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Zhang Shurong <zhang_shurong@foxmail.com>
Subject: [PATCH v3 0/2] wifi: rtw88: error codes fix patches
Date:   Thu, 27 Apr 2023 01:02:19 +0800
X-OQ-MSGID: <cover.1682526135.git.zhang_shurong@foxmail.com>
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

The changes in this version:
- check by if (ret) instead of check by if (ret < 0)

Zhang Shurong (2):
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_copy_from_user
  wifi: rtw88: fix incorrect error codes in rtw_debugfs_set_*

 drivers/net/wireless/realtek/rtw88/debug.c | 59 ++++++++++++++++------
 1 file changed, 43 insertions(+), 16 deletions(-)

-- 
2.40.0


