Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08B135F4926
	for <lists+netdev@lfdr.de>; Tue,  4 Oct 2022 20:19:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230051AbiJDSTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Oct 2022 14:19:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiJDSTC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Oct 2022 14:19:02 -0400
Received: from mail-oa1-x44.google.com (mail-oa1-x44.google.com [IPv6:2001:4860:4864:20::44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54D2D29C85
        for <netdev@vger.kernel.org>; Tue,  4 Oct 2022 11:19:00 -0700 (PDT)
Received: by mail-oa1-x44.google.com with SMTP id 586e51a60fabf-12c8312131fso17420541fac.4
        for <netdev@vger.kernel.org>; Tue, 04 Oct 2022 11:19:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=J/u7DVEXjJmIG7E07wTucPWE0DEZVNW1Zgg6U1VTcqU=;
        b=DZucEzQg4rd/R2rQfRYiNG8xzIFGzkQ+xHLY+JeVdNNAMEvuiDRo+WRZ/vr9fFsOVh
         8gV2V5PttaNSdcQwoEY57/BeiVqrOSxy9iFD8EWqkHrAj3qLIErM79UVC1f2WCUk8x5F
         uPdeLvfmr0U9NLISaGT4K1PgGuOOFYFBu79qIMWvyRpVp+THbkA5TxJhsqfyuzsoFYQV
         E+L5KAYa+NuFPbS6FcKLl8mGiRqRqfZ4JUG6/mjuDXtzVhQEGM94B1UB2vRR9N9oMRQ4
         8CO1DpISaB7U41Wll7EiLSI9kQelMc9LbfLtB8feFnMJvQ/gL9IRN4Z0zJyAS41W5J5b
         Qgzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=J/u7DVEXjJmIG7E07wTucPWE0DEZVNW1Zgg6U1VTcqU=;
        b=WhIoY4xXFawJdBUSgm8obQwGd/a3OLARDHQwhlWc3yyO4ZVxZ12f6Qm3fV+zF+dvLq
         5fq2H3d8lTMBDDsa+3joJ52QuGZTqTRUQ3sCEGIWgevJoVwnj0MELs4Eu+s9Oi1op/Ie
         9hohEPSRV6l/JKElxVPU5bcjmWbX9VHJG+tCAx1Ih6o7sfE0cLC2FNm+pGoGINMBWFPQ
         ZKEKjC28CXNKg/tQkCl4yZORzlgeIGs3npcK9oIk++OGaMsV/uuANRGwXRGbPW7SpCoH
         vSYF9omasIVJ7wmigq4alyfVIK5fO5Gpjb4Aiz8WSYxBSWw6YnWFOiK79hb+f6uLZKGj
         OURA==
X-Gm-Message-State: ACrzQf3zDfByofPWYhHeCAAWMsceyxkn4BnzkD9zMAiyI9XvpjeoDVrh
        jVGuMI8uFcYN0YL8r9VIELk+4ekG5MyS0ZF9btRK+A==
X-Google-Smtp-Source: AMsMyM5eYgJZ0rdYt1FfA/mNTnuOkQ439BsgHDHgbvv+i3JhcKSs7GCeRJ9scZeaNGCeY0vOQzdoffZxmx0OYeEljes=
X-Received: by 2002:a05:6870:390b:b0:132:9ca3:8dc1 with SMTP id
 b11-20020a056870390b00b001329ca38dc1mr590447oap.106.1664907539754; Tue, 04
 Oct 2022 11:18:59 -0700 (PDT)
MIME-Version: 1.0
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 4 Oct 2022 14:18:48 -0400
Message-ID: <CAM0EoMmZy1+VRTvpN0OYkOzdCrJ24hb1h2rz8XdDLXGp3YH81w@mail.gmail.com>
Subject: netdev conf 0x16 schedule posted
To:     people <people@netdevconf.info>
Cc:     Christie Geldart <christie@ambedia.com>,
        Kimberley Jeffries <kimberleyjeffries@gmail.com>,
        prog-committee-0x16@netdevconf.info, lwn@lwn.net,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        xdp-hints@xdp-project.net, lartc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The tentative schedule for netdevconf 0x16 is now published,
See: https://netdevconf.info/0x16/schedule.html

Last day for Reel cheep early bird registration. You get
served lunch too with that price ;->
See: https://netdevconf.info/0x16/registration.html

cheers,
jamal
