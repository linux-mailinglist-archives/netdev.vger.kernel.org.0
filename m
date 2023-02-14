Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4398F6965B3
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 15:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233051AbjBNOCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 09:02:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233187AbjBNOB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 09:01:57 -0500
Received: from mail-yw1-x112f.google.com (mail-yw1-x112f.google.com [IPv6:2607:f8b0:4864:20::112f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25AF929161
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:01:45 -0800 (PST)
Received: by mail-yw1-x112f.google.com with SMTP id 00721157ae682-51ba4b1b9feso207252227b3.11
        for <netdev@vger.kernel.org>; Tue, 14 Feb 2023 06:01:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mmAvIfffgJ+kIIWWq31MGXBQ8K/UsJ05Yz8C5lYu4uo=;
        b=bkhcM005y6sc7fgEoGTbJLV+fNBz3/AKHiOUDMyRzT/v/RQSOZr2nkie9UnLE7pXJF
         gszpLyfHJNFl8OXa6a7gJmkKEggbWAFqIXPktzX36KMty0m8Ibr/UutjxWqQkYElmf0h
         jxg01GY7SuX8cetX07gQcIMfka0ZoNveAHZEzHOWY9mTgzsV7eKnr2Ik0wF5qF/PNAKf
         xteYH4RdWDQ5y1kZPeaEJRkT+Hi5Sgc6+8zH1NEOLEqZMwe3ubz78SQXIjU7bA3xU3Zi
         DDL+4vic8wVFF1JGEgP2mWxbwvTCb4dg4wcYzxytapxV2XfGgb7xEbxTHKAOAnY+eBSK
         TaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mmAvIfffgJ+kIIWWq31MGXBQ8K/UsJ05Yz8C5lYu4uo=;
        b=MmvLom38TlKhV6FuGfFcXLLJ0xz/PZg+xzJhEzYiotA50kWQiP11CTN43d3RC82+Ht
         saFm4Z3ariREFVjboawzvmcfW/8BDZZ14oeeWzzOcH49XCGQwrAteYTDO9uOtcj0ycHv
         J4+LyUGMqjnqmirsMxwEOHkIDW0aGtppVm69wQ6OSit3hO6gftJJZMmPZytN4c8oiX7J
         qzGaAyWX+LQEWD30jRhXLCFddlb7opI4slrQyL7n755Lz6Nr7FwQ/XmN2mAezYWekvbt
         U84A4FhrMIqwRqvSd9KRzZ/VUeGb6f3aX6GExYx4fF0cYROuomOEyOtbUltkeFIQ2Y9L
         SYcw==
X-Gm-Message-State: AO0yUKU7g/wjv6X9JpFjcC2PTmGadIzRlMaA83w7ySfIs+hzpbC9IU7l
        FvqJ6z2pV1CmxCSlWjdMpYoUFYSPHvSNXCiLs2rBT2EiKw0aBevh
X-Google-Smtp-Source: AK7set8IkH/AU+CF2wOmlzMarWMZhj5GvrEJ10t/1NSXC4n/+MTiB6bM16u6KOYG2zE7aqDhf9Rfx44PaslNq6WfHNA=
X-Received: by 2002:a0d:c6c3:0:b0:52f:2ac0:384 with SMTP id
 i186-20020a0dc6c3000000b0052f2ac00384mr211996ywd.441.1676383303658; Tue, 14
 Feb 2023 06:01:43 -0800 (PST)
MIME-Version: 1.0
References: <20230214134915.199004-1-jhs@mojatatu.com>
In-Reply-To: <20230214134915.199004-1-jhs@mojatatu.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Tue, 14 Feb 2023 09:01:32 -0500
Message-ID: <CAM0EoMmfkjFvD9hyaQryEn-RFyfAiYBDCKpJXr3uZpQ=PTA5tA@mail.gmail.com>
Subject: iproute2/user space code obsoletion when depending on kernel features
 WAS([PATCH net-next 0/5] net/sched: Retire some tc qdiscs and classifiers)
To:     Linux Kernel Network Developers <netdev@vger.kernel.org>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Refer to: https://lore.kernel.org/netdev/20230214134915.199004-1-jhs@mojatatu.com/T/#t

I dont believe this has been done before so some introspection is needed.
The option seem to be:
1) Delete it from the iproute2 version that maps to a kernel version
2) Keep it around and dont bother syncing specific kernel headers in
the next version. This would allow newer iproute2 to continue
supporting older kernels.
Additionally, add an ominous message saying that the feature is no
longer supported in newer kernels.

cheers,
jamal
