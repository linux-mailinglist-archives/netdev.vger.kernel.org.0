Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1260D4E95AB
	for <lists+netdev@lfdr.de>; Mon, 28 Mar 2022 13:50:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241440AbiC1Lvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Mar 2022 07:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241500AbiC1Lrv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Mar 2022 07:47:51 -0400
Received: from mail-lj1-x22b.google.com (mail-lj1-x22b.google.com [IPv6:2a00:1450:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CD865598
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 04:43:24 -0700 (PDT)
Received: by mail-lj1-x22b.google.com with SMTP id q14so18747145ljc.12
        for <netdev@vger.kernel.org>; Mon, 28 Mar 2022 04:43:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=xoSPbru0hWPpcXk1HoCSVQlCJx8nsIwdNqAcwd/eBCs=;
        b=FlYYD6ymBS4SUwSMWQmaVzug9XDH2yXQKG+U2Ho4NebTYq4q0gtQWRrjDGqJ/huCEV
         W3MOMit0g+tPwAEWMO9bMsSy3x9pgC2uF6HKyE4kp5THMUhrjF9hP+MFsTs15C9NXVrL
         l/YQ82Dpp1s/7C05NMIUQSDLu7lCuXeM7EJx2O6RWheTVb2Xice9wnJcI3PwM0H0/HER
         XTWi43OPzvEAmAiWE4CDaihXXNk+Z4poCtNqpzl0HbJixkIjiavbWHVyeuWzvtFETEf+
         r1I+PfV3j/P4qARNeIhTXOMYf0O+0L6x2kb98zDpmZs1fq4e6U0wCJoCGJjwxNgwQBEW
         tOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xoSPbru0hWPpcXk1HoCSVQlCJx8nsIwdNqAcwd/eBCs=;
        b=FTz7OBXgTWrDdmvzng1U68LYLAk5Msh6SD3DKS6qy4HOMFTj5BPkn+vXmuTSWSi/FR
         8IaCkpThDRPh3oGXQTM0MTvyLq9rHqt2QHi+ruHrnRjQuVUOfRb4wvbDVHHqU7bRFxfK
         JDyPvqMTyrA25cRxBF/AbT+HqDu5sm/yFFGQSFfBHiwuktAwK9T+c03GeoAQrTcZJi2F
         rqHG5drH5MFixoazhKbwVryJPBRScL0El8PCWXqmMbhPEQ14lLdfeWKDwwWUZOIgGSO1
         S/QB/hTTCEV/dxvxt0Y17BMtxeGBpgaNvCaSuoZa7/eyndKhRHkVVA5Tgjcfu/QhB5Ga
         eT6A==
X-Gm-Message-State: AOAM5305mBZGbs14lA70gI7kHKQAZlZEAQBWr4rf+WrZQ6vZGW87fygx
        lgJptM5DI4wkJMyVxE3vsDQxzyD/QDGW+JRhxXg=
X-Google-Smtp-Source: ABdhPJzbPz70K2VN3fOjw6Jau74UTw8SQ6Ywp1VzavUwsHxM0Ws1CcGMmgpX6GskHJgPvp6VFLwae1QdqtVxXPWk86Y=
X-Received: by 2002:a2e:bc12:0:b0:249:8daa:4de4 with SMTP id
 b18-20020a2ebc12000000b002498daa4de4mr20003149ljf.383.1648467802818; Mon, 28
 Mar 2022 04:43:22 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6504:285:0:0:0:0 with HTTP; Mon, 28 Mar 2022 04:43:21
 -0700 (PDT)
From:   Eleanor Taylor <militarybase6535@gmail.com>
Date:   Mon, 28 Mar 2022 04:43:21 -0700
Message-ID: <CAKHHXJa6zzVNWLKkx3TW0ofn4-N+SwWdPnq9w3qtYAmbbVvZwA@mail.gmail.com>
Subject: re
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
I would like to talk to you

Thanks
