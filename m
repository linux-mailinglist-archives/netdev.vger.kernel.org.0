Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0B4652CA25
	for <lists+netdev@lfdr.de>; Thu, 19 May 2022 05:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230486AbiESDNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 23:13:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231282AbiESDNd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 23:13:33 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B924852531;
        Wed, 18 May 2022 20:13:30 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id k16so3950616pff.5;
        Wed, 18 May 2022 20:13:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=NMXGgFK3aBOi3ExdCBs1kJFuXGtORe964V3PNVls+bU=;
        b=gAjcZ7j6pE0/NPbIC0iOrjrBLBAjkEJzdPaxiCx4+XYceswS3B91OC7XYzX5Vzg3UB
         HQVGZ7Kpb2oqBU5MgpeuYWvUNdP4lqhpOxND5YRcwHziHTvWLAaxeygN9se0AUTdc/zf
         AelVyLenEOc6a9ePByc8Ip++lxLdfuY9fD5yJ7cPbj/0l1nDW8krj2JZTS8A36KA/mn5
         jl6v2h/YelMv62euGdsz5jq6xUMYLwAWmXcE7GxGl5sRlOrmjnjWwsPZazr13HYUBP0w
         e/92L2CfFwyQsl6oIHfg9Ha+w5Lt/43o4DNVXWyF/tlCTmpTYejb0+sBOrhzzYdrkrZM
         9q7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NMXGgFK3aBOi3ExdCBs1kJFuXGtORe964V3PNVls+bU=;
        b=Pxq5F+CXop8WHzTMY1xP3vWacfrR+QASZHPVYUOX3hU62K0QlUyhsC4U1LbQDTFk5y
         FHt7Ld0t13/YQffTqonmtSaD/zJYw9UPdWfRaJIciARoRnTdZjHw4QwN6VDrEM+kg0BM
         O+G6q6M8Rkkn240bkoIIrsXQctXUrBmnPhkQzLHfVQB7PNC3tOb3pu5J1o33RQQp4dme
         YCwUPO04uc9eFZKGVcxKQvvNcOyKcxPFPaDb1njukgV/jUAhlc24/NgyxB7SU/S8nXQj
         t+Wqrc04/nFEnhSjmTXZqwFMenZLw7vSlVAcVA+5yhM6DZsfUzey4lRiTCS4e5TPuePi
         WP0g==
X-Gm-Message-State: AOAM530H76GmQkHogwXKJ0taccefFwdxGa/fGHFTTlQ53oPeQBqKpA0y
        NWJ3MlNAiczi4uIEcHASeBQ=
X-Google-Smtp-Source: ABdhPJxnedIn98O7kbX9/voPqHkklUqe63rBjjyCFdTZmPs9GN/ce+xdOMVxpRHhVKmw/9vnd7G7uw==
X-Received: by 2002:a05:6a00:f8a:b0:517:cafd:bef7 with SMTP id ct10-20020a056a000f8a00b00517cafdbef7mr2741949pfb.68.1652930009798;
        Wed, 18 May 2022 20:13:29 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id m9-20020a1709026bc900b0015ea95948ebsm2456474plt.134.2022.05.18.20.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 May 2022 20:13:29 -0700 (PDT)
Date:   Thu, 19 May 2022 11:13:23 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <YoW10/wHCqDelBZj@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
 <20220429175604.249bb2fb@kernel.org>
 <YoM/Wr6FaTzgokx3@Laptop-X1>
 <20220517124517.363445f4@kernel.org>
 <YoSLx329qjT4Vrev@Laptop-X1>
 <20220518082548.24d63e25@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518082548.24d63e25@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 18, 2022 at 08:25:48AM -0700, Jakub Kicinski wrote:
> On Wed, 18 May 2022 14:01:43 +0800 Hangbin Liu wrote:
> > > > +files=$(git show --name-status --oneline | grep -P '^A\ttools/testing/selftests/net/' | grep '\.sh$' | sed 's@A\ttools/testing/selftests/net/@@')
> 
> FWIW this will list just the names of bash scripts with no decoration:
> 
>   git show --pretty="" --name-only -- tools/testing/selftests/*.sh
> 
> And we can get the names of the files with basename:
> 
>   for f in $(git show --pretty="" --name-only); do basename $f; done

This way is easier :)

> > python for testing. So I think there is no need to check all
> > tools/testing/selftests/.*/Makefile. WDYT?
> 
> Not sure I understand, let me explain what I meant in more detail. 
> I think we should make it generic. For example check the Makefile 
> in the same location as the script:
> 
>   grep $(basename $f) $(dirname $f)/Makefile
> 
> And maybe just to be safe one directory level down?
> 
>   grep $(basename $f) $(dirname $(dirname $f))/Makefile
> 
> Instead of hardcoding the expected paths.

Ah, got what you mean. Thanks. I will check how to update the script
and open PR after that.

Cheers
Hangbin
