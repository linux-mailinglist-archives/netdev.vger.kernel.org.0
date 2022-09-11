Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2E075B4DA1
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229976AbiIKKwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 06:52:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbiIKKwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 06:52:51 -0400
Received: from burlywood.elm.relay.mailchannels.net (burlywood.elm.relay.mailchannels.net [23.83.212.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F9522B25E
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 03:52:49 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|leesusan7@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 774167E155B;
        Sun, 11 Sep 2022 10:52:48 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id 0E5C77E0B93;
        Sun, 11 Sep 2022 10:52:37 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1662893568; a=rsa-sha256;
        cv=none;
        b=N7rVPi6YPsbQqoBnGnECTsfch2uwkvEthbqbXfv5tLDY4yNBbAtWjL3vWNPDxK6/AcAW4K
        on8ZyrfANwqarBjyyyIrnUHgXMYOfnolBAeMYesLNDg9WBWq14F31Piw9X3AmDjDvJxr3K
        cFX6vdT9l/qnRcpYbx4m2Ci3C35mOusKgg+1crMpmM8W0CkpL+e5lCKm259fUTbobiW8SV
        vMm8Cxq06xvfmeHlvbAVXNag5TqsSTiP1fwdTGIeae5YdklhBWp9BdVyuZIJ/7M5e7p7XQ
        2L8oy8atqK2/rtNeNRqHteulqcOrVqqOXsoBGU080FsZ/lAC4pSjJYXJpiPw/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1662893568;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXLnhYIY6RPq2jPDah+snLlNw2/6UxQIEbgnwiMYIN0=;
        b=vCXGb6yPI2Y6W7RoKH4eB1dT9ukXW7vNc8GbDoQB3n+HtdN7d/NzgYNRJb2ALP4oOQSP10
        K9yJrosgwg6cyyQF/xvXRMssMT8udh1DhxS5cZwQYIh5YKAMDjOzqrX23YKPsL8KVQs+4/
        lQWjA7uqAgH+/0MnrVG9AHyssKa6UfQkAmlqfHLnAZSiY7aHA4oSAoqS6mrAGhuwxa+UQ7
        f0CK2F0j4ycWE1WzzxotELEI0KNODHf3POtbvzhVlsg47H6/PW0oKULk7hjo6+EFOC3ENJ
        DSc/v7rhLdaBY8pmMJU3rgwMVbURr9U3HRm6W+nzt6B4oiiNwJ3QTFhIU5bYFA==
ARC-Authentication-Results: i=1;
        rspamd-f776c45b8-j5slt;
        auth=pass smtp.auth=techassets smtp.mailfrom=leesusan7@ingodihop.com
X-Sender-Id: techassets|x-authuser|leesusan7@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|leesusan7@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Broad-Continue: 2e2a91687d711a18_1662893568150_3905575108
X-MC-Loop-Signature: 1662893568150:3169818705
X-MC-Ingress-Time: 1662893568150
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.98.142.80 (trex/6.7.1);
        Sun, 11 Sep 2022 10:52:48 +0000
Received: from [::1] (port=35316 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <leesusan7@ingodihop.com>)
        id 1oXKZb-00A2XL-Nb;
        Sun, 11 Sep 2022 06:52:23 -0400
MIME-Version: 1.0
Date:   Sun, 11 Sep 2022 06:52:06 -0400
From:   "Mrs. Susan Lee Yu-Chen " <leesusan7@ingodihop.com>
To:     undisclosed-recipients:;
Subject: Mrs. Susan Lee Yu-Chen
Reply-To: mrs.susanlee22@gmail.com
Mail-Reply-To: mrs.susanlee22@gmail.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <626d63078761f3303e51a7bbd6f5abf3@ingodihop.com>
X-Sender: leesusan7@ingodihop.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AuthUser: leesusan7@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,T_SCC_BODY_TEXT_LINE,
        T_SPF_PERMERROR autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [mrs.susanlee22[at]gmail.com]
        *  0.0 T_SPF_PERMERROR SPF: test of record failed (permerror)
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.212.26 listed in wl.mailspike.net]
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
