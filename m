Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC926BAB25
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 09:51:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231845AbjCOIv0 convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Wed, 15 Mar 2023 04:51:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231871AbjCOIvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 04:51:08 -0400
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6662C5D47B;
        Wed, 15 Mar 2023 01:50:34 -0700 (PDT)
Received: by mail-qv1-f48.google.com with SMTP id m6so6512083qvq.0;
        Wed, 15 Mar 2023 01:50:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678870233;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6eK3lv3XmGf5e0hSe7nNdyGKzby4aQeSuaY3l4ZaQq4=;
        b=DP9W51eH4Ke/Y/xuVxwrfykbFn2AittAzuE8c3j89Rwt36Zf8Eck9IXWrEbSRrd1JY
         4lZ1Vs+qU4n80ZOlPKep2cmzv5KYQjbW/NbP5TCL5xQb2xEgemMZldGQNS5hQ48GEK6H
         RNBJF/dc17/CEwHxcx1kEuC1/lUeqw7Wf8wrc5Ft3sPcxWAsqRw0eNCVZa/qFADk5yW9
         kv0ekX8kTKlbZnrqTbSFHQuQlKP0VFNaYMU3KWRXndSoXb50qVVr++4G0KRVOY+2SwXr
         rrYwg1HNJi5MTkafkzix+429LvQ/flv/e0+Ii9U3plQWWOd1gSvoRCwl+M3m4pE1veDc
         KqSQ==
X-Gm-Message-State: AO0yUKW7Qti8E3I3pSRce+v6haTMTzWq1RwOdoW89LHEVHi5FMgVz6DQ
        /n2KVHJHG6bWC4uHmozml5lQ6NVPpODcErov
X-Google-Smtp-Source: AK7set8dRPrrl3en/Mf9crpWwlmhMvVpriUeSdP2zeNmeXFHlYiO7j914GVUot1R+YEjfBppKkwDZg==
X-Received: by 2002:a05:6214:b63:b0:5aa:9502:4ec1 with SMTP id ey3-20020a0562140b6300b005aa95024ec1mr15063502qvb.49.1678870233417;
        Wed, 15 Mar 2023 01:50:33 -0700 (PDT)
Received: from mail-yb1-f181.google.com (mail-yb1-f181.google.com. [209.85.219.181])
        by smtp.gmail.com with ESMTPSA id z201-20020a3765d2000000b00745c2b29091sm3150302qkb.93.2023.03.15.01.50.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 01:50:32 -0700 (PDT)
Received: by mail-yb1-f181.google.com with SMTP id e65so9687766ybh.10;
        Wed, 15 Mar 2023 01:50:32 -0700 (PDT)
X-Received: by 2002:a05:6902:724:b0:b46:c5aa:86ef with SMTP id
 l4-20020a056902072400b00b46c5aa86efmr2687476ybt.12.1678870231794; Wed, 15 Mar
 2023 01:50:31 -0700 (PDT)
MIME-Version: 1.0
References: <20230314131443.46342-1-wsa+renesas@sang-engineering.com> <20230314131443.46342-5-wsa+renesas@sang-engineering.com>
In-Reply-To: <20230314131443.46342-5-wsa+renesas@sang-engineering.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Wed, 15 Mar 2023 09:50:20 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWhKfw93Fyukr=kguMAmZCnynk=-96+BKBPB8PDZkE9gg@mail.gmail.com>
Message-ID: <CAMuHMdWhKfw93Fyukr=kguMAmZCnynk=-96+BKBPB8PDZkE9gg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] smsc911x: add FIXME to move 'mac_managed_pm'
 to probe
To:     Wolfram Sang <wsa+renesas@sang-engineering.com>
Cc:     netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        kernel@pengutronix.de,
        Steve Glendinning <steve.glendinning@shawell.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Wolfram,

On Tue, Mar 14, 2023 at 2:30 PM Wolfram Sang
<wsa+renesas@sang-engineering.com> wrote:
> On Renesas hardware, we had issues because the above flag was set during
> 'open'. It was concluded that it needs to be set during 'probe'. It
> looks like SMS911x needs the same fix but I can't test it because I
> don't have the hardware. At least, leave a note about the issue.

You no longer have the APE6-EVM?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
