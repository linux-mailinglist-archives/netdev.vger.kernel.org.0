Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3254E5195AA
	for <lists+netdev@lfdr.de>; Wed,  4 May 2022 05:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245718AbiEDDEM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 23:04:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232560AbiEDDEK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 23:04:10 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F6A1122
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 20:00:36 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id l11-20020a17090a49cb00b001d923a9ca99so139473pjm.1
        for <netdev@vger.kernel.org>; Tue, 03 May 2022 20:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sBbW3dES4PsNndNsMzNyRantOM6nkZkO6fssodT/mP8=;
        b=YFZCr2jEDKP9d4fNqKby5RJe7VXDO102GdRkb/vlN2Yhun4fBqaIROkg+5AfjH0Bub
         btSE6xZ0sSXs84M+xEKBafb8kVV8b39LYHs26a5EbqL7R+dA+l4y/0zKOqqu9tNxYRF8
         lG+X9q0vBrW82eg8YYChhHHGYZk9BB+S9ZRDb8yTTSuXnwuBxvF0hk2M6ouJvcBCwajD
         4tKewdGpMmOoy1iUAiWv+NRI32Yx3rSXrF3EJTMvEWOHlcD/NiM7KTXw5CsRUK6Y9Vtb
         5NSp1UN85LSD30S8itQFU0uqK1edbuoVseiTwEQQx2QnrJPkJ1mvwCNUn0G8N2YLfLdw
         HzrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sBbW3dES4PsNndNsMzNyRantOM6nkZkO6fssodT/mP8=;
        b=Yd371iMXAAqzWGsEQI+LKkT6o2ILZWY2wwmoR3GJLXY8LWkSMnEIUpxVVWnTu+ZUU/
         iOaxdeb+8Me/kYWyNy03RS19jbLZcqWVWoyCJP0F86hqQwNDQOsvDrdrTRGh0svwOAG1
         Lo8wP95UZ7QOW8HvyXP0f4ko0EtZFn4DGEjNxG/J1ceuJLcWisSj6ufIHmOIiVLTYq9B
         gHauzwjH0WgO7tchXhYVPY7Yh+AXfgkqFFgC23EyshgmVceHM7iWtHI/DtxOOza47iFo
         ++/queEoy7EiYp+PIcs/rsjWtFJXaP4kv1C5MyVMdgpH29WQ2PdouM7z/Td9tTfDUqXW
         jS9A==
X-Gm-Message-State: AOAM532Kv1f6XsjQd15Uo/+VuKpfkLfl0/Ecg/wkFqMI/gwiaiCjZ/Vv
        k1GAI6FXcqa5q5c0KbRgb90yEDxkDIk=
X-Google-Smtp-Source: ABdhPJwDGiNeliUHI9C9IGzHxKl1PyNzJN7bg+yVrPM2YyWCtvhhONyTfD9fpIyvDwKw4OzvTWIupw==
X-Received: by 2002:a17:902:b789:b0:15b:5d52:7542 with SMTP id e9-20020a170902b78900b0015b5d527542mr19831079pls.26.1651633235885;
        Tue, 03 May 2022 20:00:35 -0700 (PDT)
Received: from Laptop-X1 ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id r12-20020a170903020c00b0015e8d4eb27dsm507568plh.199.2022.05.03.20.00.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 May 2022 20:00:35 -0700 (PDT)
Date:   Wed, 4 May 2022 11:00:29 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH net 0/2] selftests: net: add missing tests to Makefile
Message-ID: <YnHsTdgxTKHiDQSJ@Laptop-X1>
References: <20220428044511.227416-1-liuhangbin@gmail.com>
 <20220429175604.249bb2fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220429175604.249bb2fb@kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 29, 2022 at 05:56:04PM -0700, Jakub Kicinski wrote:
> On Thu, 28 Apr 2022 12:45:09 +0800 Hangbin Liu wrote:
> > When generating the selftests to another folder, the fixed tests are
> > missing as they are not in Makefile. The missing tests are generated
> > by command:
> > $ for f in $(ls *.sh); do grep -q $f Makefile || echo $f; done
> > 
> > I think there need a way to notify the developer when they created a new
> > file in selftests folder. Maybe a bot like bluez.test.bot or kernel
> > test robot could help do that?
> 
> Our netdev patch checks are here:
> 
> https://github.com/kuba-moo/nipa/tree/master/tests/patch
> 
> in case you're willing to code it up and post a PR.

Thanks, I will check this and post MR when have time.

Hangbin
