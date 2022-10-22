Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4801A608427
	for <lists+netdev@lfdr.de>; Sat, 22 Oct 2022 06:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229514AbiJVEGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Oct 2022 00:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiJVEF6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Oct 2022 00:05:58 -0400
Received: from mail-vs1-xe35.google.com (mail-vs1-xe35.google.com [IPv6:2607:f8b0:4864:20::e35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06A224CC21
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 21:05:42 -0700 (PDT)
Received: by mail-vs1-xe35.google.com with SMTP id k67so3092852vsk.2
        for <netdev@vger.kernel.org>; Fri, 21 Oct 2022 21:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=sgSlvmTeaG0OCkAcDyIqwnaAzPEkEDoRdar+JyjRcaE=;
        b=E2sPpAOxxBqLD69viIR63WGpu6U3P378cRSDGs1TseElZ5UPSqJDHPqsk3QILnOVZY
         cXKNexPyslo3sR3kwTod0U256UQWgsNSM2orN6X31avTcmCCskq4cH6/iCNox83p3rZ6
         TksJsXw/NUWjKM9jZWnKvmQFLb/e1PCl7Rg0T7O37yqiWWaB30fguYbudcxufiKB+CID
         wmwDWVPgoZz6RGLqcg2aomBaoQ68AVEDiMR+ORL0KrPzrsAlPJt9qVLWt7AgrzhOkBg2
         d5Z/kLrwS32SkzdX35El6YXmWC+X7orK0QB+E/rm/dm3cKWA0HDFbHoA1SFhuZnd8l8n
         voLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sgSlvmTeaG0OCkAcDyIqwnaAzPEkEDoRdar+JyjRcaE=;
        b=utTNGT2rznVFSjmrkKLduUqdNLFklwVG5vHjzWhoODY7GnxAkKRfIZEdaWsiW0/qvS
         +NWfDTlF2ibWCOslROVKvqm3NAay705bHbu1yFXyaBMhZomLDHPD7KruyrUsdqVe5eG+
         4cyOqZMMJHgGZKD7M7OCWE9uOPnw50JNYffFv0iiN4fLxeOK7h2Tbi+KuLy8ndPkUtO0
         JbWRACm9Nfha/qRCnOL4UyVr5HJKk7VdGEB8DDkjBUdtWaGVbVpCBAKrG8ozqs/3UXuk
         42ZWuqzbYLEXEkX3XMDyFDZdbVkoJyzg8ap3nheRykyyRihjcbpqpYH4axZlkJSGetY6
         6uMg==
X-Gm-Message-State: ACrzQf3AIPOfJ9OmqwJdNS2uIWNmTQNnePso2PSCvNuEWgOErdUQ0fkD
        jCJbBBSZMBn3fJPQEoRcPoHgKS4QoieATGekN70=
X-Google-Smtp-Source: AMsMyM5/gTM9z0GM56cSCs3i65UphooR3JC+fp/h9CrC4Fflt4nfkawKB2/uVt2KnYoPVP8fih7hilzY6ZLZNeNzh80=
X-Received: by 2002:a67:ea07:0:b0:3a7:86ba:ef76 with SMTP id
 g7-20020a67ea07000000b003a786baef76mr13740334vso.44.1666411540926; Fri, 21
 Oct 2022 21:05:40 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:b6e5:0:b0:310:69d4:6368 with HTTP; Fri, 21 Oct 2022
 21:05:40 -0700 (PDT)
From:   Fogan Edeh Amevi <edehamevifogan@gmail.com>
Date:   Sat, 22 Oct 2022 04:05:40 +0000
Message-ID: <CAA_QD1vApNvVbAEp+PR_Q-Feat8rsrdPJeOygVKEo+Vv_Tys1Q@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=3.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,LOTS_OF_MONEY,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: ***
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Dear Friend.
If you will be honest,contact me for Charity Donation Of 7.3 Million
United States Dollars.
Remain blessed,
Rev.Fogan Edeh Amevi
