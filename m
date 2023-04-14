Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C994A6E1A50
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 04:27:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229775AbjDNC1o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 22:27:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDNC1n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 22:27:43 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 339861703;
        Thu, 13 Apr 2023 19:27:42 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id sg7so53517912ejc.9;
        Thu, 13 Apr 2023 19:27:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681439260; x=1684031260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LUPkmahwi9aSFTJ9LkRAXLNicYu5DZ6TaTOzO8OiyU0=;
        b=fOTIgzew+q+bA2w3ZP/bRoXqbn2WLE6rLbispEtfDrM+nzDzQ7p8pVUQSvtFOc3vq+
         /fVtzLcDwYJrdbTcGBmHNq8E5eh45vGHM2QLX0n+1mTh2/X9aanPZs9BJrRdn6jx6VdQ
         EIGjmmVl5T6qCDSXH4FSlFwDyWnlZnrYixY/VghVrrLfznZOY+Fx5WaLhHByqDhiHQdR
         kp38Vm9qvCEic0XywYsLPuT3ZRd4p8ELbmfrb+eu9bvGV/eyz7TMnh3QgLWAaM1N1eUe
         05evTKuz/Z6L24LorYdXU8WpJ3+1cBY87NwF8t7efQUpM2eZBkEZNLeCvsvEpXSFmF+J
         ZkdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681439260; x=1684031260;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LUPkmahwi9aSFTJ9LkRAXLNicYu5DZ6TaTOzO8OiyU0=;
        b=Nj1YAjxDN/wYFT60t5S1ySxrHrP9vm5AnuirH89hiABOo2TTHL8AFLSwgolztwFxm3
         kbgXRVms8eyM8fbyIpGH7kVfDCK5A71C730700A2taYwXMCfr8WjzuaPzcmFg2yX89MZ
         vvWHDVn/JpLvUN81imb+abRVyzoWtovQtNNFVhV5Xu5dU/fhJiGi5NsI+r9/lFHvtRaz
         rhZm+Q5RKW+aLI08ZU2cDYPybUMmvue+/S4Iq0POPOrKvaEIG3Kpq9BhU83fIcVs6BQC
         xNDNmm5DP8t6jY9g9eA/oGYJeFLbRs5tGq8GAtMMwVheWQk9w8ZAviTq4/ALPYPnd+F6
         TAPg==
X-Gm-Message-State: AAQBX9fO9LVLhtW64aB1uJjOxDgXPIKoJPcExAu0B9gEI/F9ZG7kVPV/
        uh8TuFVeFFFO/ar5H0QiWFM=
X-Google-Smtp-Source: AKy350bE4s7WaPdYl30pjchV0zlBEPoaPN6ZhlqHlLv7u9IBOv+Wr0lPBKi29mdw4JNdRA4/SPgDyA==
X-Received: by 2002:a17:906:9a52:b0:94a:5d8e:ddbf with SMTP id aj18-20020a1709069a5200b0094a5d8eddbfmr4464468ejc.14.1681439260404;
        Thu, 13 Apr 2023 19:27:40 -0700 (PDT)
Received: from localhost.localdomain ([45.35.56.2])
        by smtp.gmail.com with ESMTPSA id o26-20020a1709061d5a00b0094e44899367sm1737617ejh.101.2023.04.13.19.27.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Apr 2023 19:27:40 -0700 (PDT)
From:   Yixin Shen <bobankhshen@gmail.com>
To:     leon@kernel.org
Cc:     akpm@linux-foundation.org, bobankhshen@gmail.com,
        davem@davemloft.net, edumazet@google.com,
        linux-kernel@vger.kernel.org, ncardwell@google.com,
        netdev@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH net-next] lib/win_minmax: export symbol of minmax_running_min
Date:   Fri, 14 Apr 2023 02:27:36 +0000
Message-Id: <20230414022736.63374-1-bobankhshen@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20230413171918.GX17993@unreal>
References: <20230413171918.GX17993@unreal>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Please provide in-tree kernel user for that EXPORT_SYMBOL.

It is hard to provide such an in-tree kernel user. We are trying to
implement newer congestion control algorithms as dynamically loaded modules.
For example, Copa(NSDI'18) which is adopted by Facebook needs to maintain
such windowed min filters. Althought it is true that we can just
copy-and-paste the code inside lib/win_minmax, it it more convenient to
give the same status of minmax_running_min as minmax_running_max.
It is confusing that only minmax_running_max is exported.
If this patch is rejected because the changes are too significant,
I can also understand.

Thanks.
