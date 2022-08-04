Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 184D2589DEF
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234742AbiHDOyi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 10:54:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234583AbiHDOyh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 10:54:37 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C2242613B
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 07:54:37 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id q16so90312pgq.6
        for <netdev@vger.kernel.org>; Thu, 04 Aug 2022 07:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wn9tan0bzKrCZ9+XWA1a3X0cKGqw1BGux/upvBz9kj0=;
        b=Z8JSYeXqgG4yMbpv3gOD7ond3jmKCM6HkJb9UhQ0SL5ohb/jkrnnIyyDCLwh02mUGU
         w7yuMjqGvsgbQBT6TnoY21F4XyMzBVyKZ7mokQ4yLKyyHVNMJHVTre4SqhZawfYu8Sg2
         6+CHUdh541Gq4+sA9dD/7xmM0ajqKTIEwRijhQ6VrOFpQLNYv9F+IvCyoBmtYlADGwnj
         xXHekO+JHztP4Kkf5/5xrFGyBsqxPQlCYGp0LBOSpMxvYk3Z0ejrSfBJsV+XytH0Ai73
         i1u945OCaX5XcbklRKieNS6GRioEExJq7Fvs2bBLG9OzKHjQsMvDS/yyqV7Gw6blW3Ns
         s+og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wn9tan0bzKrCZ9+XWA1a3X0cKGqw1BGux/upvBz9kj0=;
        b=ogeuzh9QAh8IT5D0HfS/UDU9N40xWtnL5lWDFuCQT4cU0aOIEPvLYp0FCxjf3yLm3R
         U8xY5EBEnCytvA1k/1Pg1K35ihOa5qep72s8Cq3oy/9N8dH6pOA8gHaLTWoirbN4NLvf
         DbbakgpbzgD75Zk3DNPFqy2k3X2GkMHzQTy1zdWFo+HrwzLR9qhr8Gzxpa7xqDA9HNUC
         bpBp1kVRO4fFBOI8bQoMRUPLrmWlRhduWqS3frSeIun5PHZNhRGAjR2d/R1ASZWTFCbM
         pZpR7QdZ4QRY1CRb95IxwvEdiLomvx0xa20i1s60hWSNwoztrSdIH+sRcppuL9/5bUO1
         wcIg==
X-Gm-Message-State: ACgBeo3WUC6Bb6qU+BHKOPKkzhoHUPtTBFkxXkNmY9yx+K1nDLWD6dGQ
        SrlbVfQWi0ES55+UEPoxYCLL7Q==
X-Google-Smtp-Source: AA6agR7IQAV7KmiMR2lA/db7FSPsehzlEStJ1DyUJRkUwzkHxdazqVgClUlRkzavNNBuaFpCqxLKrA==
X-Received: by 2002:a63:2cc6:0:b0:41c:5f9c:e15c with SMTP id s189-20020a632cc6000000b0041c5f9ce15cmr1908203pgs.241.1659624876616;
        Thu, 04 Aug 2022 07:54:36 -0700 (PDT)
Received: from hermes.local (204-195-120-218.wavecable.com. [204.195.120.218])
        by smtp.gmail.com with ESMTPSA id y14-20020a17090322ce00b0016d9a17c8e0sm1120081plg.68.2022.08.04.07.54.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:54:36 -0700 (PDT)
Date:   Thu, 4 Aug 2022 07:54:34 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Steven Whitehouse <swhiteho@redhat.com>
Cc:     netdev@vger.kernel.org, Christine caulfield <ccaulfie@redhat.com>
Subject: Re: DECnet - end of a era!
Message-ID: <20220804075434.2379609a@hermes.local>
In-Reply-To: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
References: <9351fc12c5acc7985fc2ab780fe857a47b7d9610.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> Of course many others have contributed over the years, and we had a lot
> of support from the Linux network developers too. Many thanks to all
> who've helped along the way, we very much appreciate all the assistance
> that we've had. Alan Cox provided initial encouragement, with Davem and
> Alexey Kuznetsov later on, and with contributions from many quarters
> which were very gratefully received.
> 
> Farewell to the Linux DECnet stack :-)

So long and thanks for all the bits.


Thanks, I was kind of hoping somebody was still using it and would
jump in and volunteer to maintain it.
