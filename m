Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 933BD5B5251
	for <lists+netdev@lfdr.de>; Mon, 12 Sep 2022 02:53:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229555AbiILAxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Sep 2022 20:53:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbiILAw7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 11 Sep 2022 20:52:59 -0400
Received: from bat.birch.relay.mailchannels.net (bat.birch.relay.mailchannels.net [23.83.209.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290F827CE2
        for <netdev@vger.kernel.org>; Sun, 11 Sep 2022 17:52:58 -0700 (PDT)
X-Sender-Id: techassets|x-authuser|leesusan2@ingodihop.com
Received: from relay.mailchannels.net (localhost [127.0.0.1])
        by relay.mailchannels.net (Postfix) with ESMTP id 8412E8C0A10;
        Mon, 12 Sep 2022 00:52:57 +0000 (UTC)
Received: from vmcp128.myhostcenter.com (unknown [127.0.0.6])
        (Authenticated sender: techassets)
        by relay.mailchannels.net (Postfix) with ESMTPA id 39E988C08B2;
        Mon, 12 Sep 2022 00:52:48 +0000 (UTC)
ARC-Seal: i=1; s=arc-2022; d=mailchannels.net; t=1662943976; a=rsa-sha256;
        cv=none;
        b=abJuqCi2kMEj1MHWLfRedl7NBsTPE3EMoyOh7wBCCQ1HADe3oejxg5Oz9XwNf9TT+nv0O1
        AN23NwKab8XQON4nmIPSZW2IESVs/uLvEyGw1RkxWOWty9R73E5hs8UjLocNqHN8j7kvWK
        vPsNY5YSCUKkz0lPdP4trTiQCYgrqfUr+YhXkJrZs4f2c76n0Ha3CuhFmeojefW3cX6Lek
        NI9pJMUhpZTSGNgoD+zQ34ac4g83RYFEVgF95GwOxvNNzRcLbByDyw9ELqxDf5HejvQXeZ
        ML5N61PVOj4DfdZslG09VVb449S37MvwDtdX6xu0grsDAtZ0whadmjf/r0oquw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
 d=mailchannels.net;
        s=arc-2022; t=1662943976;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=hXLnhYIY6RPq2jPDah+snLlNw2/6UxQIEbgnwiMYIN0=;
        b=TYp4h3M04nhq3poCpYW+qAcxVdun4SmfhynPoGoZ0KwAi6Zh0UOpCRteKbJsW6UCpJuaUU
        /TPLGy9ZqPVCEENUM6FLAfauc44H8cNiAFgcIvsynG3r0zbr5pNj9MiWa2oFQLazsKdk5T
        lwU9h+7PHldM1QNvreOxHcrcS1Y8U4kQ9YCTTRvFHEAlCwxFOqO9ob39oSBeFCyS0Td7fQ
        qjcp0XbM0Sg3mYVztVSZC9D0ZqZ/nVMybxzci4z/2I1gtZk6h/fxSr83rUMtw18PGy6tfb
        ZU2C4HUogHSFU2LKRizxLOFyy4UOMlh7wBZjF8UuB3RxXr9k6VqfJhwCfmbPnw==
ARC-Authentication-Results: i=1;
        rspamd-f776c45b8-w4rds;
        auth=pass smtp.auth=techassets smtp.mailfrom=leesusan2@ingodihop.com
X-Sender-Id: techassets|x-authuser|leesusan2@ingodihop.com
X-MC-Relay: Junk
X-MailChannels-SenderId: techassets|x-authuser|leesusan2@ingodihop.com
X-MailChannels-Auth-Id: techassets
X-Shelf-Illustrious: 3aeae3710ca1478d_1662943976926_232925731
X-MC-Loop-Signature: 1662943976926:625991998
X-MC-Ingress-Time: 1662943976926
Received: from vmcp128.myhostcenter.com (vmcp128.myhostcenter.com
 [66.84.29.18])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384)
        by 100.119.76.153 (trex/6.7.1);
        Mon, 12 Sep 2022 00:52:56 +0000
Received: from [::1] (port=42638 helo=vmcp128.myhostcenter.com)
        by vmcp128.myhostcenter.com with esmtpa (Exim 4.95)
        (envelope-from <leesusan2@ingodihop.com>)
        id 1oXXgg-00Ap3H-TP;
        Sun, 11 Sep 2022 20:52:34 -0400
MIME-Version: 1.0
Date:   Sun, 11 Sep 2022 20:52:20 -0400
From:   "Mrs. Susan Lee Yu-Chen " <leesusan2@ingodihop.com>
To:     undisclosed-recipients:;
Subject: Mrs. Susan Lee Yu-Chen
Reply-To: mrs.susanlee22@gmail.com
Mail-Reply-To: mrs.susanlee22@gmail.com
User-Agent: Roundcube Webmail/1.5.2
Message-ID: <387269c4834afff3caaa853ac4ff63a6@ingodihop.com>
X-Sender: leesusan2@ingodihop.com
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
X-AuthUser: leesusan2@ingodihop.com
X-Originating-IP: ::1
X-Spam-Status: Yes, score=6.9 required=5.0 tests=BAYES_50,
        FREEMAIL_FORGED_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,HK_NAME_MR_MRS,
        ODD_FREEM_REPTO,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        T_SCC_BODY_TEXT_LINE,T_SPF_PERMERROR autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [23.83.209.13 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [23.83.209.13 listed in wl.mailspike.net]
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
