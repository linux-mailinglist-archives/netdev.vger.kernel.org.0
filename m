Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A999C6600B2
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 13:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234102AbjAFM5H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 07:57:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234390AbjAFM4p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 07:56:45 -0500
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA8C6B5AB
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 04:56:11 -0800 (PST)
Received: by mail-pl1-x62b.google.com with SMTP id d15so1582951pls.6
        for <netdev@vger.kernel.org>; Fri, 06 Jan 2023 04:56:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=flP4gSGBCiSpNm4TTuKoN09+Jn6Vrjybwd0k1MEHewI=;
        b=A59sgKV8Dsg3sixHXZfymEmPvv+swBaQNXtnpBdKSPzcT0rBGcDy6soGt1OKGY+KCP
         bIKomuq+KESBYHRawVcbsuIPNI4wNpftm/jv9KPAb1peHg2he5FoTdNSjbXsaqojAKNG
         5L7TjnjBSZqBFbejaImvk26Ptost1f9dBuTFhtZbuQcyAJVfa1zmrn/NGHXibZoKJkb2
         JyIT76UA31eTkG231WesusIGuRefqy6o39C8cpaI9ko2ajrxPvlMFF99ZXN4TGeQH1pO
         DAnl9fUUHiYE84OkusgSO+XyxX29YwyQrHJ6psT+1CxAveBctZ/CZ1+tI9EffupmVNo/
         3RVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=flP4gSGBCiSpNm4TTuKoN09+Jn6Vrjybwd0k1MEHewI=;
        b=U4sBVgfFKf64dkIcd9rLSjmwiUXdAYksLmLd9zbtEhvhMoNgo+7p5cdjzir6XJPl5E
         OhPrVgvjFBbyntp87TTWxVDreN3pU412mXbfvZpYWqVki+s3wp97X+vZw8T9YFsOfXKy
         dxtNKUDjrxpBdbBoUZVK88K36XAI4zQlIByekamm7i7CrRxmNnqJZ8crFXOpMNTLQO9f
         f2I0DRz1Na6Oc4L0+uYbte2D4uXJJnobTRXiF3VqSt11X0xj7Zlbd+RAIYhliNgJodCS
         nFuAW3hLZzD2UWv9y2/sWetvq9khRBUNQ6InmlZltGfhgPn2FbeH7L2YtuHcBFY+Tqwr
         lc2g==
X-Gm-Message-State: AFqh2kpJcJV4U2cOpWuPG6N0kTxrT9ie5wQ3yLQ7h2Q0Or1j2/QM3AzD
        +35Sl00WF+avEZiJyhTH5HyhPv5LQfpPEq02zrH1Ww==
X-Google-Smtp-Source: AMrXdXtl5xIcqLJS6/UfkwgJjtB29Gv7a3ULYjSjwHHt5Vi6nA4oBxy8/wio8ZLuwhodqJOe2nKuvw==
X-Received: by 2002:a17:90a:ab16:b0:226:6d:1a31 with SMTP id m22-20020a17090aab1600b00226006d1a31mr43125440pjq.49.1673009771227;
        Fri, 06 Jan 2023 04:56:11 -0800 (PST)
Received: from localhost (thunderhill.nvidia.com. [216.228.112.22])
        by smtp.gmail.com with ESMTPSA id mn6-20020a17090b188600b002263faf8431sm2864558pjb.17.2023.01.06.04.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jan 2023 04:56:10 -0800 (PST)
Date:   Fri, 6 Jan 2023 13:56:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jacob.e.keller@intel.com
Subject: Re: [PATCH net-next 8/9] netdevsim: rename a label
Message-ID: <Y7gaaH2wNB3k4RhP@nanopsycho>
References: <20230106063402.485336-1-kuba@kernel.org>
 <20230106063402.485336-9-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230106063402.485336-9-kuba@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 06, 2023 at 07:34:01AM CET, kuba@kernel.org wrote:
>err_dl_unregister should unregister the devlink instance.
>Looks like renaming it was missed in one of the reshufflings.
>
>Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
>Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Jiri Pirko <jiri@nvidia.com>
