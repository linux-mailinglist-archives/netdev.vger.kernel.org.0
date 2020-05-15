Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF951D4D10
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 13:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726217AbgEOLvV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 07:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726168AbgEOLvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 07:51:20 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F104C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:51:20 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id y3so3241798wrt.1
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 04:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1Qi6+8SsyzD+hzN/dOwp1cqr8she3a28Ll3mCA0EkGw=;
        b=xJghP50eEDJZZuEWNdZhQ8eAZGIBbNI0GxrXJeNsCRR9T6TxY+tffuHBOgy5TXteIf
         t2OvtEo4NfRwW9rv8DIfchEYQWxHQFGmzDfMRLoe2QCPVpCDtKHNCyvNDUNNr61rQZx5
         ZdysUMpfbVejb4gxaEptlwbqIkbCbL0kOgIflj7Ttq5Fv2tRSgvh7qk9IDO8QdbcrLHl
         lMVFTgjde8J6OVW+iVdSkTKS2KomJbWfvlZMERp2pnqUJYhUyHVzef26w3oQm63gctzr
         MYuKqhmo/G25kyT3PM7gdNqHI1eaEdn75dnlVINCKWVvt6yE0P9emG3ZdqNanwPjMLBW
         T9Tw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1Qi6+8SsyzD+hzN/dOwp1cqr8she3a28Ll3mCA0EkGw=;
        b=sXXea6va2YKw25Tv999bfKxLL9LqzgfwRStYexAwE1SGUi7PRp2Kcl8T1MZmt6DDou
         0SW5GZSM36OxdP7e5D732c7pejmxu5mnFfF5SiPjhfSIYyhNx9BdZx7e3Vg1rYxnYYqo
         ZYmYR76R6jdk2VMTlqG5FS12Zjd4BQo4eHb1LwWleaSleMPPpWu/HqzkOal4p/sVddtP
         qxhqGT4s7urw2vsN8M7ITVo6hhTZHhBFlOzNmfrEHmGY+mI0wS1md9Likeb8Ze36cES7
         F4Gh4qgVP4TtHFb8arMe59eDX2HKiYwIW7124jN2a/H3Xtb1o+jeZbEYjJK6P1ymFFlq
         S9DA==
X-Gm-Message-State: AOAM533DPjY3PDz5C2qOLaZ/HKGFvTXq4SlzvAeSwPW7InAsiIY437Bi
        J2oaBFIzDQSRVZOmgZoNkriH8g==
X-Google-Smtp-Source: ABdhPJxEOdIqEok72FHoZnpoHq3veRvOh2HxIU9TXduozQcLJQoHQTAqV/wKYfZLoXYXXpkxnaEE2g==
X-Received: by 2002:adf:8483:: with SMTP id 3mr3926190wrg.206.1589543478881;
        Fri, 15 May 2020 04:51:18 -0700 (PDT)
Received: from localhost (ip-94-113-116-82.net.upcbroadband.cz. [94.113.116.82])
        by smtp.gmail.com with ESMTPSA id p9sm3335411wrj.29.2020.05.15.04.51.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 04:51:18 -0700 (PDT)
Date:   Fri, 15 May 2020 13:51:17 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Vlad Buslov <vladbu@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, dcaratti@redhat.com,
        marcelo.leitner@gmail.com, kuba@kernel.org
Subject: Re: [PATCH net-next v2 1/4] net: sched: introduce terse dump flag
Message-ID: <20200515115117.GH2676@nanopsycho>
References: <20200515114014.3135-1-vladbu@mellanox.com>
 <20200515114014.3135-2-vladbu@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200515114014.3135-2-vladbu@mellanox.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, May 15, 2020 at 01:40:11PM CEST, vladbu@mellanox.com wrote:
>Add new TCA_DUMP_FLAGS attribute and use it in cls API to request terse
>filter output from classifiers with TCA_DUMP_FLAGS_TERSE flag. This option
>is intended to be used to improve performance of TC filter dump when
>userland only needs to obtain stats and not the whole classifier/action
>data. Extend struct tcf_proto_ops with new terse_dump() callback that must
>be defined by supporting classifier implementations.
>
>Support of the options in specific classifiers and actions is
>implemented in following patches in the series.
>
>Signed-off-by: Vlad Buslov <vladbu@mellanox.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
