Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01D324CBB58
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 11:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232343AbiCCKa6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 05:30:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231392AbiCCKa5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 05:30:57 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98548179A25
        for <netdev@vger.kernel.org>; Thu,  3 Mar 2022 02:30:11 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id f38so9284774ybi.3
        for <netdev@vger.kernel.org>; Thu, 03 Mar 2022 02:30:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=k6NYZQl2rxZhVB/aKDQvMsV5vW2gUENZyGD3qWaMtBI=;
        b=laI23BgcZDhcP/9hP+X1hN4Z14KZUKGolqcmzFNHfC/QP77+/OCeZliYYDIoDxHIhq
         Er6kZ4beuigKECI77wyuP8XEZwNksjnAyFqNiOR7p1P+T311fTmdihj9HOMhuqdD6RWZ
         JtsBDx5EBlsmMT7MLsvDi1fF1zISaIlPX3Hj6dBeq/0S84+J7KtEZ3daFtE8U/6exz/1
         bJCbcWr4SnHdNiEu2v/nHIB855YWAD85bmXyz2TbZgNxpF3w26gm1WP/DrCb9MDtkB4P
         pVfCYprDC69SaXck8MTcHOC1fxM7Rj1UquaWXRYcS7WZHs0iydCd7TiRphLYJulRp6c6
         WcHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=k6NYZQl2rxZhVB/aKDQvMsV5vW2gUENZyGD3qWaMtBI=;
        b=iLhTxZFQPk9uYZaSNwGpalk6JwMk4bl1X3RlvRI4+GWinFUQYG/TrgiXYVsTLBK8JX
         zaRBQ876YN4pQBpUvcvuzYI1wwi1mdBsBKFAtZcQwfQkPBZ95cQ+Vk/m+YwwPvF3rsyD
         tcR1nWkQj+Cu6EMWQCE1bd1bjT3L5bZjHjD6cHSwvSUuTpoowitViwJuvBCCtS3fQfM4
         9Mn+MAZrjk0Mxl8dGBwP3nwBrJjnZO1H6GTl8Ph4jKGVE21f2YoWQI7rByq0TTKwPLVX
         3Md9x8Whas7UdwnSopjo89K+OzEi8VpVZlZ8nZ/dSeh9e/LChx9VJ4K1xiolSPHjXcKB
         kRMA==
X-Gm-Message-State: AOAM532rTJmjQAhhiz2t6IIQA2a5LI+KCMt+zrieIayxXLeFWDMeZwMY
        R0e0G2wjXL/+YulzOm6wQhjWGmQd/Kyq30Keb5bP2Lk9
X-Google-Smtp-Source: ABdhPJxEBxT1/3gEl0Cmj58oRDigp0Sxrtcf/ZvyRdaOy0OJ8lqfzAkUQOs+16l4KSHCIlDpuNxUChHdam22Ke8yKOY=
X-Received: by 2002:a05:6902:1506:b0:628:7962:6682 with SMTP id
 q6-20020a056902150600b0062879626682mr12156012ybu.59.1646303410821; Thu, 03
 Mar 2022 02:30:10 -0800 (PST)
MIME-Version: 1.0
Sender: edithbrown0257@gmail.com
Received: by 2002:a05:7010:cc8a:b0:210:741f:4d30 with HTTP; Thu, 3 Mar 2022
 02:30:10 -0800 (PST)
From:   Rose Funk Williams <rosefunkwilliams02577@gmail.com>
Date:   Thu, 3 Mar 2022 11:30:10 +0100
X-Google-Sender-Auth: MDLx6wFUgHexXojOEAxZtWZA-tk
Message-ID: <CAEbKRu2pY9b+z52qm=P3Z9KDRnN0bqW+LYqfTC3_jXAPjnO=LQ@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-0.5 required=5.0 tests=BAYES_05,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

My name is Rose Funk Williams, I will be honored if we talk and know
something about ourselves, share pictures and life experiences, I look
forward to your reply, thank you.
