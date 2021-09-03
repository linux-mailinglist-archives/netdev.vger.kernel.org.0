Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6A3A3FFEEF
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349285AbhICLWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:22:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348974AbhICLWB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Sep 2021 07:22:01 -0400
Received: from mail-yb1-xb35.google.com (mail-yb1-xb35.google.com [IPv6:2607:f8b0:4864:20::b35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF8DC061760
        for <netdev@vger.kernel.org>; Fri,  3 Sep 2021 04:21:01 -0700 (PDT)
Received: by mail-yb1-xb35.google.com with SMTP id e131so9462090ybb.7
        for <netdev@vger.kernel.org>; Fri, 03 Sep 2021 04:21:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:in-reply-to:references:from:date:message-id
         :subject:to;
        bh=uuKPdEBJH6/bl2anSqQnFEwmoD2XBi3ISnDGwBJsVO8=;
        b=eI+CMWsnrKHpUyD9xbeSESvizPgPN8D+V2gYJnXLbZVC31XoPYntxyJUYTRQMFNmoW
         5VXCL0DENulc1Q6KiGvxQz2kM34v/z2A3qEldRB0qoNjrmmn378fjZJhG8nwQe0sAnfD
         u8dEpEz3uAqbtfQGUqsoGLaSV2+5KrrNBRwSAPozJzSKh1qSeKPb1v4cBdqhQp8p+nTB
         JZ7JZ5FuFAPHTyTv7a//YfDVcnkyp6jMRFhb9bMTEL4Ng++4ktKBIfpSOEVrRTGrBTdi
         paG9Nqnnsrd/KI0pzwA5l3W2io1ISasVqn9qLp0+fdpIVv+ykYoZbkdkaXXLqudM8Cg5
         mPRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:in-reply-to:references
         :from:date:message-id:subject:to;
        bh=uuKPdEBJH6/bl2anSqQnFEwmoD2XBi3ISnDGwBJsVO8=;
        b=DJMrfAPcjXIA2nH9VPS2V2/ug2h+8d5PMgVeYctr3v1mV/Yir5+V+ksPGPFV6NSOUk
         LOac1GgzVJdYeWWgtNW0YyDCwvDiJBvfOr31tJVUIYjk+GJJC1MxeDw4RNlDgeb4WYhK
         8ScLhcuGFZoIzmagNPfVYOGnVACfERwhBbshXM0A9ChVh40at0tMSw0L6cFeTqyXwrt0
         TDBx3nJG347fo+y393sjfHEh4LDXAb3bY7loeQoydwoOV1eoAcjkZ5BAdZWNM8x3ft0q
         dhx8/7l1Ai88N5ZTYcw6yhHjDdPIOCKi/pzNj8VBUdmtZ6Hlq/FnjRBojyHva8vYDWfw
         tZBg==
X-Gm-Message-State: AOAM533In83iYWrhJqGG7l4ygt+56dERkXwOzwbUJOB8L8T0fZOB5Ylh
        CNtCqBUGjux83Slmu40o8fUA7G7qrt3ECLLuMg0=
X-Google-Smtp-Source: ABdhPJzcrSfXwiPqcnDrigpiYazBuo8HJxoWXOvjuxCNvDX5U/MeUp3pheDhhHfxR0trSubsKprFTuIi4EZKhtdSEm8=
X-Received: by 2002:a25:2155:: with SMTP id h82mr3972037ybh.177.1630668059930;
 Fri, 03 Sep 2021 04:20:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5b:645:0:0:0:0:0 with HTTP; Fri, 3 Sep 2021 04:20:58 -0700 (PDT)
Reply-To: j8108477@gmail.com
In-Reply-To: <CACVOnGEAvA1R93QjJL4ZnYGu6Ye3Poo+Qj4BroHHrXthU7ieOQ@mail.gmail.com>
References: <CACVOnGEAvA1R93QjJL4ZnYGu6Ye3Poo+Qj4BroHHrXthU7ieOQ@mail.gmail.com>
From:   MR NORAH JANE <alicejolie80@gmail.com>
Date:   Fri, 3 Sep 2021 13:20:58 +0200
Message-ID: <CACVOnGHO-E+JwB_4B73Ty13M1W7ojCwEJhsgde0aLfk0k1bZ0w@mail.gmail.com>
Subject: Fwd:
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---------- Forwarded message ----------
From: MR NORAH JANE <alicejolie80@gmail.com>
Date: Fri, 3 Sep 2021 13:20:30 +0200
Subject:
To: alicejolie80@gmail.com

HI, DID YOU RECEIVE MY MAIL?
