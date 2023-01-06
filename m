Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99951660955
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 23:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235708AbjAFWLg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 17:11:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235610AbjAFWLe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 17:11:34 -0500
Received: from mail-ua1-x929.google.com (mail-ua1-x929.google.com [IPv6:2607:f8b0:4864:20::929])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E077A85CA3
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 14:11:27 -0800 (PST)
Received: by mail-ua1-x929.google.com with SMTP id d14so632716uak.12
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 14:11:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5Yt8EHAL82AW2pIu1Df2UQ7Stz46vSnaDUHJvWI9NM=;
        b=Vzux6YYx84yDsFF6awU4uybwE8dYKzNboqTUk4OZpPOrM10j3BmCflZHiB0zyIbkr3
         MLmuFpZVFow4Upz896vi+uU2wwkKbY52xZlFDuTdn0P2XcB4VwZ23m1tuFp50Ceyw5r4
         /pJIxP+KVef6OwlxPUw/1cUseSWc2kMdnafpdR0uj3nde9Nj7WMs8TzGqdPtWugLKtYm
         06ka09YEcPgnlQo1dQqNk8F1e0JKnLljM0TF9v/M66GdXJtF8vqA4GduPZJD5pj87BP6
         NAmA/2wJYweEZelCnhahahExV6W3W1YJmb2jAvtebjqAoEV/RoW8snPU/3PDURBq/Wj5
         yOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=W5Yt8EHAL82AW2pIu1Df2UQ7Stz46vSnaDUHJvWI9NM=;
        b=NwNnJeMiwLY8e0VBdoeI4JQvGnw8thjsWEzlNRD6m3qlKWLakHrq4qCMLGqMSc7ybC
         SAnP3l/KQ1/rCrG12TIcAxWVenDrWc7ZFAPhz+eTlUJ5RWMARrNo2cjEEnngvzvA5BZa
         59BZzuQ+ICkidyXfoTC5TagfhZlLfsVp0xOEb8X68J6BPV+pch/LlYdJLVLYndWecXh2
         i65y9Qjl3k1m0Gm52JLz9Q8adRtD6cTc4EsSrX8rtBYnIUTUU5gmC7BedFYAYKrWTjBp
         J9rYo0RtZ0f8SMG6MfOpHXroRMUJXfIkBVEHTSCU/WXQhN7z2Jb7v2kwBbFi/EviBNJD
         IrJA==
X-Gm-Message-State: AFqh2krB/UgErMPKbymrQBGRrbQ9c/NO8pLLsW0JACkQSqCTfubYOnd2
        PPUhQ4TCwLSeyAbLJPov85VQpNCQrcVhlANgfNc=
X-Google-Smtp-Source: AMrXdXsDaWDC2DoweYtBMBNz6oyPUdHBl8oZ44Nbx9g8rPZgqDJplB7zzRBi0h2bfGuF9e5LucJOb2P/B31g2uyLn4g=
X-Received: by 2002:ab0:1e82:0:b0:419:cb7c:e6e7 with SMTP id
 o2-20020ab01e82000000b00419cb7ce6e7mr5372017uak.110.1673043086920; Fri, 06
 Jan 2023 14:11:26 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a59:b591:0:b0:335:27b0:f0f6 with HTTP; Fri, 6 Jan 2023
 14:11:26 -0800 (PST)
Reply-To: loralanthony830@gmail.com
From:   Lora Anthony <tonykoffi200@gmail.com>
Date:   Fri, 6 Jan 2023 10:11:26 -1200
Message-ID: <CAP-gqrW77-FwGPdrUneq+8J8h8Sw-m0CqQA96v=XraJgzDW_og@mail.gmail.com>
Subject: Lora Anthony
To:     loralanthony830 <loralanthony830@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.4 required=5.0 tests=ADVANCE_FEE_4_NEW,BAYES_50,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

307 Birch street
Skellytown,TX 79080
Phone:+1(219)237 4122
Date:6/1/2023

Dear Ms,
My names are Lora Anthony from Texas United States of America. I am
the lawyer representing Mr. Oleg Deripaska(metals mogul) from Russia.
Based on his directives i am contacting you for the repatriation of
investment fund (USM6 Million) which was stuck by western sanction in
a Togolese bank

However, he needs your assistance in the repatriation of this fund to
your country to enable him to continue his investments aspirations
hence the money cannot be allowed to find its way to Russian economy
because of the severe economic sanctions placed by the western
governments.

Note,30% of this fund goes to you if this offer is acceptable to you
contact me on the below details for more directives.

yours
Lora
Phone:+1(219)237 4122
Email:loralanthony830@gmail.com
