Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B57E6BABF4
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 10:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231657AbjCOJUI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 05:20:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbjCOJTt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 05:19:49 -0400
Received: from mail-oi1-x22c.google.com (mail-oi1-x22c.google.com [IPv6:2607:f8b0:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE5471FF3
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:19:48 -0700 (PDT)
Received: by mail-oi1-x22c.google.com with SMTP id bk32so13655400oib.10
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 02:19:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678871988;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBlRr9q265Nv8kRQVI2pIMY+89rTouQ4PH5QCVhBU8c=;
        b=XKsyaUnxt6UDUu+fWFlcHOA8J9/PF51XuJ2mz1c8pI8NpYdzzxUE/FWGO3o5HtgWvu
         h3t+IOhILYg9t9pIyljVWCo2jsoTT/yuft63kCrtnrW5eqS1Xg2vQUFxO65Nn5NcbCLL
         MCdqgs6pcI8c0I+sE8M+1CzDsQ9TFwKTNRnr6odz7HTYBEIEli7djLLDa3bhh3o4Hryp
         nQN30SLXKZsOU1BhQwf616JOeaSMrXdSNsRJilnX6qAKf6c7dw4ZPYTZL733QbxN5ts9
         9F5XQGAsiWaY2CnLviVaLjsZMiRpJkAkw76IkzSvcpw9mi/J0U5W86pTeO3hSl4P3/AX
         JZAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678871988;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBlRr9q265Nv8kRQVI2pIMY+89rTouQ4PH5QCVhBU8c=;
        b=RzKF2/5MDQqTTgJ0KFKRYJhlPAah5LbEGs9vcpMJpuG4AVdS60tcuFz/CYoDCcu+aQ
         Ak0DiT/1yoGx7MYZq+WD46j/jPpRU0BQVjmvnt4kRW0bYi8eyLXpOSWlhcmNnDdhXM8E
         P3FIONKxD3/iubTKYaktftG1JpH6GanIzAwbaPb4qKx9z5xAMuT9aMf0vO9pbB7o7uQD
         wTzpgwbEY7tbJI06QkcZb/P+A4PpscV7x7CTOhjaUIkcHm9reuW/efT+OnfHzXaCnAB5
         dRP/j45Rx2aVWFLnKwViJ7XBtx297S8O/62x+6HIQsLp/rI9E6XQzZZo8REkHZX2WWBv
         T8BA==
X-Gm-Message-State: AO0yUKXoqSmG39j6sfByzkci6LA8tMZJkm17Mc3hDsvAHWKMmuiR0pmu
        GYgXMqd3WB6WoPmPF/a6iXoAh25rwbbCcD5bO5k=
X-Google-Smtp-Source: AK7set/ZXIDSkIsAEqEGmkydYz2L/GJUxz+RJ+zVJDn05RNAJT6blqdd5MX0104ScOrBkSoyzhsd6xPP1R6ITtfQLjw=
X-Received: by 2002:aca:220c:0:b0:37f:ab56:ff42 with SMTP id
 b12-20020aca220c000000b0037fab56ff42mr632929oic.9.1678871988127; Wed, 15 Mar
 2023 02:19:48 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6359:6792:b0:eb:2721:599b with HTTP; Wed, 15 Mar 2023
 02:19:47 -0700 (PDT)
Reply-To: fiona.hill.2023@outlook.com
From:   Fiona Hill <hasanahmed62621@gmail.com>
Date:   Wed, 15 Mar 2023 02:19:47 -0700
Message-ID: <CALpxZtiSRYjYFpyOBXshsExhnehcLNH=mjxR4FeE5uvFKU1=1Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.0 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5244]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [hasanahmed62621[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [hasanahmed62621[at]gmail.com]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [fiona.hill.2023[at]outlook.com]
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  2.9 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello friend did you recive my messsage i send to you?  ple get back to me
