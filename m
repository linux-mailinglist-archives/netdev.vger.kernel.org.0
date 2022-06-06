Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9D3F53DF20
	for <lists+netdev@lfdr.de>; Mon,  6 Jun 2022 02:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351889AbiFFAre (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 20:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348528AbiFFArd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 20:47:33 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C8913F47
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 17:47:31 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id s6so20944250lfo.13
        for <netdev@vger.kernel.org>; Sun, 05 Jun 2022 17:47:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=kkaYniS9XFBDWY/0lTJvjoUPr9zsvRoP5elHu+vjI7s=;
        b=mmxnXzKrQkYDScWtes8/3Uc+4GxYfIg+/4cARCWCkc922frWHocOTkMPE+PxDyoPWX
         3mTccVKca6w8mcS5/if6PZ+A1VloQOWyTUF3ynsjGpNoKfin3ohOhMRvZq1R90ukbfio
         ffw5rZGjuYkEhfCunfj62xKKkyHUsBdQ4OELBi5Het7aspTtBSoW+DPLRwghTJ8um1W9
         ZpJR4Ax0UrKekWX4qFW8r766ql78oMFxK0XD4qHQk/nPfkFwn69csKcwa77ZSguGPUE3
         w00C0sNd2RzxpZMI3GASXH3LPVJUq85y2BoA2Mffc/yYtsCtAjiEw2XyluTMkF8hGBmW
         gR+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=kkaYniS9XFBDWY/0lTJvjoUPr9zsvRoP5elHu+vjI7s=;
        b=xE/EFUHv1wT0aVQ4hYiMBPxY/FRzqoCoxUEoOnVk3FNZzupnWpttF9w7Q0Nn044nRY
         bc4tmhTO44v5FmGNAnHXwex2Ss9j4+aisISBozBMEnejWYJvwNIGSG7wNTjkZGdw3MqI
         c+RVDVs9ykaso+iX6U6x8zftZDvzb2bsf4CXWa4yzUG9G2VrffrkPkoo4f4yZ3qA9IWh
         jHAJvvXxmCjRQO9ovmztl1ssLMjjQXqRidQYkSmSUzHeujLPXJXlJa8RZ1kPfBy3kvSF
         z0H3qRC3nXXiZuRHjKQSw5E7YNxfBjU29cumY4zr1XkzRfl36MOsqEWf8CEcYaT8pw9t
         FW4A==
X-Gm-Message-State: AOAM532Gz8uX/ox0Nlny4O/q6S61S/kzJL5O2y159UIK+5iWNxgMBupH
        45VOaSNM3ooY8rEjqWnvm+KnUcOl1oxuDvqMhps=
X-Google-Smtp-Source: ABdhPJxtitzBvAC3sRWQBqucrGqg8LEg58jcWWg7P4neHUnpmHcO5xlpTOz6R5TFRs0NVp5dLmLPa5f9IxqC/9OPWTU=
X-Received: by 2002:a05:6512:159f:b0:479:40e9:2945 with SMTP id
 bp31-20020a056512159f00b0047940e92945mr2629792lfb.95.1654476450172; Sun, 05
 Jun 2022 17:47:30 -0700 (PDT)
MIME-Version: 1.0
Sender: juliebkt10@gmail.com
Received: by 2002:aa6:ca09:0:b0:1ed:f5c3:67b5 with HTTP; Sun, 5 Jun 2022
 17:47:29 -0700 (PDT)
From:   Bella Williams <bellawilliams9060@gmail.com>
Date:   Mon, 6 Jun 2022 00:47:29 +0000
X-Google-Sender-Auth: mjkVYVlBC17VOjj_L_UySROiKJU
Message-ID: <CAGw07jLS=cM9RRqgG2DQed5unyTfSUe8MKvL4=EG+DHnABbzZA@mail.gmail.com>
Subject: Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear,
how are you today
My name is Bella Williams
I will share pictures and more details about me as soon as i hear from you
Thanks
