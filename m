Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7F2356FE34
	for <lists+netdev@lfdr.de>; Mon, 11 Jul 2022 12:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234302AbiGKKFI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jul 2022 06:05:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234459AbiGKKDd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jul 2022 06:03:33 -0400
Received: from mail-vk1-xa41.google.com (mail-vk1-xa41.google.com [IPv6:2607:f8b0:4864:20::a41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58DF448E9C
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:29:34 -0700 (PDT)
Received: by mail-vk1-xa41.google.com with SMTP id j63so2141846vkj.8
        for <netdev@vger.kernel.org>; Mon, 11 Jul 2022 02:29:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=DBXVr+2yQA4Yc+mJwCPapHs1PcqJSd/+SbzdjhsE7eQ=;
        b=TUGrmjBkxC9L+1InG7C1fgHmy3w5jYPm5vo+MdupAIWyQB9+geJahel8A84QiOoefj
         +RmHtyiH1zoG9Cxa8fa/pVc84mC8ChpeUQlSYiLq+0RMtkIZjirNmtWbSdg0ZwXCZUOP
         QQ16TAfZxZkFuWLnq/rd7foQpsnVXxbo2eOCqe5LBj76sqAUIgIMLRz1DQCaw0Lqdjai
         /wSOZJbhfqxenLlqWMz72YK1wDa4b5fJhRzgtt/kkc0J9hD2CkajSTbhvrXAtHttb6Ox
         jB4FkzwdctJgCzME4FQOkoTofGiTQEvOmYw6QDpiph7zM9o1YfeA6TzE8Z5V8CTE9lvL
         2XUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=DBXVr+2yQA4Yc+mJwCPapHs1PcqJSd/+SbzdjhsE7eQ=;
        b=Gp/PHmVV6MuCINEGGGxaNDxKgK+nq1j2Q14JovBrDbQh3dac4k9gcr6wOeHvD+4LCn
         f/W5F79Nh96LemYDgwRikGqeXnfbgu4nWKmZCeBhu1HTsB/okp2PxlPyMgjUJFispBpi
         S3YtqjBcZ8/j2DLQVc/2uDE891Y2fqgfH9hXWuGYQ6HK3L7DRX7OKI3Oj500fcYKP05h
         xFamXz+S38VSes7yS1KcPx9ywTdf0ZASIzcoS7r6KxVApGxiT2aqPNsX8i0ux91SANZN
         nfeB/ycQMcb74wHz1B6SDnexvtcsV7HlFOsE/IWtkne5eRH8/AixFjBO8Q+V4RdlIDZF
         fEzg==
X-Gm-Message-State: AJIora9oPq3js+lKduUl3PEJ1oWxDVMQHAzMyEEsouSeQHkXvG6bjVsK
        isPtFY56b9gWsJ/t6lqlG+q/20Y1ouwbCZgJBcQ=
X-Google-Smtp-Source: AGRyM1uXt7J0tB22tlgi9dBrtsHjl7gC4Z8CwqWLtyk/Q9KKNicOZg+8Vvq2ZLdsz3mJSPcM2cn5MrrOC8x4jDd21U0=
X-Received: by 2002:a1f:9e92:0:b0:374:cefe:51f5 with SMTP id
 h140-20020a1f9e92000000b00374cefe51f5mr282705vke.7.1657531773033; Mon, 11 Jul
 2022 02:29:33 -0700 (PDT)
MIME-Version: 1.0
Sender: myofficeada@gmail.com
Received: by 2002:ab0:a94:0:0:0:0:0 with HTTP; Mon, 11 Jul 2022 02:29:32 -0700 (PDT)
From:   Chevronoil Corporation <corporationchevronoil@gmail.com>
Date:   Mon, 11 Jul 2022 10:29:32 +0100
X-Google-Sender-Auth: 6dmRjkb4TpRVF15T_q10_IrcB4A
Message-ID: <CACvfspQSrnm3jFaDi1DiP_JfGdAPQdhhR7hGXQwy-Z=FgSwEvA@mail.gmail.com>
Subject: re u interested
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

BEWARE, Real company doesn't ask for money, Chevron Oil and Gas United
States is employing now free flight ticket, if you are interested
reply with your Resume/CV.

Regards,
Mr Jack McDonald.
Chevron Corporation United USA.
