Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C83F53B097
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 02:34:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232334AbiFAXBL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jun 2022 19:01:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230455AbiFAXBK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jun 2022 19:01:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC8433EA99
        for <netdev@vger.kernel.org>; Wed,  1 Jun 2022 16:01:09 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id s12so3092727plp.0
        for <netdev@vger.kernel.org>; Wed, 01 Jun 2022 16:01:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=TmJ151ApGOypiysE3OKyplOestV5NPN9d+wq4rRjspg=;
        b=ajXYbaR/ER8Uorj3xPomSUszyTfeZW3X0dXX8QW9IYvxRUQwn2Q+Rl2TbhN1C4toHS
         JURTEUB4jJQh6Q4iDDrHeWUgaI6Z5o53faQ3TUK45B4vPyjGSVnX+p9tYTeyhAXHECw2
         Qc3f5gMWont5un3mj0XytJZ5P7zb35WmoQjK+Vw1felvEFCIpDt9CGfPtRFXvsxUnUrI
         s4Nzjrnpb96FNGInbOosAL5aBSc+cYfs+z07csly9UZNS1FykyrgOyiSRFuE0PW20aPj
         DbTLji1x+bJpqqCJ4p8YWUfIS32xT4UuZZTD8NeAME50rpx2CY4VRYT+oas9ULxb/UFT
         t0WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=TmJ151ApGOypiysE3OKyplOestV5NPN9d+wq4rRjspg=;
        b=NZIxLraENFt5l4Btlyec/68mfoHCKSLoRQf2sCpO8zJbwUILDTVPeO5ycHNyo+QSMc
         FA5Mh2Co95/KGBqMYg8c1tMRqK6Y5R0l04vejQ6b6sxhUUEg1/lGKFzG7wPxY778Vu3Q
         fAf1H1bcG6JEJOmk0cABAFno1eTX85LrpksD3gHEcljYyCemu6/o3bIyo4leBQrFMN37
         jbhsTOGHmkM3wD6i5quq0xW2Vwkyx37ulktP/+fFsytWGqJS4aR19LdyZDT7ZyBt9hNK
         FCmejmlbIsJ7Ysi9pBRgoeK8H4SH8lM6Wo4dL3KYUQmJsshFW8ODHigUJ/0mqAKj94Bz
         SueA==
X-Gm-Message-State: AOAM533Or3cAVWYWh8L/hWGhaFtsAk7v07xmSK4W7/lK5uXT6rQs0W5O
        NabGp7cCJt6wTzR7pKcNHSLhlCcECezyqX/B
X-Google-Smtp-Source: ABdhPJwgEPozukygOMWeI/2OK4DA9E1ATl1DZxRYfKMTao2Czrgx/1MfRQyadxavC549Nd4Tz7sC4A==
X-Received: by 2002:a17:902:9b83:b0:164:59e:b189 with SMTP id y3-20020a1709029b8300b00164059eb189mr1649790plp.91.1654124469007;
        Wed, 01 Jun 2022 16:01:09 -0700 (PDT)
Received: from localhost ([2601:648:8700:396:fb27:2ab5:7245:4275])
        by smtp.gmail.com with ESMTPSA id e14-20020a170902ed8e00b0015edfccfdb5sm2080974plj.50.2022.06.01.16.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Jun 2022 16:01:08 -0700 (PDT)
Date:   Wed, 1 Jun 2022 16:01:07 -0700
From:   Frederik Deweerdt <frederik.deweerdt@gmail.com>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
Message-ID: <Ypfvs+VsNHWQKT6H@fractal.lan>
References: <20220601024744.626323-1-frederik.deweerdt@gmail.com>
 <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="B7JG9qKa0nZT1Wxe"
Content-Disposition: inline
In-Reply-To: <CA+FuTSeCC=sKJhKEnavLA7qdwbGz=MC1wqFPoJQA04mZBqebow@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--B7JG9qKa0nZT1Wxe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Willem,

On Wed, Jun 01, 2022 at 09:24:32AM -0400, Willem de Bruijn wrote:
> On Tue, May 31, 2022 at 10:48 PM Frederik Deweerdt
> <frederik.deweerdt@gmail.com> wrote:
> >
> > Hi folks,
> >
> > Based on my understanding, retransmissions of zero copied buffers can
> > happen after `close(2)`, the patch below amends the docs to suggest how
> > notifications should be handled in that case.
> 
> Not just retransmissions. The first transmission similarly may be queued.
> 
> >
[...]
> > @@ -144,6 +144,10 @@ the socket. A socket that has an error queued would normally block
> >  other operations until the error is read. Zerocopy notifications have
> >  a zero error code, however, to not block send and recv calls.
> >
> > +For protocols like TCP, where retransmissions can occur after the
> > +application is done with a given connection, applications should signal
> > +the close to the peer via shutdown(2), and keep polling the error queue
> > +until all transmissions have completed.
> 
> A socket must not be closed until all completion notifications have
> been received.
> 
> Calling shutdown is an optional step. It may be sufficient to simply
> delay close.

Thank you for the feedback, that helps!

What do you think of the attached patch?

Frederik

Signed-off-by: Frederik Deweerdt <frederik.deweerdt@gmail.com>

--B7JG9qKa0nZT1Wxe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline; filename=patch

commit 3218d973b68bc6d9f88d9e2374f3ada3df5ee7ff
Author: Frederik Deweerdt <frederik.deweerdt@gmail.com>
Date:   Tue May 31 18:23:54 2022 -0700

    [doc] msg_zerocopy.rst: clarify the TCP shutdown scenario
    
    Explicitly mention that applications shouldn't be calling `close(2)` on
    a TCP socket without draining the error queue.

diff --git a/Documentation/networking/msg_zerocopy.rst b/Documentation/networking/msg_zerocopy.rst
index 15920db8d35d..9373631d0a82 100644
--- a/Documentation/networking/msg_zerocopy.rst
+++ b/Documentation/networking/msg_zerocopy.rst
@@ -144,6 +144,11 @@ the socket. A socket that has an error queued would normally block
 other operations until the error is read. Zerocopy notifications have
 a zero error code, however, to not block send and recv calls.
 
+For protocols like TCP, transmissions can occur after the application
+has called close(2). In cases where it's undesirable to delay calling
+close(2) until all notifications have been processed, the application
+can use shutdown(2), and keep polling the error queue until all
+transmissions have completed.
 
 Notification Batching
 ~~~~~~~~~~~~~~~~~~~~~

--B7JG9qKa0nZT1Wxe--
