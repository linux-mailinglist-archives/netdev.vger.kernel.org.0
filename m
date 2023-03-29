Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66C876CD603
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 11:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjC2JLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 05:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjC2JLH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 05:11:07 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E77CF1FCC
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:11:04 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id h31so8860777pgl.6
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 02:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680081064;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QKJ9KBgedySRjL3dvLGW6fxF1uoFaulO0VdxYq1EqpM=;
        b=olvlLltx50oGVbmfeJjZpE56+8MLn7h2asJ3a8I175rXfcZ/YRoAYvyNHqCiR5jM5v
         E0axNhHSI3mNrDNUsDwwpFHJxtBnRByPgpX+W+N8lfXm2FuYa6HLjHQAaqbR9+gkQyTC
         AW7T0aCueJ++Uwrm4KdEYx/xL4V7rqaDZpJ3/WTPjm+jXXyD7KOchDyrJ213oD0JV6hn
         gReL2xWQweM78z2u9aT2HMlDCOpiwkOeuGhtLtmQsjCUaK+z3vKOwo0L27NypWBlFI6X
         7XIhUVKuBFABDMyrSDj/bSeYGdAm0+SihjbhapPalDl33d+VT72Z7y0ZaFDqlSGZyU5J
         n/Yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680081064;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QKJ9KBgedySRjL3dvLGW6fxF1uoFaulO0VdxYq1EqpM=;
        b=hJgjlPXR4IsAWj3S2GT/e1dUi417pXHa41yPRje7Gmy4+boGWZqmUpZmXh4X1Nz1oo
         yP/yofnvGOf2/YdS6VX2FMU4dJd4CqhROav6iwjvTgbQFNwOr19LaJEGdnQrOpf2BMeZ
         wnTFKXMncm1fYpAgV6wrrPzCw6n2UNhBERY2eJirvkPdFqHyKs8qFo+Y+tN3WeYK4x+b
         hRH7PZ6/8ry8goIRVg3Ztt8P7Z+T64Ta/w3whrpVzq4Q6FY0xIXipTkHeklI/T++c94v
         u9BMUnDqGOES7GBM7eA4mXe/IrQsHEgeEABWe7hykG5ylNE4l84AK9/YqFZa/U9AreHX
         Phwg==
X-Gm-Message-State: AAQBX9f1v1RibXOgBgaNrSn9PQMESPq8MWQT/7A45SJBoT66XJaLAp64
        wwXZImhfSe42viQ/NPYPczwMlrNm4zKPB91oZRg=
X-Google-Smtp-Source: AKy350Z7noJmGSRLilbh5If13Wlc2aU0PPqJqXsSo/bAt4Qx+0aVlM6F0eNUthgSIobSDHX+QThepZ5Dxj3wp/Ogibo=
X-Received: by 2002:a05:6a00:a14:b0:625:66a9:c393 with SMTP id
 p20-20020a056a000a1400b0062566a9c393mr9975823pfh.0.1680081064404; Wed, 29 Mar
 2023 02:11:04 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6a20:6617:b0:da:5e11:4e95 with HTTP; Wed, 29 Mar 2023
 02:11:03 -0700 (PDT)
Reply-To: fionahill.2023@outlook.com
From:   Fiona Hill <rogerpakayi@gmail.com>
Date:   Wed, 29 Mar 2023 02:11:03 -0700
Message-ID: <CAL0uRZA9tRdLcA_KMP3g5zgAK8uY7uiH6VduRPyTh2-7yD8LJQ@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hi, please with honest did you receive my message ?
