Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7ED1696E02
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 20:37:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232547AbjBNTh2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 14:37:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbjBNTh1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 14:37:27 -0500
Received: from mail-il1-f228.google.com (mail-il1-f228.google.com [209.85.166.228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 061C32CFE6
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:37:26 -0800 (PST)
Received: by mail-il1-f228.google.com with SMTP id i26so310967ila.11
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 11:37:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:subject:from:reply-to
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SHNedO5KuH+p/e/vc8sOVGTErzEaxPyT/hyhGtc45Ag=;
        b=rHYNhilAaBMLxrlyTnR21wZw9Dqby5zXK5TQbin0NFB4xsdXNm+OctFWOX+CXbsIek
         bvjTHEUv8dGrNUHnIcVEgXsghQ5xayFF7Z0WKwK+Dyz/16ooFGhrBkh8g/r2aAtCtg6G
         1H9UAwruSqLu7t162/zhxRPbemDkjV7PtunqFpeAHVBXkYCj1wPO2Lbto9AaHNpwzNB3
         uLAVb1ctEANbtzwq6WiiaHNWwOLcbPdfHp3pm3PdTmnkFZb5lofoC/m5UIZpJ8cmHoJ3
         G5SIldhd7qH6VWLOc2hcIVN2KZqccYxFf9CzsUlT7qVHyhXKd+mK8d47gFMUXOkbOqai
         RmfQ==
X-Gm-Message-State: AO0yUKWif0QdGEv44Tg/ZaM/8Z4o76+ectz48iE7c8bLkZC4qMWpE/Da
        lIt3+tRmTn+pf6jaaSYFd9zSNN9VRreepNUX3iGUb0R6ABx+Gw==
X-Google-Smtp-Source: AK7set9ikVV9jJ0dyJY4hOIez0NXsS6xdbPrlWalieaci/DTSH29r4WIziMhOvEPomP7BbkBjow0HVl/7ZJr
X-Received: by 2002:a05:6e02:1bea:b0:315:29c0:cea6 with SMTP id y10-20020a056e021bea00b0031529c0cea6mr3657359ilv.27.1676403445338;
        Tue, 14 Feb 2023 11:37:25 -0800 (PST)
Received: from gcsdo.greenville.k12.sc.us (gcsdo.greenville.k12.sc.us. [204.116.209.127])
        by smtp-relay.gmail.com with ESMTPS id bv7-20020a056638448700b0037549d0a9ecsm986107jab.45.2023.02.14.11.37.23
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Feb 2023 11:37:25 -0800 (PST)
X-Relaying-Domain: greenville.k12.sc.us
Received: from User (57.11.84.34.bc.googleusercontent.com [34.84.11.57])
        by gcsdo.greenville.k12.sc.us with ESMTP
        ; Tue, 14 Feb 2023 14:37:23 -0500
Message-ID: <EED4E631-1176-405C-837D-90758B1B7057@gcsdo.greenville.k12.sc.us>
Reply-To: <nationalbureau@kakao.com>
From:   "Mrs. Reem E. Al-Hashimi" <yuji.nakagawa@ap-bioresearch.com>
Subject: REQUEST
Date:   Tue, 14 Feb 2023 19:37:22 -0000
MIME-Version: 1.0
Content-Type: text/plain;
        charset="Windows-1251"
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2600.0000
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2600.0000
X-Spam-Status: Yes, score=6.6 required=5.0 tests=AXB_XMAILER_MIMEOLE_OL_024C2,
        BAYES_50,FORGED_MUA_OUTLOOK,FSL_NEW_HELO_USER,
        HEADER_FROM_DIFFERENT_DOMAINS,MISSING_HEADERS,MSM_PRIO_REPTO,
        NSL_RCVD_FROM_USER,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        REPLYTO_WITHOUT_TO_CC,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_MR_MRS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [209.85.166.228 listed in list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 NSL_RCVD_FROM_USER Received from User
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 RCVD_IN_MSPIKE_H2 RBL: Average reputation (+2)
        *      [209.85.166.228 listed in wl.mailspike.net]
        *  0.2 HEADER_FROM_DIFFERENT_DOMAINS From and EnvelopeFrom 2nd level
        *      mail domains are different
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  1.0 MISSING_HEADERS Missing To: header
        *  0.0 AXB_XMAILER_MIMEOLE_OL_024C2 Yet another X header trait
        *  1.6 REPLYTO_WITHOUT_TO_CC No description available.
        *  0.0 T_HK_NAME_MR_MRS No description available.
        *  0.0 FSL_NEW_HELO_USER Spam's using Helo and User
        *  1.0 MSM_PRIO_REPTO MSMail priority header + Reply-to + short
        *      subject
        *  1.9 FORGED_MUA_OUTLOOK Forged mail pretending to be from MS Outlook
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Sir/Ma,

My name is Mrs. Reem E. Al-Hashimi, The Emirates Minister of State  United Arab Emirates.I have a great business proposal to discuss with you, if you are interested in Foreign Investment/Partnership please reply with your line of interest.


PLEASE REPLY ME : rrrhashimi2022@kakao.com

Reem

