Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F603527CA2
	for <lists+netdev@lfdr.de>; Mon, 16 May 2022 06:24:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbiEPEYw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 May 2022 00:24:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbiEPEYu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 May 2022 00:24:50 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E20017E30
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:24:49 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id o80so5195264ybg.1
        for <netdev@vger.kernel.org>; Sun, 15 May 2022 21:24:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=FoNVu9KZbxtH3gu8YJMPZstDFbyET2efWMyc4F/b6J4=;
        b=fIJpHvvOl5Hl4Kh0S9RF6cbt3vJ1Xw58n/66PqrgBEgv8P2pc4hq00TwLcHMo0I4D6
         VbaNhXNmqa2c8rP8j69HbY1orkql4bjBhu82eUiifjcKFf9qE/Uc7XomeOx2AHpoQwY3
         Ccc/pfPFWHS4EPNYrFvqASdrGFoOuQCZvF9l54ZQbcSJLfakBapTnks2/Chpi1Lq1+sn
         gd4yQ9OIEXM8V/fr0tqkycbNNUzZzgyF7ijhnwgkj+cJZmZwgiEHNQLV74qhOG9tFglh
         Lu5JbPQ1exgnTiC6DPLLjfTl9ngv/BZNU859Kt1/rjffMhVZZUKvBsuAA2OSgF9ADBl+
         Q0Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=FoNVu9KZbxtH3gu8YJMPZstDFbyET2efWMyc4F/b6J4=;
        b=BrxNHmZVP3cpTeQSQH2bsYwPpF6Lt+uSHcBE/hcIh+fhksyJWyUEcVymWIfJGd1eF8
         92T0XLOZNBPIHu6PdlEov0dtqNwzwmzI72ZDiD08sbbEnV/vUAlQF2mjZmEd+upjOIB4
         9KDiq/zCa7nUVlSdBzPz3XfzVphIRpIrtn1s+B6SZgu8CnVp9tSoz6zUF9dxSv2oVNOj
         Vbw1J1KAi00oszKzKOPvC9DQsnB25W4d+HzRrSYbyKAlGUG5j2KjV435O8TSRFHoM9ud
         D/fPoJSwcq7L64JTP5m42gn5Sp7sM1B2ySA8W3do/Sd3fCgTW7wkTeXjVcFnlB8UPsem
         AcCQ==
X-Gm-Message-State: AOAM532GioJAMDo4QKZbgq3+Hw2lLITx1Ryw8KTvNwzN3h6GteJQiKEM
        KjHPndRwakbyPovt5VMbEFFMYd9Auump28TIbzQ=
X-Google-Smtp-Source: ABdhPJwOoOYuK4M4ElNXAQ/IrQeXrru6GzAVVQIjwS3mVBnB2rEUSD3LyXxlMKpabk4thG6A3MYkFrn5sSH0ZefxISU=
X-Received: by 2002:a25:5bc3:0:b0:64d:9c3a:4c59 with SMTP id
 p186-20020a255bc3000000b0064d9c3a4c59mr4392543ybb.292.1652675088846; Sun, 15
 May 2022 21:24:48 -0700 (PDT)
MIME-Version: 1.0
Sender: julianterry39@gmail.com
Received: by 2002:a05:7000:5147:0:0:0:0 with HTTP; Sun, 15 May 2022 21:24:48
 -0700 (PDT)
From:   "Mrs. Rabi Affason Marcus" <affasonrabi@gmail.com>
Date:   Sun, 15 May 2022 21:24:48 -0700
X-Google-Sender-Auth: 2upY-n_8B40UDeDmaNTOoVcip98
Message-ID: <CA+Kqa7eb0B1NaxbyCEMHC7XDDvPym43L=eU71qptMQRjr10wDg@mail.gmail.com>
Subject: PLEASE INDICATE YOUR INTEREST ON THIS PROJECT FOR MORE DETAILS.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,HK_NAME_FM_MR_MRS,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,SUBJ_ALL_CAPS,T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello friend,

Good morning from here this morning my beloved, how are you doing
today? Please I want to confirm if this is your private email, I have
something very important  discuss with you concerning a Humanitarian
Gesture Project that i need your assistance to execute, so please
indicate your interest for further details.

Mrs. Rabi Affason Marcus.
