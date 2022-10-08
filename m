Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1566D5F8802
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 00:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229544AbiJHWE3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 Oct 2022 18:04:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiJHWE2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 Oct 2022 18:04:28 -0400
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED9D52A945
        for <netdev@vger.kernel.org>; Sat,  8 Oct 2022 15:04:27 -0700 (PDT)
Received: by mail-qt1-x830.google.com with SMTP id fb18so4705692qtb.12
        for <netdev@vger.kernel.org>; Sat, 08 Oct 2022 15:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CtPJH3jqVVBjFVDIks2nPQF+6tDodj36jgdumuqDys8=;
        b=I1ydlpsQgrQHu+f5uf15BRhCNbP4C1pGK8nTef0a8t3fnr8RHDOqsA7UUY2uwv7AM0
         eXwPtc+tHHB4f5DMq1LrhEQbyHHw27RvVGYKv1TBUyV+JCYxyDnoGQHm6Tl375inLuCL
         ryppJRAZrcZpHvSxCl+QqwYWHOWKevQh+TNWuFnHsuDi/ibDPDcufICoUtRHtn4F67yF
         8w7OJsQbfxkUJf1VlIgfsTFVkwTZCaw/YYeFvufFRenpeoQ76AVu9ZEjeqg+UEm4O76W
         4mSVGZqLoiPLioOqLG7yhAmxpiY2g/IVgG9zC9p1PNcD8n7hai6SdUu5S+x6Gfb3T0kz
         X10A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:sender:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CtPJH3jqVVBjFVDIks2nPQF+6tDodj36jgdumuqDys8=;
        b=GlacldjYqgGbKTDxzanWw25sOXHaSlK0Je3SGhnVZFSMqCTs0oFInILfQvFIqagVvz
         nOrrsf759Dqd+5+f0iBVoJbd0iAmRYKfgYGa33VRhUCh51x9nMEpVSmGcIkD35Zh31WQ
         h1a+7PFVBOj6QEvw7RJuoEXuzPgquQ2bqZKIoPGGSdX6LVDNKSQmdlRBE2fP7idzIm2W
         ceip+sqEqwsuA5VEs15BkT3x1FZuSIfY6tvrlDTM+AJtIrVsoiFcVOVBWLpSP1RT4Z1P
         0b0JXrbppS/nTtSAb/hupufrEZU5+szIE25EQkAHMOdeA0543G6VzvmS7RCv9EAntQp9
         hfrQ==
X-Gm-Message-State: ACrzQf1PGNoTKVAOAT51KFnFmVPD+1VV8YFG9D2y+x8tPruhRxeou4us
        /NaRGz0Uw+BlN3TtxcxgKZnZpvy4S5q7uk3+mx8=
X-Google-Smtp-Source: AMsMyM5ASgImkETLLE7CqyiGaLsWqg/A3cmwvK9/HPEYrfOVJt1P4cfYQ8e4q9L7i1hiEtfChfvFnaEe+XR6VwLSkh8=
X-Received: by 2002:a05:622a:307:b0:394:dddf:d28c with SMTP id
 q7-20020a05622a030700b00394dddfd28cmr9422983qtw.121.1665266667068; Sat, 08
 Oct 2022 15:04:27 -0700 (PDT)
MIME-Version: 1.0
Sender: ogunmasaadesola@gmail.com
Received: by 2002:ad4:5bad:0:0:0:0:0 with HTTP; Sat, 8 Oct 2022 15:04:26 -0700 (PDT)
From:   "Mrs. Margaret Christopher" <mrsmargaretchristopher001@gmail.com>
Date:   Sat, 8 Oct 2022 15:04:26 -0700
X-Google-Sender-Auth: BwRA5VseXhrrKj8VjzH07TEB2Us
Message-ID: <CAEGnpV9HnVUwrD772XHgZ9PW=4N7pD_sM1wxd3a4YZ0s4=Q16A@mail.gmail.com>
Subject: Humanitarian Project For Less Privileged.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello Dear

  Am a dying woman here in the hospital, i was diagnose as a
Coronavirus patient over 2 months ago. I am A business woman who is
dealing with Gold Exportation, I Am 59 year old from USA California i
have a charitable and unfufilling  project that am about to handover
to you, if you are interested to know more about this project please reply me.

 Hope to hear from you

Best Regard

Mrs. Margaret Christopher
