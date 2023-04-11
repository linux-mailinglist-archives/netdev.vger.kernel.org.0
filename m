Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7367D6DE3FE
	for <lists+netdev@lfdr.de>; Tue, 11 Apr 2023 20:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229581AbjDKSfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Apr 2023 14:35:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDKSfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Apr 2023 14:35:43 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 489C93A98
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:35:42 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id fg17so4887550qtb.13
        for <netdev@vger.kernel.org>; Tue, 11 Apr 2023 11:35:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1681238141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pNhw1rwsZxvYQ/H6lk5xPyWu/BbAfsIS91OJ6pF/VcA=;
        b=Q/a+1R7LWj2pCh01oWLWOFIMhB2g4aLspYdGcM7djtj+1xlY1IBHxihk3Yn3VVtJak
         lNqLNRvfIBqQqWJGZjktb+QJklyZyhXjduW5HyrZ9QupzM17wkNpJ247mJ0TXNg3YINF
         /nYUv74sT2R8hpz6JS6ZwO3Alea/cSdmYXBQo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681238141;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pNhw1rwsZxvYQ/H6lk5xPyWu/BbAfsIS91OJ6pF/VcA=;
        b=BzVhZXHtIbQuQtoE2VHf0Y/qY2xSB3ItMzBVk/N/9BW+2n0bqCHWKrhrwuERs6aGwX
         j2bvoC2A5bWFeMHYNWv4+IzSPmt7oAf/F6o+dgjacrjoMU4PnMuae4sVekY3IjG0PsAP
         HDe3PpMv9Pw23vuBoctjyEH+CeqifyPy/oRcq6GKfDkUHu8JhjJQHJm0uZJvjWZegg03
         VsQ4SzUCG20GuOKNxLsnsF9qxfbhwpwo8M2qMWDFhvS2dBNfycXTcRGQQ4AqkbzrWnSB
         qPzWtJAd9WleRcQopj7+GW/s0OYV+dX5HlUTKYy2EQS8gAlxqb6E78ctirJ89gDvULBS
         Lm6Q==
X-Gm-Message-State: AAQBX9cSCOAqXooIuUN17RimFjEfpyovNVQkJZd6Ku3PJ2VpCSjLSr2u
        54f/wzDnUlI7wIozGmo63bsdOg==
X-Google-Smtp-Source: AKy350aJPLFSY6cXnBJYivTh4mirsnjhLVI7mjCvH9m6xHwSqrg8j/4cg/Sz5pwAfHz7l+OZYJuOVQ==
X-Received: by 2002:a05:622a:144a:b0:3bf:d7f8:4f85 with SMTP id v10-20020a05622a144a00b003bfd7f84f85mr24380909qtx.12.1681238141448;
        Tue, 11 Apr 2023 11:35:41 -0700 (PDT)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-30-209-226-106-132.dsl.bell.ca. [209.226.106.132])
        by smtp.gmail.com with ESMTPSA id x20-20020ac87a94000000b003e0945575dasm3775259qtr.1.2023.04.11.11.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 11:35:41 -0700 (PDT)
Date:   Tue, 11 Apr 2023 14:35:39 -0400
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Jamal Hadi Salim <jhs@mojatatu.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: netdev email issues?
Message-ID: <20230411-pavestone-unfitted-c1d28f@meerkat>
References: <365242745.7238033.1680940391036@mrd-tw.us-east-1.eo.internal>
 <CAM0EoMkuv=3C_jsn6NEsWoGBBzL2WDSNAOWxTfJ-Oh8xfJs1Fg@mail.gmail.com>
 <ZDKzhyCAYdAcu6H9@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ZDKzhyCAYdAcu6H9@debian.me>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 09, 2023 at 07:45:59PM +0700, Bagas Sanjaya wrote:
> Konstantin, would you like to have a look on this?

This appears to be related to vger, which isn't managed by our team at this
time. You will need to reach out to postmaster@vger.kernel.org.

Best regards,
Konstantin
