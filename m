Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF04579A6
	for <lists+netdev@lfdr.de>; Sat, 20 Nov 2021 00:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234890AbhKSXlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 18:41:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbhKSXlq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 18:41:46 -0500
Received: from mail-oo1-xc29.google.com (mail-oo1-xc29.google.com [IPv6:2607:f8b0:4864:20::c29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21AADC061574
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 15:38:44 -0800 (PST)
Received: by mail-oo1-xc29.google.com with SMTP id v19-20020a4a2453000000b002bb88bfb594so4257734oov.4
        for <netdev@vger.kernel.org>; Fri, 19 Nov 2021 15:38:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=GD0aySu3SnLtPfPurGLGTrA4SK5u/VwrAiKx2VQvjf0=;
        b=oP8ZDiE7WAvb+fjgQCBi/g2FHS0ePoP6N24Uq1cCzOj6BRARyT53oT1plOJhFKssst
         o3LSbGcmU4fKwM7vrShEBIqjja9zpfErD6cr2FBslpENhgS1/sllZH8JFDlPJz00YTFa
         s0s0VfhikJXFTVc1tWPB1hHzpCMsO/dWPioeGOdatoYHbyTZEtW1nnv9tGewCNAjYb8y
         VwSxMApMlmjtKYeP8/PU2ylV+VbYc0009//vhpPRARNWhOkeI6slXXxCMspA2Ox2timO
         nn3+W85tMyLp1x5aN9gu5U/A6kQGneaxx2MEZVvpFpuut6NujmsVge5x86Gf6HSGnH/4
         zb2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=GD0aySu3SnLtPfPurGLGTrA4SK5u/VwrAiKx2VQvjf0=;
        b=uNhMQ00tG5Mjd7kIzr/VeWMQS22I7Jg19JfjrK4NZU9CeyZk9I3Bh+I9+3xYVGF47q
         5KZHSZ2yz9r3Stn8klbEnEe/DGS2jGqHFIjjvGlhmfwN9srLMXtWHmwJY4C5ljp5gQGJ
         euzAFkDdcnozaWQhe0rCTEawoHIkG6VHdmM1sIcJxdUZb/ATGgcyiThphd4g6yCj5dt2
         b1Pndnaw7yhbOau4F1wkhw5LGp/AvNumOv+Gpy1xj6ymmfssRzYdQk0/9h5Zzf3KypkD
         7FgcRTX7sEehPb0qTGfEiFxzkswSSlu0/2sonSuh4l61Ub2rfpEDpOil0dc470jHRwYV
         xGBw==
X-Gm-Message-State: AOAM532dWkyqmcfM21fkAg8ajDlrCaSLUaSz1c8WhtB1cqC5gUd3vrG6
        KTIzxwuQpUdUZNfwpjehFUx0EgBtHLbduV4IGkg=
X-Google-Smtp-Source: ABdhPJwUK8QBvXR1PDK9IdVa5aoH3H6VH6q+QAAvw4zjKJnVDR9rVrfQvVvsKmXl2rPPxkkCnsrlTtb+k9oyTIAJ2xM=
X-Received: by 2002:a4a:d68f:: with SMTP id i15mr20659460oot.77.1637365123355;
 Fri, 19 Nov 2021 15:38:43 -0800 (PST)
MIME-Version: 1.0
Sender: gaddafiayesha532@gmail.com
Received: by 2002:a05:6820:1693:0:0:0:0 with HTTP; Fri, 19 Nov 2021 15:38:42
 -0800 (PST)
From:   Anderson Theresa <ndersontheresa.24@gmail.com>
Date:   Fri, 19 Nov 2021 15:38:42 -0800
X-Google-Sender-Auth: uKZ4qmjw6QRvSKBxoXzxKEDnk08
Message-ID: <CALeZTrd8vM=bHAh0pYeSLVUUL1sJMKuN1C7BXb9VaYcttzLowQ@mail.gmail.com>
Subject: Re: Greetings My Dear,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I sent this mail praying it will find you in a good condition, since I
myself am in a very critical health condition in which I sleep every
night without knowing if I may be alive to see the next day. I am
Mrs.theresa anderson, a widow suffering from a long time illness. I
have some funds I inherited from my late husband, the sum of
($11,000,000.00, Eleven Million Dollars) my Doctor told me recently
that I have serious sickness which is a cancer problem. What disturbs
me most is my stroke sickness. Having known my condition, I decided to
donate this fund to a good person that will utilize it the way I am
going to instruct herein. I need a very honest God.

fearing a person who can claim this money and use it for Charity
works, for orphanages, widows and also build schools for less
privileges that will be named after my late husband if possible and to
promote the word of God and the effort that the house of God is
maintained. I do not want a situation where this money will be used in
an ungodly manner. That's why I' making this decision. I'm not afraid
of death so I know where I'm going. I accept this decision because I
do not have any child who will inherit this money after I die. Please
I want your sincere and urgent answer to know if you will be able to
execute this project, and I will give you more information on how the
fund will be transferred to your bank account. I am waiting for your
reply.

May God Bless you,
Mrs.theresa anderson.
