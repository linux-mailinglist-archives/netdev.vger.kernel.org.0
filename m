Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3F8648319
	for <lists+netdev@lfdr.de>; Fri,  9 Dec 2022 14:58:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229678AbiLIN6F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 08:58:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLIN6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 08:58:04 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 876A354778
        for <netdev@vger.kernel.org>; Fri,  9 Dec 2022 05:58:03 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id x22so11656432ejs.11
        for <netdev@vger.kernel.org>; Fri, 09 Dec 2022 05:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=ZVU+uyhDoT8pIb1X03M0ESfUPmC3CnmEPTMWVzgSmaJDCIpvWs87zezSwRI2pwNqwe
         AD31nV42FieqwbyAyc8kvnSVw+1fmcj22yS7vdbf1+mqxRKMS+7iAQXJKNAe2V2fswwE
         MxzdPzRVv+BTlJ0B6vojq8hjBZHlGdFwZw4r0G1cK6eIHU629sZqWEIDKVOqaSxLW3Ty
         bkKSFh5EN+zZH5TchoCQn0eTo4pWEU4EG/kK7w9HgP18MmeINh6fC0P6qUroZX3Xv3G1
         76QeVIYhayxzDKsFx9YSN3JxqLP5x3rFmnf08M/D7HdQrOBBFZAbzBn0+8HSS3qATsYG
         4tiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ddKdS4x8c4ZSI9PbKdla4xMHlbecpUYnHnf7KqPY/v4=;
        b=sv+ny2f+To2Mka4dDsc9E3i12mf4MAcnhPc8/tM+f62dMa7Fb5j1GZ1jCz09LFO8S8
         Hvqsh5FUtO7pgCKenfhvEXIHVm5f67DEBV75evwASxAq71OIe8nG5cTbmzOgvNYiroJl
         oeDFsytg+SJ5FH/4QRKTLTYfUyEg8yNkRioj25SwIi5VeOaLBXAsADE6dQgyU5YOm1Nv
         ug5IDL7CS+Up7S5WLOIZ2OAPnEy1gsrCPIjOPk/kvvEaBjspyA7ra+UQC5k02nbgc6nP
         DwA1DaOFsljl80q0ODSRvBSLW5vYnDCkILWnl9ve24+lHK/UHq8rKw+9xakdldZSY6t8
         jKSQ==
X-Gm-Message-State: ANoB5pkJLbKVD5iPfDAYXNZVYBaY50BT4labUisR55deuDO0ivF4C+H9
        tFbp/HNctvg6foTUHnhSzr/SGZ2T9H6f5g0DrAQ=
X-Google-Smtp-Source: AA0mqf50Thq4zhXNL21tSiWwo7lLz1I27+mky3M6tw/M7V3JKU1m+J3Y8DtSJaOyEjRR/0DkDvktHXJM/8crqmtqoJ4=
X-Received: by 2002:a17:906:4087:b0:7c0:e6d8:7661 with SMTP id
 u7-20020a170906408700b007c0e6d87661mr15656036ejj.242.1670594282100; Fri, 09
 Dec 2022 05:58:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6f02:3a9:b0:27:9bd8:6acc with HTTP; Fri, 9 Dec 2022
 05:58:01 -0800 (PST)
Reply-To: subik7633@gmail.com
From:   Susan Bikram <sokportina@gmail.com>
Date:   Fri, 9 Dec 2022 05:58:01 -0800
Message-ID: <CANEE7CpotYkQWXrS+rxph6cbFz3pLFNrGPB1KHpKPegXoa+aOg@mail.gmail.com>
Subject: Please can i have your attention
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear ,

Please can I have your attention and possibly help me for humanity's
sake please. I am writing this message with a heavy heart filled with
sorrows and sadness.
Please if you can respond, i have an issue that i will be most
grateful if you could help me deal with it please.

Susan
