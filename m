Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1FE694FC8
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 19:50:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjBMSue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 13:50:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbjBMSuc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 13:50:32 -0500
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AA231CAEC
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:50:06 -0800 (PST)
Received: by mail-ej1-x643.google.com with SMTP id dr8so34162648ejc.12
        for <netdev@vger.kernel.org>; Mon, 13 Feb 2023 10:50:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oOQ2wStLDIWhmzCg/kQjZqe8nkA7gHbgKI7k4Tq3KeA=;
        b=PEGdSWJWu9sCUEUUNEA4W2AH0DdWu8BSM5N6FwyKPUFj7RGF/GNpBHlzXxU8KJYO/i
         aZfvLDOhYVECy6UdqdCweby9OZI7ru2mbJT+9K0qW73/oWQT/wEXcCsg6tc+/4mQSvT2
         6+jrKuyiMBZj8k0yGVFeXHaDK/916bMpQ+kurslEqB90v7rPytCbKpsBgFdZUY4PTpvg
         +TXDw4Pzz2zIlGJbgOybrMJ+8WrAe4aqi89kyGfoo+tyHl2LH0KQsMr7a3w9S2ioA6DX
         KH/C8OKb+cFdyEb4nbevWqLOIFGp2G3E/UVnZlgcQijsByvP852YzJJ7CjgyL5LnMNGx
         Y+3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oOQ2wStLDIWhmzCg/kQjZqe8nkA7gHbgKI7k4Tq3KeA=;
        b=EwiQJ5HGp7RXJ1q7FiFBlgvjzPWYGBmR4MEUhdhDbK+dnuCsN8C5xQsM5ZJQus+XV8
         PvhhPzKz5i6ED/Ecmgnh0IZ6qOOzeBoW0+Zfh2KWwuEHYQRjEWOvxRKOIykm/Do/DgDj
         OiDCzJjSFpCy1lgTGBS53lSXjAEdqkrQjbGUXaVJaxTzj/9cGXtSkGRep/3XtP28l5+0
         Rknx6ZBDPPVtldvHibwuFyHtRZgJuehu7Gs/vsrKdY08z3h90izp3baeViCzmcIOYPDT
         Aw/ufvNVTGbbP4eEstnhcoNDJzzxIAACnbKglZIoUZAGMlXK1lJl5pR7qi1bYiklBBcK
         DEYQ==
X-Gm-Message-State: AO0yUKXS9IU0JA8ja6kYJi5pb57wDbpXy+0Nlo8GP9mLQFpWoLOGGD47
        eoZiH0SO+IjtPCEIgRKzSMGgwoN64HPO5TSwXDs=
X-Google-Smtp-Source: AK7set8PDSaAFnP0FpGmmUIvZkvw5dZ741ndHlLm10cdA21qYALnY06Sl+qf69LDrJelRsR0lUQYcqmtflRSJIb7cc0=
X-Received: by 2002:a17:907:20b3:b0:87b:d79f:9953 with SMTP id
 pw19-20020a17090720b300b0087bd79f9953mr4875051ejb.11.1676314200963; Mon, 13
 Feb 2023 10:50:00 -0800 (PST)
MIME-Version: 1.0
Sender: aishaalqaddafi6@gmail.com
Received: by 2002:a05:7412:389b:b0:ab:c115:9d4d with HTTP; Mon, 13 Feb 2023
 10:50:00 -0800 (PST)
From:   Hannah Wilson <hannahdavid147@gmail.com>
Date:   Mon, 13 Feb 2023 18:50:00 +0000
X-Google-Sender-Auth: biLX3lE1zLwBBq0htpGnn--1M4Q
Message-ID: <CA+c3Tp5bTvvMMyjtbOviqr0ZUgg_s_Uyvtnz==489EapTPYe0g@mail.gmail.com>
Subject: Good Day My beloved,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_MONEY_PERCENT,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Good Day My Beloved,

It is my pleasure to communicate with you, I know that this message
will be a surprise to you my name is Mrs. David Hannah Wilson, I am
diagnosed with ovarian cancer which my doctor have confirmed that I
have only some weeks to live so I have decided you handover the sum
of($12,000.000 ,00) through I decided handover the money in my account
to you for help of the orphanage homes and the needy once

Please   kindly reply me here as soon as possible to enable me give
you more information but before handing over my bank to you please
assure me that you will only take 40%  of the money and share the rest
to the poor orphanage home and the needy once, thank you am waiting to
hear from you

Mrs,David Hannah Wilson.
