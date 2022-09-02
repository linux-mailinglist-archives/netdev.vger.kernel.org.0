Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B22B05AB8B4
	for <lists+netdev@lfdr.de>; Fri,  2 Sep 2022 21:07:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbiIBTHT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Sep 2022 15:07:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230230AbiIBTHR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Sep 2022 15:07:17 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BEA7F548D
        for <netdev@vger.kernel.org>; Fri,  2 Sep 2022 12:07:14 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id d126so2938576vsd.13
        for <netdev@vger.kernel.org>; Fri, 02 Sep 2022 12:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=eMVCF1fPAuqmYegJoCJUJU7da8MHPWujB10GZ78eaYE=;
        b=fh8uM8XVFE3WQviQrJk4h6eM9MGZ+PaNHR/9Y4OflHi/+E6OzE6E8wXCB9h0QJiBgt
         fq0/upVmXDIw2+uaMxKIJPseQeWzEh11w1dIzEaDIzlooptNwaJJH+2rxfX0EsnoC0t7
         BU0dhz8lMf1BNUZKnDkhcuW3OdFQgBLB9L/H8V8tilkupSadowDVwpKKY6VOC+VO8Ita
         AjImtMVb2FDJvJP/da9+DkRBDVZ3kFuaoQUUxvuXPsPlzaVzY76X3WH2aXfESUyaBSqR
         5occT2BJ//TaptvXcufe8KXun1uQMN+Zs86yDfk9rrFouLw9ehH2qcF1n+4dA4MTTE35
         giIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=eMVCF1fPAuqmYegJoCJUJU7da8MHPWujB10GZ78eaYE=;
        b=s6F63tDFrbWOHb6R8CwI6+YyU4Z402xm91o2IHMOyPt0qJ+Zhs17ve1SbDk/3F4BAE
         gRIOFszqdVJ29EzcGJ2+MMRoAUMPyzO2N3XdD24yrWX6AlDrXCeEWFdz+wr6o38sbkDu
         U6xKVdUyfcE0F8xRqc3XFASq3EGoCJhuzQyeRWA+d/5J/lWY3hp/eMHJbgXCT9ZDwzDJ
         ZwgEAYbsc6jrfnQQv8vhB9ZfNqC1va1PNefG6maHEZNx7FVROkCJZ7pqQdySlz2TFnAe
         GScyGzZCYnIeeFkgbJ5OG83m0jDbvSgSR7Tk79wVjlpnM/je5iYTnkEG/jqJyFLjl7wH
         ykzg==
X-Gm-Message-State: ACgBeo2pRVIYOfxjRdihSdIYFRPVnyWJLbfjzH12ce3AAt6ZHfuG4kvw
        8vol83OB6b1u1iZt9Z2j4QmIQL9UvGMTyKe4saU=
X-Google-Smtp-Source: AA6agR5znjtR3MJpIgdpDg3n8vG1SUxhhUQAxkkhrFpazJz9JPz2puGuYl/+QYVb+rdRBkRrVkoFcCvbL8IOAHkrh/k=
X-Received: by 2002:a67:e058:0:b0:390:e62d:8976 with SMTP id
 n24-20020a67e058000000b00390e62d8976mr8423148vsl.31.1662145633101; Fri, 02
 Sep 2022 12:07:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:c9d1:0:b0:2de:35c8:c59f with HTTP; Fri, 2 Sep 2022
 12:07:12 -0700 (PDT)
Reply-To: officeeemaf@gmail.com
From:   "Chester R. Ellis" <offficcemua@gmail.com>
Date:   Fri, 2 Sep 2022 20:07:12 +0100
Message-ID: <CALY5DG8_vJyzc9Q7ibFqpyqQiDgzOPYuRaEvjDkHtTm_0xvY+Q@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings

I have sent you emails, but still have not receive a response. Kindly
get back to me for a mutual benefit transaction.

Thank you.
Chester R. Ellis
