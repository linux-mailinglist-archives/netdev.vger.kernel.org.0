Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A95B66C7D88
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 12:56:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229831AbjCXL4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 07:56:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbjCXL4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 07:56:38 -0400
Received: from mail-oa1-x31.google.com (mail-oa1-x31.google.com [IPv6:2001:4860:4864:20::31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA75323A54
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 04:56:37 -0700 (PDT)
Received: by mail-oa1-x31.google.com with SMTP id 586e51a60fabf-17997ccf711so1524371fac.0
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 04:56:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679658997;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uBlRr9q265Nv8kRQVI2pIMY+89rTouQ4PH5QCVhBU8c=;
        b=SVeReQjoPoMWBzFoIe15bd+gWYDGwxOzLb55EgO3u3GZGvyJj94k4KbdBA6/Vtiqo0
         GUZawvVtp+I8364L/QaKESoFUSblNUEbjDreMJgUm6iqTD2+BASP6R5dOh7bCF5rbC5E
         zeHJhS5fMv/hjxkvVvRWzpNZJdd/RpWzpXBAAiZjGjw5M6xdSmSjYYTqxS6FERiJo6om
         Jb+8brz/UNDzh1tHs9QNBzVoo5kRPrRIOYsvZW07WL6rEEDSM1rwxMkQV9rOWCj1ZIgZ
         XukJTKvmoVn8Wxa7cpQneW1KoBuAgms75KyI9t153DlyC3cnkVd+IxIXSUs7fmz71FPT
         3sCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679658997;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBlRr9q265Nv8kRQVI2pIMY+89rTouQ4PH5QCVhBU8c=;
        b=WPgRh+UWvmDQHMX0WcxIbWeFwHI+/O4oM2FQNRh/WP/cD7ZZYZCE3fCxpOuLlBgBTw
         fjMtoI8rnMl124MzH5BC2PGWm+pdaY1ZX/O35Tmf5p56AfzwpztW2o728QpxRB6SQ7zI
         f1xJpj8VqRg5Qm+ygBMm3RNUr9c7xPIEn1fTqjszd8hsV/4hqG8QWhgfuJr0gL8dB7lU
         XTMX8Y+Ak0GLTQJVAXiJlHFvGL74vhtnigLs4436mifuyQxrBCSs3ELFcbPQq6BgWd04
         i1TSlOVkS+sEIlEfpHw0WnluN70f4NFYuE0gPymaJgiZWoiTIdnM2uvhLw/5AAuKglUP
         qvfQ==
X-Gm-Message-State: AAQBX9drn6SXcu1wWlWH2bawFY5wyMeeYKxPnWzUwgkRQ26uniyNlAGR
        8NUtDlVBCGEWkvUrXMf46h41QqYR1VuRuqaAtAs=
X-Google-Smtp-Source: AKy350bXPdJso2lGol9VIC0j/I3Xp+qDJfAIUVd6Q0yCPjEhgSDliWPx9zIOrBTbY7BLB5pmH9Pk2mzGtZgay1fSJO8=
X-Received: by 2002:a05:6870:1159:b0:177:ca1c:2ca8 with SMTP id
 25-20020a056870115900b00177ca1c2ca8mr858315oag.9.1679658997090; Fri, 24 Mar
 2023 04:56:37 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6358:1087:b0:eb:2721:599b with HTTP; Fri, 24 Mar 2023
 04:56:36 -0700 (PDT)
Reply-To: fionahill.2023@outlook.com
From:   Fiona Hill <hasanahmed62621@gmail.com>
Date:   Fri, 24 Mar 2023 04:56:36 -0700
Message-ID: <CALpxZtg67=o_UspG-ECq+b+PYe+fMCT85bG+4AOuS_KwuGVr_g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello friend did you recive my messsage i send to you?  ple get back to me
