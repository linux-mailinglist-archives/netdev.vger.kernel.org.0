Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DE8693F13
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 08:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229742AbjBMHrQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 02:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjBMHrP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 02:47:15 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF1C9E3B4
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 23:47:13 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id p26so29564402ejx.13
        for <netdev@vger.kernel.org>; Sun, 12 Feb 2023 23:47:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=MJQAAKhgS1HAQgiKNzERljw3Weiq6U/6tmKlDPbrmm8=;
        b=pe3viiPEb0L+cr/OjIoCuiA5aatDAKYMlRdNPopyNaKkjs6ZagxZ1ZiBz/bLKosCd5
         NvLEhDR6IKJapPAqoxAdLU22pADzW6OrUSDtVpJw0bkXen4S4FQKZwzr2ian46S3gyVM
         3ReQPn6ylzTvQvrwOFgeweqJuVkUutgTE059roDZPFc5lxRm5iXRZjgB2eNauMNrCy4O
         Lt/9y+YDLKxJbC01wSGp15j03g5wmIsAqBiYLnrYTD0f4vRCw/fA1OVe/5SFA3phlFc0
         bO6d9HhNQRYH16WjHGXfRX5b6skMRjk8b+98iN4qIViDraGH8Y4EJcxwmO7rFAvkdDgk
         k7Zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MJQAAKhgS1HAQgiKNzERljw3Weiq6U/6tmKlDPbrmm8=;
        b=MiUlLg/ecd4CQ1I4TSAZ224wbaNMTbavJofTK042fmHF850uegg3vS3AaWsq3cDjMj
         XVGteL5F9mecI0YgGQfQz13zYXFGZx3lhF52x1qa2mzXxcXwqPQPZp5nXrCBD7kvVLrM
         JGFPTFspqKme+2awwWftoj71/YUQcjJJPS4d+DKD6plmR3gKcgARBHeWRaumAAi2P95P
         teSN9lZHvTJOLy5Hwn3iCs9gs70bmEqq9IhDkXkdF/zim4ZGC6f8SrOjVN4CJCN9sUvW
         ZFB6UOg+ok6p8dqCU4o9clq0PNZrFv0smPLALG2p5WyuoWFT7aHyJH1AOrCa163aiCVr
         si/A==
X-Gm-Message-State: AO0yUKVLKGOEOkUvAdPuNKtdv9V+e19ibEdoAeVMlZZRQqHO5yLDqaxk
        AH91GfRpoBxHx2+KE5oKoxYDSXDgoQu/ETL9EJg=
X-Google-Smtp-Source: AK7set/Vh9B6yGUeO5tU0YspSKWIK00kSbDfmKNLxsfEp04wbUr6XEGfY0aTVQeheDwno7br9s06bYUvn+YbocXXuxk=
X-Received: by 2002:a17:906:6dd5:b0:8af:43c6:10bb with SMTP id
 j21-20020a1709066dd500b008af43c610bbmr3731066ejt.14.1676274432196; Sun, 12
 Feb 2023 23:47:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:906:b1da:b0:88c:8590:e2d0 with HTTP; Sun, 12 Feb 2023
 23:47:11 -0800 (PST)
From:   Majura Akos <akosmajura@gmail.com>
Date:   Sun, 12 Feb 2023 23:47:11 -0800
Message-ID: <CAF9nb+=QGbZ_i3qZWzgCb-X_fJkwNu=dKGXm_GPCBDnbUpG1=w@mail.gmail.com>
Subject: My apology
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My apology, I am unfamiliar with azet.sk mailbox, I have emailed you
several times without any response, I wonder if you receive my
previous message or not? i want to confirm if this is still your valid
email? Get back to me as soon as you received there is something very
important i would like to discuss with you.
