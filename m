Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA86C516F06
	for <lists+netdev@lfdr.de>; Mon,  2 May 2022 13:44:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350021AbiEBLry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 May 2022 07:47:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384774AbiEBLru (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 May 2022 07:47:50 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5545F13F3C
        for <netdev@vger.kernel.org>; Mon,  2 May 2022 04:44:13 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id y19so18057794ljd.4
        for <netdev@vger.kernel.org>; Mon, 02 May 2022 04:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=GtUp2jvrmzgIIuFeblwZSobN1uKFpKTzeLwmlxFH3WKX+cUnasGeviKxD0enaUjeZZ
         Z6Jh+C7CYK6xFF282yTMCWOWi3N9CUTiC61tmRBKGi3UwottbK/FOSiPkWhBsyoB6hcB
         0AIkmyLfSzWf6N/xRnPfyyTX/E9ugMK1PBo9y5cjUMB0HagZEA9eIv/n3fmhpR+GHHH6
         HD+TzHsdo3/IqMAg2PN6oVMc2sNOO7UyjLiW4m1TE1/utuiCSqz3rDXX5SgcF2BsI+A9
         24Oi0v50FG/Z3Yog5VfPDUGXHxqV3a+ym4dtjnObOuibguvEcTVZvsaLpvpjCrPBE1yd
         mAig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pSKuz9BJS/Qwel4yBJUKsJP++c1z8gtIosTtEbMtN5I=;
        b=SOE+Pl6uhegNcDNxanGuPdaGeQozNWr+7+g25WOrFVhf6RfLB2NGc+iHeXz218VeP9
         k9nohY673MY/dTuyOJgUmv289iu61IoRSe8SQfjOtlmCLCXOdRzr/6Ut2Kj28m+HUX6y
         5gBmx4l7uWxaqE0wEk/iCTXvj2xMrakWbm/oaMgYbGD7JnKYRux6BgyXmPeoUfbhG+Ky
         Q2BU0hANb8YZqNE/uXZBMOUb9I6qqwh3N1JvtWHSR8hiNmWPCEwqkOGqKcWMKRlgJIX7
         OdPSTYHqvlYvWHuTNUBnIC7ZhbV2fpu6+XkBq4h5sAtdIRIgQsi4SEFmtlBQ8K+RtiS6
         A/ug==
X-Gm-Message-State: AOAM5306CsxctMcGsnvodweb1noYKRSsrH8qfKK6d5wyNuQF5rEuiQz4
        LqDltMTVaB63o24JDSdn7jFuGMQlL7lRtN7/C8c=
X-Google-Smtp-Source: ABdhPJxqpsYpGDmJRPDY+XOYhUmeJTC6TqGjdVS9WRCwKBqf3RlBPWmoQ90Bv8gEQaVojSg497UwXwP8IOWAOCkOqXQ=
X-Received: by 2002:a2e:8e31:0:b0:24f:632:fa9 with SMTP id r17-20020a2e8e31000000b0024f06320fa9mr7711806ljk.185.1651491850646;
 Mon, 02 May 2022 04:44:10 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:1c5:b0:1be:ec4c:5d95 with HTTP; Mon, 2 May 2022
 04:44:10 -0700 (PDT)
Reply-To: davidnelson7702626@gmail.com
From:   Alio Baare <aliobaare1990@gmail.com>
Date:   Mon, 2 May 2022 11:44:10 +0000
Message-ID: <CAEqq5Svr8bvycmhmECzKQGpOvDBVnU29zxH-GDhGVwt_nDGcPw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5057]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [aliobaare1990[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [aliobaare1990[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [davidnelson7702626[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend, I want to send money to you to enable me invest in your
country get back to me if you are interested.
