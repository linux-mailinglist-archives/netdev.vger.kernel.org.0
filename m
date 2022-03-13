Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB27D4D7873
	for <lists+netdev@lfdr.de>; Sun, 13 Mar 2022 22:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235608AbiCMVcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Mar 2022 17:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234482AbiCMVcN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Mar 2022 17:32:13 -0400
Received: from mail-lj1-x234.google.com (mail-lj1-x234.google.com [IPv6:2a00:1450:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7620578912
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 14:31:05 -0700 (PDT)
Received: by mail-lj1-x234.google.com with SMTP id u7so19287473ljk.13
        for <netdev@vger.kernel.org>; Sun, 13 Mar 2022 14:31:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=M2tGfqIlQjE1IITSX1jvyoThBCPjE3LVgf3slA2jWfo=;
        b=OZ5hp3+I97MwLEbGnD7RtVpuiK9+OqGlqxmT684yT6poh3E7LP65sRaNAv2wKD3+Xu
         tiyKacUJdGR4SA3wCe/A3BP3iHF2QkQMmAaRAOCvXst4agsjsiom6373v+ahfur8iOdJ
         5ptQv+lT5uquoSH6QIThFiAjz2odFPrYwgILcTyHVVyzGTR5kMb+OQK/2GiyZWtM/gqV
         NQZeog08MUb7uvjvRlsRRp7UzTtcEWYNIeJQImgDXtkEKQ4o67Fv2rAteLQP5sKwDVOZ
         fVuv5aIuRI8kQFLzomQRGhoQJBYIPZm/PIoTc7S7cjmTN3RGiB6GFdSZbEJJNxDfwsaB
         H6tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=M2tGfqIlQjE1IITSX1jvyoThBCPjE3LVgf3slA2jWfo=;
        b=U3T9rcQPSqvMUQCvmp/xJSvEph+hOMG3tkbgyM1Ac6Semj/+4TJuvnYCbD6FgqgfJ2
         RkKJt6DYIXBOsqYgUhNtI6/xWUb1OYGSNpJGVRcBfmDEU8+V/jkJx49KSP1LwWOoFLn7
         N5jlCXZTjPDb/CFRUvpdkqN+EBuKh6Y//YqexYo//OHWoAGBVB13np61g0+UkgvET3Ek
         Nz+0Y6xyZyLj7zliYlAI22C1PBSW3qGYvcmJ9JOdHTQUWMtsC1mK55DQ/kDttkf9Zk6L
         HE76q17kBeGXLFcYtHnQttjXYGTrachlMXMkOni1iUMkGmjW0S1t1rCaK9oozg8Jz3ZW
         KtOw==
X-Gm-Message-State: AOAM533sMZ98yHQCVYT9cRFbbUe+eV7ePHgsqCA/OHEY9Fqdj1YgmNy8
        gJhZMSbx6RGlGcOQSVibP62Vf0gJ5s6/6A/TbqM=
X-Google-Smtp-Source: ABdhPJzCESTxbY10+YP/soH6cTsNCZZ8Fn0PebOo1rV0iZ+2fX+uIo4M5DyQWHikni1k+VvT/4QsboOf+W9Z4NLXVJM=
X-Received: by 2002:a2e:3004:0:b0:246:f56:e62d with SMTP id
 w4-20020a2e3004000000b002460f56e62dmr12597443ljw.6.1647207063892; Sun, 13 Mar
 2022 14:31:03 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a2e:bf18:0:0:0:0:0 with HTTP; Sun, 13 Mar 2022 14:31:03
 -0700 (PDT)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <info.fionahill.usa@gmail.com>
Date:   Sun, 13 Mar 2022 14:31:03 -0700
Message-ID: <CAG9wXJer=7oxLVD7VGwnrjPzHkp_HOhi+wzzO2FAqQYiArCduQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
 Please with honesty did you receive my message i sent to you?
