Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15BB1576B34
	for <lists+netdev@lfdr.de>; Sat, 16 Jul 2022 03:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiGPBhi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 21:37:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231383AbiGPBhh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 21:37:37 -0400
Received: from mail-oo1-xc36.google.com (mail-oo1-xc36.google.com [IPv6:2607:f8b0:4864:20::c36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95DA18EED7
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 18:37:36 -0700 (PDT)
Received: by mail-oo1-xc36.google.com with SMTP id e2-20020a4ab982000000b004354ba9a591so1204350oop.0
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 18:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=xRsMeE0Yj2Rv8TilyM94TWwDFZvW9MSpwYsml569wBo=;
        b=IKf28YiZunQDmR/W17C0ckt8NTIwf+mTaTesWluvZbF5Y07kWK7vOREWEDuyyLm2n0
         XLiHRbz0492FUyU5ILfztzO9mPDh8zbIL/hSrYov4qvakNBfSprZy4+X46Huyvd4LxS2
         bUxHj+vBMAllqgsLiz7GcKBRu48Ub7mcMOClvrmbXZOpD/H2N/zsJAR7ksnYBt9pp09m
         01P6llZ3RufB6iBG5s8kgZeQ2X5UQo0s0FM2kKNc/D7Qcfq2+hkUw75zF73Ka5XMxIGn
         kf4NJZJXnKUGVUGMY5Cu/NPxAF8Ldcp0fhUbhPgF3wHhAiInzxktZ2iT+aRr6GZHXf9a
         20Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=xRsMeE0Yj2Rv8TilyM94TWwDFZvW9MSpwYsml569wBo=;
        b=oA9QHZ3/hGYzk87shviH7PYVeAG8Tec6knfFyAVVVJkzGAG8+1Woe8qYvt+NSHlnzp
         rpR+0EFgQ7PkU6tabk5r6O/xZHxc7ElS0nzkcIYYn4yTiq+C2WMbPYN4lEqhFNBqCkJA
         9RgrMtCupKb/t/WHnsUiixHgtL3PC0mB6SqMsDYSDh14l5I5K3icwL8zwQ8OIUBEWYNk
         y4DSPg+ldJTC1aOW6UU8lxyKQB117w/jsmIV7cY/z3b0wgXSufsdSprozNW5NWoueuSe
         qTn2h1hZTqohSOPrUHiHWxC2X/A06S0MewtSP7DqTzU2Us3CuiQvwn1xQ/njPkxS2PmQ
         doVA==
X-Gm-Message-State: AJIora81loGbhBr4f7dNpRITDMQ+yksTktecoKar+GXAcE7zTh0Pc51J
        IvP+a0GzGsTKb/bjT87oV/+nmUxsvoPiMeM0rgT6Pj3W6D9Kk1Iq
X-Google-Smtp-Source: AGRyM1uyzY8xZd8hi49QXYmkqGz3HY+otTFkafFhRCcTWUwWBpIgPPiPwVRP9NPMvU1XxzfZxMtK7pypL8We0uy6kQM=
X-Received: by 2002:a25:d652:0:b0:66e:c998:53ef with SMTP id
 n79-20020a25d652000000b0066ec99853efmr17473918ybg.335.1657935014847; Fri, 15
 Jul 2022 18:30:14 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a0d:e856:0:0:0:0:0 with HTTP; Fri, 15 Jul 2022 18:30:14
 -0700 (PDT)
From:   nebolise iran <neboliseiran00@gmail.com>
Date:   Sat, 16 Jul 2022 02:30:14 +0100
Message-ID: <CAA9js4mSCyZYQBgdvzSzKww7_HD8KAnvjEujnjUE80hpH1trvA@mail.gmail.com>
Subject: Sir / Ma
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Continental Exchange Solutions Inc
United Kingdom
London
Email : maliksman663@gmail.com

Sir / Ma
My name is Malik Usman of Continental Exchange Solutions London U.K. I
am an independent external auditor for IFC SERVE and the World Bank
handling the Foreign Banks Debt Management Office for all transactions
in the year 2013/2014 and later.

I have in front of me an abandoned transfer file containing details to
an escrow account setup in your name. The file shows that you have
correctly made application to have your funds released to you. It is
also clearly noted on the file that the beneficiary could not handle
the financial commitment required of him. Due to this the funds were
pegged and abandoned.As an international independent external auditor
I think it is very absurd to abandon ones funds for this simple
reason.

To tell you the truth I do not believe this to be true and my reason
is simply because of the irregularities I noticed while compiling the
audit report for the end of the financial year.I have perfected plans
to have this funds transferred to you within the shortest possible
Upon your confirmation I will give you further directives. Please
kindly reply to maliksman663@gmail.com with your full details.


Regards,
Malik Usman.
