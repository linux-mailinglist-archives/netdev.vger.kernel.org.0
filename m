Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB254BA893
	for <lists+netdev@lfdr.de>; Thu, 17 Feb 2022 19:45:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244621AbiBQSom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Feb 2022 13:44:42 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244646AbiBQSok (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Feb 2022 13:44:40 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E742F517DB
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:44:19 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-2d07ae0b1c4so42040277b3.11
        for <netdev@vger.kernel.org>; Thu, 17 Feb 2022 10:44:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=ba5nKbkTjKbTr+SuxtpWDm17J5/MCT5o95E8KTMiqwifO31Tk3DJmDoWS30L45v9Z8
         xQmIwPnb30rQZgiThG+wsgrD0GLC2e29Tyvtid7RFJcnI6qO19Ncq44aQLZ9N/0gUUap
         3S0PSjDRZCZxZUNoTyo5QZI8Oozx9UUi/TPacLLVuUigoz671riEweSDq2aJxZWIs9L0
         nXAYpnQOVsIoFkvkI/lHR24MBGY33W934t3Ub8XNtPzA7v7NkFF5VbyhmN2Sux3Jbdz1
         1Si41/Mk6sqyk1NfpvcDWHUEtcFWVA7AJfxGK/candCUQR81OqO63SCWNPihR9vXfBdx
         gLGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=n5JZG3l5wSabHxVEIH8twRo71vloJ96XZUgmhfr5JbA=;
        b=D9eoRyHwvo4Eo6FGvY/y5m6tYrOxorI/uWJ63/Qc9zNyk7E/topyzvNp3zomH+vaGn
         LKVb9W3yG6/UmwsexPt74vK+oCEN2basTjxDH9quc/Oa++fR9bN7bqnBwBwNfmXSrSAO
         sdJtFe20jyWmg4eqs2DW/qqDfiQJM4O4JIHhzXLLGzpD4nYYLk+RBZ7VoIbsKphwPoKl
         Ma3AEEYh1VpTXKxxnXGUD5GvtrEDrglnHR5mYBZlqucnpIDecmP4fAfPEBS/adZmjrKj
         0YcHPNxeWaKo0VKBSHOO7ljToY3XjGvxVqP6Q2pbnJm8gKDLBtSuPyer7zUvV3vW3jXC
         7J6Q==
X-Gm-Message-State: AOAM5300GpfV9a1e8+1a8BshHUu5UffFQZpuzFug3mOVXj97gyjDU88i
        6/vTCdaPBqtVxYHjOpwTfv6n7bxdlFLrUcSOoqY=
X-Google-Smtp-Source: ABdhPJzmFhE/EX0UnOQiuaRMxobfC2LJJcGqkfkcLqwSwbpAYt7jMjkbXYyr+pJcbLXjyQZp8NmUz0Q/hSznm8U5Yuo=
X-Received: by 2002:a81:4b4e:0:b0:2d6:bba6:c30c with SMTP id
 y75-20020a814b4e000000b002d6bba6c30cmr24281ywa.244.1645123458807; Thu, 17 Feb
 2022 10:44:18 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:e813:b0:20d:4259:e996 with HTTP; Thu, 17 Feb 2022
 10:44:18 -0800 (PST)
From:   ZHANG CHENGJIE <zhangchengjie79@gmail.com>
Date:   Thu, 17 Feb 2022 18:44:18 +0000
Message-ID: <CABL1GxXXGcuKcxdHdzbP_-drbL68WrxV82DHdwGWLA_3WH9D-Q@mail.gmail.com>
Subject: Dearest
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dearest,
I sent this message to you before without responding.
please,confirm this and reply for more
instruction.(jerryesq22@gmail.com or wilfredesq23@gmail.com)

WILFRED Esq.
Telephone +228 96277913
