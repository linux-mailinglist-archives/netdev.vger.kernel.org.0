Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE664B5B53
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 21:52:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229589AbiBNUtf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 15:49:35 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:34300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229475AbiBNUtf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 15:49:35 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6714DD0B74
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:49:13 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id g39so9791141lfv.10
        for <netdev@vger.kernel.org>; Mon, 14 Feb 2022 12:49:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=r7AN756k7xEJGk9FE0hMbuIgBNhtzTSAlEJZ5JaHWnE=;
        b=F0VAvIAHJ4OqXi+Gq+GT/GXn2ENCAy1exxYfHl3f2pLcvyu5d2Kk5rMv63NVs22YGL
         DMl5xugT0RHQyw569nl/MqDTKYu/HfTxwkX1zB1/+OZ4qtZQ/8tRV/Vlb0OstWjZ6rAE
         CTi5VjSpOkfduiL74uYdkiTLHBNbQi64lHnpfHF+Amj06I8Qh0Ci8TOGGPSWnDDp7aRE
         a85ZI0LQX8SF2VznfknRnw6vTqt+WMPCytCIV5SDE+I5mQQCGead5Vrh6WkVO5zrwWpO
         70qc1EWy3cG53SiGwjdC8dnlCbTHAdM6U4sr7guD2PLKDP6t7m+NJ/0LOasr2vMWJiJ0
         4MoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=r7AN756k7xEJGk9FE0hMbuIgBNhtzTSAlEJZ5JaHWnE=;
        b=3JRFhr26MACqmFuSS1+9yCJ4jAmXcPnS2BzhHJIxQEsh3FIWbJIOhnyq2rOxfQyL/8
         imuhXtzDKc9SCbOtwxgrctNPva9LF/3mEliXQ39dw/C5YhgwLDApK6c06aSCgEVYlxDX
         GtcXQEKlbHONpVJrAxTUjNDZAWdaJcNDADYmeShmvSkZXrqBPV4KjPJBLMQiapYx3Vpq
         sINPVXUY6vlh2AD6YvJrX2mbfH607JNGA8EY1AUI3zCMGvar3Q5eLJCE8lENDVAj1tPH
         tzrEDq9T4RICNLG0qlGkeaM1rmTFMJbuA4mtE2fQQT0xLXjlM98meCQFz0F4vkRYbQyL
         yFwQ==
X-Gm-Message-State: AOAM530pbDKlFOWP1UeOW43l8HOoUvSvFIjSxbCJVCngk6BVZtdJ7JBm
        Kcu2BN4s5B4fBrBHGDgcRyMGVOqPSXEedF2Uoac=
X-Google-Smtp-Source: ABdhPJxL6VJs6rJB2BQ2YM9wKh3lbBxqKfhbRYdKZvsLSRpZ2Vz40CbOl3BQvQxAjyzRbKtIlNR3Dirvh6TK6pWkRds=
X-Received: by 2002:ac2:43ad:: with SMTP id t13mr647196lfl.8.1644871604267;
 Mon, 14 Feb 2022 12:46:44 -0800 (PST)
MIME-Version: 1.0
Reply-To: issayacouba2021@gmail.com
Sender: patrick.mark774@gmail.com
Received: by 2002:a05:6504:3093:0:0:0:0 with HTTP; Mon, 14 Feb 2022 12:46:43
 -0800 (PST)
From:   issa <issayacouba2021@gmail.com>
Date:   Mon, 14 Feb 2022 21:46:43 +0100
X-Google-Sender-Auth: KmOhxFSVuCxz6eZ1kKLLTBCFQVc
Message-ID: <CANuyTUVn8bT-yopQe0K9G+nCyet2LiMkopd=DK8iW9CvWystFA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.5 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,HK_SCAM,LOTS_OF_MONEY,
        MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Old Friend
I'm happy to inform you about my success in getting those funds
transferred under the co-operation of a new partner from Paraguay.
Presently I'm in Paraguay for investment projects with my own share of
the total sum. Meanwhile, I didn't forget your past efforts and
attempts to assist me in transferring those funds despite that you
failed to assist me financially.

Now contacts my secretary his name is Mr. Issa Yacouba; and ask him to
send you the
total sum of $2, 000,000.00 U.S.D. which I kept for your compensation
for all the past efforts and attempts to assist me in this matter.

With best regard
MR.RONNY ARMAND
