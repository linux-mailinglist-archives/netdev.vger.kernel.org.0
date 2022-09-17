Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 218035BB92A
	for <lists+netdev@lfdr.de>; Sat, 17 Sep 2022 17:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbiIQPkC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 17 Sep 2022 11:40:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiIQPkA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 17 Sep 2022 11:40:00 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72BB14020
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 08:39:59 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id e18so11693098wmq.3
        for <netdev@vger.kernel.org>; Sat, 17 Sep 2022 08:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=tlN+WWCM6hnCn3r5d52raD5+g7zBw+Q/FQYK/mGj7Wo=;
        b=jXmKcMjTFAUioTLK+oSsDKI0wL7kNCmH688EP0ZCApfKQ7gSIfCUHSaU0S7rwrOB2B
         2xJ+umklyORkU+MWwszHXICUC85iQeYOagKx06KIO+J6mr88WRhFpgBFVE55/s59SeHt
         fg1YV6Sr2d4FkXyshb2Sn1KXQFjBSzQx2wbJztE5jfDG0paezvJusIZwTe1A+Wqo/+k0
         ha1YcE3YuuTdSnE8rclB61Kx/+APvKZGZWSV4KX4MsLtjvWS+CwpBbo1PnkKIOI7PwYt
         WY8h2iPoRU34asDjA4B4rKsqLWVzh4R3LrCP2GhQQbyxb2uuc0QqccsvJ9VxSLUGkCfY
         NBJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=tlN+WWCM6hnCn3r5d52raD5+g7zBw+Q/FQYK/mGj7Wo=;
        b=qcJ5o6YvFW3CRk2CAq6u1d4cwHZBPnpeCzMO3IDGgOB+xC4VPoUHbZOiPfhWu9c4CE
         TWgEnuxKy3Ocfl8HleNcuG/g6pnH1e+ilUDdMQIFW2D7b9pvPl7evYIuR9hI6ft/1TVR
         CynmiSW63Xfauf6Nt97dAcoacysToxKkdfxYT2fsK/u4QLcVX3Bu5j9CzhH5BJWozx0U
         sL3UXv/lsJd0cSeCvjODjZCXkvawIs7eX8VdTfoTi+dchUGZ9RY5WOwqLzRhwUmSndeb
         Apa5kGHoO6Rwp+s/13oNgt6bwt6z8DvWXZ1BxX9Qq7gJek8vNZjNFvK9/xRw4LNTLlk+
         xVrA==
X-Gm-Message-State: ACrzQf0iWxv7A5/jVsGVgnqsNRl2fieDuAwqafWXhKTq40VQ9KljMCA0
        mHOmRwJpVmN+NFJItYVQoPnGThKLCSRQMDK+OVI=
X-Google-Smtp-Source: AMsMyM7Tu6T6kkry7tPWt5YI4rIX8Q7yCIMw5L/a9CQa+wi1G41zB2Wxwv1yLU++y62Hd+Nj1kHyWPKq5nwUKlPo81Y=
X-Received: by 2002:a05:600c:4f13:b0:3b4:9a07:efdb with SMTP id
 l19-20020a05600c4f1300b003b49a07efdbmr6794265wmq.94.1663429198422; Sat, 17
 Sep 2022 08:39:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6020:5c16:b0:211:f995:ea37 with HTTP; Sat, 17 Sep 2022
 08:39:57 -0700 (PDT)
Reply-To: mr.ahodolevi@gmail.com
From:   George Levi <howen1791@gmail.com>
Date:   Sat, 17 Sep 2022 15:39:57 +0000
Message-ID: <CAL3=6ivxQ2WS4r+EUQyqi-She_toXLEEoD7_9DKSMTDcKdEL4g@mail.gmail.com>
Subject: Deposit
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:333 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [howen1791[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [howen1791[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's
Barr.George Levi
