Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E73DD5A8BAD
	for <lists+netdev@lfdr.de>; Thu,  1 Sep 2022 05:02:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiIAC7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 22:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232476AbiIAC7j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 22:59:39 -0400
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2AEE162155;
        Wed, 31 Aug 2022 19:59:36 -0700 (PDT)
Received: by mail-pg1-x52a.google.com with SMTP id q63so15132004pga.9;
        Wed, 31 Aug 2022 19:59:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date;
        bh=eVRGKtfHojTP92sNkJnJ80bmZvj7fSvzpyBR/tNw3ks=;
        b=Z9FrDCeLSWgX3RZSj2UxqAE8u1GU8ozB47W0KevNli961D6+XCr2sF2kcSXaA+mt66
         bp87G2N6IE6JEEcNo1WYs8rR2EccX6rR0XhQyZBnFmGVaLNzRFolalJog6YKLv0q0Ll0
         Iuhu8EM2+R8jTPoQ++idc26GxuhUB0bqI7viJ8EombycdKbAQv+9ELLx8wF1wD3Ah4DF
         AK+DRoOfJJlmYOF35lFIk4kQqQrwxUqbvuMCal9AGB29iH0bPHG+uRyWnn+SlfoJTdgy
         R0bvt56TLQBY9gD2W48QpXXgio08W9g76BJSe6OCzoR6EIpPimc3XDvF7H1fN8qaSEfr
         eoXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date;
        bh=eVRGKtfHojTP92sNkJnJ80bmZvj7fSvzpyBR/tNw3ks=;
        b=Q9ZGn3m9HSW/BFMpgxNdAggh4wNq6XV1tWCmp59WK3GyLX+UA85g3nQcL3lGT3+sTT
         0czygwIr1KXNzXOvI4Z5zAR9VBXC7qmHCnrw5bX73BhJXetexUoKgLDF2nPrtermG5jf
         YUL9tzZK5xv0gWt1TWAJeUEp0nZZoTWjvpBoAEQeMW2QWxPVh3CpOUO4RcxMFJy+FZJ4
         pC1ov9T+gup2+3zalQhvltz4lt4pfDsi4WObyKt5yNiNgl5MsvQ3zqDa6UwpO30st8fl
         UnSY/NGVDRNnzaidJD1TdO0v3eKSfuoHcpOklg+W5f+k0TpSDr7zD66y68KK2vhGjukq
         vq5Q==
X-Gm-Message-State: ACgBeo3rnQ++vPR92FjUaEpoyT0LmzRTNxXvTrmkw4FELlmMn6wdHNSd
        gj+CdV/QpNZQBgKJFyTtrWrQWcffCCXPyw==
X-Google-Smtp-Source: AA6agR5robk+ckbRzd9sqLD+fqCogMqIgVeonf5UanMs9BholsVn+R4Jip+Pi6Wu0kwqJ3LkUNrAlA==
X-Received: by 2002:a63:5715:0:b0:42a:d7a4:4c30 with SMTP id l21-20020a635715000000b0042ad7a44c30mr24290092pgb.525.1662001176034;
        Wed, 31 Aug 2022 19:59:36 -0700 (PDT)
Received: from MBP ([39.170.101.209])
        by smtp.gmail.com with ESMTPSA id u6-20020a654c06000000b0043057fe66c0sm1014591pgq.48.2022.08.31.19.59.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Aug 2022 19:59:35 -0700 (PDT)
References: <20220831180950.76907-1-schspa@gmail.com>
 <Yw/HmHcmXBVIg/SW@codewreck.org>
User-agent: mu4e 1.6.10; emacs 27.2
From:   Schspa Shi <schspa@gmail.com>
To:     asmadeus@codewreck.org
Cc:     ericvh@gmail.com, lucho@ionkov.net, linux_oss@crudebyte.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, v9fs-developer@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] p9: trans_fd: Fix deadlock when connection cancel
Date:   Thu, 01 Sep 2022 10:55:36 +0800
In-reply-to: <Yw/HmHcmXBVIg/SW@codewreck.org>
Message-ID: <m2bkrz7qc8.fsf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


asmadeus@codewreck.org writes:

> Schspa Shi wrote on Thu, Sep 01, 2022 at 02:09:50AM +0800:
>> To fix it, we can add extra reference counter to avoid deadlock, and
>> decrease it after we unlock the client->lock.
>
> Thanks for the patch!
>
> Unfortunately I already sent a slightly different version to the list,
> hidden in another syzbot thread, here:
> https://lkml.kernel.org/r/YvyD053bdbGE9xoo@codewreck.org
>
> (yes, sorry, not exactly somewhere I'd expect someone to find it... 9p
> hasn't had many contributors recently)
>
>
> Basically instead of taking an extra lock I just released the client
> lock before calling p9_client_cb, so it shouldn't hang anymore.
>
> We don't need the lock to call the cb as in p9_conn_cancel we already
> won't accept any new request and by this point the requests are in a
> local list that isn't shared anywhere.
>

Ok, thank you for pointing that out.

> If you have a test setup, would you mind testing my patch?
> That's the main reason I was delaying pushing it.
>

I have test it with my enviroment, it not hang anymore.

> Since you went out of your way to make this patch if you agree with my
> approach I don't mind adding your sign off or another mark of having
> worked on it.
>
> Thank you,

-- 
BRs
Schspa Shi
