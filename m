Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA2DE69A5BB
	for <lists+netdev@lfdr.de>; Fri, 17 Feb 2023 07:51:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229554AbjBQGvN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Feb 2023 01:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBQGvM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Feb 2023 01:51:12 -0500
Received: from mail-yw1-x112d.google.com (mail-yw1-x112d.google.com [IPv6:2607:f8b0:4864:20::112d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C504649892
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 22:51:11 -0800 (PST)
Received: by mail-yw1-x112d.google.com with SMTP id 00721157ae682-535a11239faso11760537b3.13
        for <netdev@vger.kernel.org>; Thu, 16 Feb 2023 22:51:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=O+3r6Lwvhms6XJ6bo2c6l90xkWazMwajl6iI1ojTsco=;
        b=aFd3/fZJNEkbib0vCJEPeu3Oc36Be4BLkIRFHEBAL3oXiUAr1RjkelUUevqG22fn4T
         xTmlM/zyTZMXttChAjp6AcH0xK/vqVpHPIZQl0ke1eLkxbFAPlKvHt4CIqgAdcp+WYJp
         PcXd+b+ZHBiT1ztIKmlf0VLz4miCldan+cBfSToBAohbjvnqFF7KszWrDWUD0W7lLwfF
         1Wj/TwPRZUxtI0TOVFH6oS5Pg318ejpV5U9sv75OnK2XdrYLrqlEOnay0TQ6uJZq3lCN
         XwB8Mm/t8Njp9VmWDS+vDHPySeXENbT90dSBDYCgk/QaVXtVcpCvb9ESp40pWDMMKdBB
         yVsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O+3r6Lwvhms6XJ6bo2c6l90xkWazMwajl6iI1ojTsco=;
        b=O3cYIHsEGQPXQCvrraitCOd8PTQuDDDZ8XPc1VK0Y5O2v1rWUGf1k7p838J+g5vYzh
         F7RiDKW77UbFZvhtRr2FFuGje1kAIXFkAFijRcxZvA+KD/cDAJQE2CRe8l4Me71GRbqB
         Kq3976pfDOoqG1n3tOCr00rJUtOaUq9tPfL+vfnUULi38KnAe3tRMnvRJXryYUKaJhC7
         4ydTcE5GLY4Qv84CtE/ISABTZtLHvmL2VtpoAo5kISR1jmagZOJmpo1KAKf79HUrZ+ir
         KW2l1mUE3SJ8xUTNPejrTheRyP43W5IK1eUrSH/7ugi+2aBRk2fuu+y6TxCnX7e5zYyh
         V4Bw==
X-Gm-Message-State: AO0yUKXsGyJhI/WBcOg25fVMxCWvtAvvkMh6cIJUh8Vgzx42Sa9AMp4S
        2QvY7JY9Ayn1PWA/8HCUfLa8c6ERaWLFYFvHkpM=
X-Google-Smtp-Source: AK7set+vhGMCjv8KeilVdKHUDNDXiTOpQD26RExCilf6Qu+NPVr8MiDDaD+/o0oyic2NiJGM1POAVpNURn8WGBKsdow=
X-Received: by 2002:a81:8746:0:b0:50f:6969:abb7 with SMTP id
 x67-20020a818746000000b0050f6969abb7mr1282190ywf.20.1676616670747; Thu, 16
 Feb 2023 22:51:10 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7110:7114:b0:1a2:ae69:ac91 with HTTP; Thu, 16 Feb 2023
 22:51:10 -0800 (PST)
Reply-To: zongjianxin14@gmail.com
From:   Zong Jianxin <suleimanattah79@gmail.com>
Date:   Fri, 17 Feb 2023 07:51:10 +0100
Message-ID: <CAGOg3Udbdn9GhBNRgG+qPzxG1ZTqQi9P=smAfQBfXZjbDCgV9w@mail.gmail.com>
Subject: Urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:112d listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [zongjianxin14[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [suleimanattah79[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [suleimanattah79[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Did you receive my previous email? I have a Profitable deal for you.

Thanks

Zong Jianxin
