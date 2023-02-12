Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BAEF693A17
	for <lists+netdev@lfdr.de>; Sun, 12 Feb 2023 21:59:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjBLU7Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Feb 2023 15:59:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbjBLU7Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Feb 2023 15:59:24 -0500
Received: from mail-ej1-x642.google.com (mail-ej1-x642.google.com [IPv6:2a00:1450:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 322F1E3A8
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 12:59:23 -0800 (PST)
Received: by mail-ej1-x642.google.com with SMTP id n10so480480ejc.4
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 12:59:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zK680p2X1pUlhJx3NNHZ4Clg4FYmh3UCp+9uo1iSl8Y=;
        b=hAHst7GbPT34f4SHz19+GSpk3sq0Z73m2bLWKyqjoO8vF8ejSG1zstct9LnL4wekri
         B7YhmatOE/iu6HisrjIQWxCop1wwaHqapCzKQhNgU6/pOfKwjRwlPmi1phn+Hyusuqna
         uGde6eYeBVrIhM+cC/ltZ9WI6WgYf5U0UqO7trAnZ6vmRMRAiWRK40sgk8j+tR7RsoE8
         /FhcSLR5gSV9D08mYhRWuVSs3Z8jbKkmHWaYWH1TbMAhs6HLIwr3DM9aPe9Lzj+TKZJ7
         1C8nSyUXG4GTPhffReUM7qQAtYjWh1La1te7Oyymfo8h3imjZgTEjHrtZDA6EvivtqT/
         y8yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zK680p2X1pUlhJx3NNHZ4Clg4FYmh3UCp+9uo1iSl8Y=;
        b=bSciG+eBGXaIBmaOqUM8dIU8Bs+7LKhFDNiESZ3LAw0mui+eDFgi/TEQUtCmQZq+VU
         P1a+5aHhXsxZEimtaM4TL+ZJeMZasszZ0zVRPEPBdYJIEQf/hTGm+fGCyGlfTz9yR4uM
         UZ3IOVpB6oLZHUR3msWWogK9CTeed4zF5WqvXX8rcmFlfrDjPsDw980GTMwZKZV6Gobc
         Yu+IvYSXbxrquYEFqkLHGg1y1HD29qaNvDW9hoNObh7nv60xsyJeSOU5cCyRaPPS8W/V
         vXv5UEGHxgXlo10I8nxhxPyRpB9ZvgAxMJ5Ka5cTqpWfydgAg4AahzIshvIkwdlSS7OJ
         y4xw==
X-Gm-Message-State: AO0yUKWDOnXJtLrdEW1C/UKhsM4KoeNl+loXjjXAqGkErycLyq4jnilZ
        ta0EXgfpOvBSs8o1N+kreP+pIOKSEudRHvLrlSE=
X-Google-Smtp-Source: AK7set/6ZnV1MRwIX0+qr6gZahFA1K+dR6NzL/9ZHq0xpvdlH0uvZU25pf7zvKZ2OWg7Ti2RnsetXQRGdvVln7drViQ=
X-Received: by 2002:a17:907:20b3:b0:87b:d79f:9953 with SMTP id
 pw19-20020a17090720b300b0087bd79f9953mr3470877ejb.11.1676235561693; Sun, 12
 Feb 2023 12:59:21 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:c24e:b0:46:c70e:2559 with HTTP; Sun, 12 Feb 2023
 12:59:21 -0800 (PST)
Reply-To: compcom013@gmail.com
From:   MoTown By Mojo <paetwine@gmail.com>
Date:   Sun, 12 Feb 2023 22:59:21 +0200
Message-ID: <CABZfpGO6xsk6ZVw9M8r5+uY1s1Y0ER-iE03CvM3PrRxCDGkXpg@mail.gmail.com>
Subject: Quotation Required Urgently
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:642 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6274]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [compcom013[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [paetwine[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
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
Hello

We require a quote based on the attached documents below

Would be much appreciated if you go through the quotation attached and
reply ASAP with your quotes accordingly.

Regards
