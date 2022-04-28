Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9ABD45130C0
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 12:05:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbiD1KHw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Apr 2022 06:07:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233682AbiD1KHI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Apr 2022 06:07:08 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52188443D0
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:56:50 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id l19so5994157ljb.7
        for <netdev@vger.kernel.org>; Thu, 28 Apr 2022 02:56:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=MfPWHHhES90+CjfQ0PZ/nko3nay72mftpMTPzNVLKFUFoUrTWXbYFCbReBjuTm+unZ
         TFJkcoudCrSALeeC0HwRf2t5DWA/IPFkjIQ6bnfXCu0u3hJWU66Hr5JED7R6Y4nm2vIM
         BgXzJLxvPEX7iZoIzcp/WOrzLOPNS2dbdyrJQhdCWLJFyShQ6KHuVQ5rKf2xAmm6XofS
         t18h7Ui//ozos/vwcq+Ws327rhlpHhGL+6lWK98Ng67hjvRUVz8+RU2cpbUrCiMcjr+y
         tYw1XTcVaZDbJmfYheHdYokp79rcLt6vcGVFWxQWeCWR5QEwM6JyzohfMriGRhucHuat
         RNKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=H2YfWCG0balrUsjNebe6NPqLv9wl/pqUnfwIaMT7BYE=;
        b=1HyqOHGkqDtFSINk2PGENRT/5BuEqlWBCaXe2zkDznCD4z050PYQMdnHtGQiQlFo9p
         p6vrRJK/mQzHBEOmYkYQUexN+mc3JEjaVDLqHjisyUi56qhRK3CCyU+WCZlhipWMB0hR
         KNFel+yWl6IPX885WaIGrsgGlg7jdHsyemKjiLeX2JhmrdKlL1yZ1pSB8GpHhnvgLoCp
         jpXo8xdQ6eDX45Oma3EMXuA9WR9lGh04msqXt6BGBobNWZ2HXNt5z8z+L1L6v1ZzJrDu
         nKpSaZynXGhVb04vZGLVycFfPK8QvuEFH5gsbgMX2Ytf1SbnlVN4/RnjVsstLrqKo7wj
         bKEw==
X-Gm-Message-State: AOAM530qiGa9NeM/jCPIGKTIbD3of5NRWjv0NkEu6chMh5dFYwgRzhAF
        atNc6B6bp4389+Z1EAsM8ChEA7af20/Hq/T0HXI=
X-Google-Smtp-Source: ABdhPJzRaLyD4JMa/+N63rLH1xZDnz2SG9ZqAhEpuh1lNahzg85c2CEn1Sf2KW4LNcA3tPEdaAAv3/EXPCGqjPt5evU=
X-Received: by 2002:a05:651c:511:b0:24f:35da:3524 with SMTP id
 o17-20020a05651c051100b0024f35da3524mr647770ljp.233.1651139808110; Thu, 28
 Apr 2022 02:56:48 -0700 (PDT)
MIME-Version: 1.0
Sender: a22663085102@gmail.com
Received: by 2002:a05:6520:180a:b0:1b9:dd8a:96ec with HTTP; Thu, 28 Apr 2022
 02:56:47 -0700 (PDT)
From:   Lisa Williams <lw4666555@gmail.com>
Date:   Thu, 28 Apr 2022 10:56:47 +0100
X-Google-Sender-Auth: btDs5JfYv9FHhEx4n7Xg-6fL7PI
Message-ID: <CAOCtwZ7DH2W0g+GbbyG6EzKu7wm_P7sPMVijiaod2L8koATRWg@mail.gmail.com>
Subject: Hi Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi Dear,

My name is Lisa  Williams, I am from the United States of America, Its
my pleasure to contact you for new and special friendship, I will be
glad to see your reply for us to know each other better.

Yours
Lisa
