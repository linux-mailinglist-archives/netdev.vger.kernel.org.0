Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA9585B4F60
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 16:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbiIKOJr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 10:09:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230355AbiIKOJp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 10:09:45 -0400
Received: from burlywood.elm.relay.mailchannels.net (burlywood.elm.relay.mailchannels.net [23.83.212.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E52660C4
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 07:09:42 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|leesusan2@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id F0E3E40C47;
        Sun, 11 Sep 2022 14:09:41 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id C65FA4094C;
        Sun, 11 Sep 2022 14:09:32 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1662905381; a=rsa-sha256;
        cv=none;
        b=6lXUWvVzLg8/cAUw22fMApG8P+wsUEFTO0IarvZ5b6cxnoagIlOPD8oeELQLJpmJzBclWY
        O+eNdgRj/1yfDBw060wFdTenxGx9OtmIjVMM2qCEGuVHrbptZGxm+7PzBt1u0ozD62HcW0
        5h/FxZnAHiQVwSryZVffgtBwhnpVgqWBO174OCkLfm+uatN0FvA/t+cdAvtUkMrlwV13I3
        EWN77JXdV1L58mMs3/h9zu1FDEKTK+9HEVZ1wSch6JmVfcjYI+Tm7xM5M2Pa06KADT6Wyo
        MMocV7NHt12X/gf+5j2OLhbKGch8PofJhmiTx3i3wPX0Xm9vIBEQJiCEyGAIEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1662905381;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXLnhYIY6RPq2jPDah+snLlNw2/6UxQIEbgnwiMYIN0=;
        b=fqW1F0wFAx+LJb/to2iEqPsNouLdXryiHWlJjb33ds0bpqOmAAd55vBP1lZtdk9Dk4CWQP
        +DujmWXRxmGSykUALfr0ZGGha1DG4PMLr6qUAHUSr3zpGpbKQvfIxddFDM3qqeWNRO/hBq
        4KloVdciMB+kuYOZWx02pxn89hM/GzbuGh0PPO3JD54CTSHm7tC7JfZMUsNctul70m4mZL
        ipDTo3DsrlKYbCrCBGTBZoymk4F0vXK4hDJ2uzLs6uhQOufK9yNgH07vIqfQ4HnrmNwVy8
        KvNjwV+UCD5U8FfriPQOu32hwK/3JisoseiY15Cbvfy4Q0tNoiXXLYbFfEPjPg==
ARC-Authentication-Results: i=1;
        rspamd-f776c45b8-5zcwj;
        auth=pass smtp.auth=techassets smtp.mailfrom=leesusan2@ingodihop.com
X-Sender-Id: techassets|x-authuser|leesusan2@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|leesusan2@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Befitting-Interest: 68d310d15cf541c2_1662905381545_339474639
X-MC-Loop-Signature: 1662905381545:4255411227
X-MC-Ingress-Time: 1662905381545
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.109.219.78 (trex/6.7.1);
        Sun, 11 Sep 2022 14:09:41 +0000
Received: from [::1] (port=46102 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <leesusan2@ingodihop.com>)
        id 1oXNeC-00AEq9-W6;
        Sun, 11 Sep 2022 10:09:21 -0400
MIME-Version: 1.0
Date:   Sun, 11 Sep 2022 10:09:03 -0400
From:   "Mrs. Susan Lee Yu-Chen " <leesusan2@ingodihop.com>
To:     undisclosed-recipients:;
Subject: Mrs. Susan Lee Yu-Chen
Reply-To: mrs.susanlee22@gmail.com
Mail-Reply-To: mrs.susanlee22@gmail.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <5714d475b55b9399cbef804da8a0ab71@ingodihop.com>
X-Sender: leesusan2@ingodihop.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AuthUser: leesusan2@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.212.26 listed in wl.mailspike.net]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrs.susanlee22[at]gmail.com]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.7 ODD_FREEM_REPTO Has unusual reply-to header
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.0 HK_NAME_MR_MRS No description available.
        *  2.1 FREEMAIL_FORGED_REPLYTO Freemail in Reply-To, but not From
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-- 
Dear Friend,
  It’s just my urgent need for foreign partner that made me to contact 
you via your email. The details will send to you as soon as i heard from 
you.
Mrs. Susan Lee Yu-Chen
