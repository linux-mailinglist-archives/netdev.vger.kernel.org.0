Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 136BA536CDE
	for <lists+netdev@lfdr.de>; Sat, 28 May 2022 14:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355656AbiE1M0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 May 2022 08:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348350AbiE1M0i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 May 2022 08:26:38 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5D96156
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:26:35 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id s20so7376664ljd.10
        for <netdev@vger.kernel.org>; Sat, 28 May 2022 05:26:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=G9Q6psb88NqsE/S/Fz8mCADYqgWwagXV/KHNWgqOKj4=;
        b=RxALeLjf7aIJ3FT6Qmtsh/x4UoCU7HeGSBGSMxjOrOskhnJSs/Q86FqQyESpM+ctaF
         L1UhhTYiGmB0kY/Nzyd4AobytscQEi/v2pISGjQmL56LZ77TkA2AGgOzd4lARMhBZJ+j
         CqesulRoL4UVNCk60Sag7DHeNZsinoOAKh2QfZ+yEBRHps6MfXx2InJ3qNmflbBIt8gY
         /zNtDiN4zldWzxB13USMQSr7dR8ydyzhc7Va7CT4mbXqDkozOjlI9jIcAaztEaYp7XX5
         yH7b8YRLTkva2/vd8OlxTpOI3rL07HsP7AFiKqbFHOmDmbfjShoweo4HnxYl1+6a4HR+
         /Wsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=G9Q6psb88NqsE/S/Fz8mCADYqgWwagXV/KHNWgqOKj4=;
        b=3Kmk8SEqJ8Vj5KqcIIdYediuLfcf7HXhD6GmEe0GudKh9FBUAhbCWcXcDSljxDFoS8
         5Ko0zUcXHa/EEic2EvRWjBEHECaICPRcin7sxC2wn7gT5lWHB1uFswwgZq0Xp2yV95N0
         ovYGYNHBxwq+7VzBPTnYQkeBnIXkFetKMh4tIw2BcjLq9GFCC1IEXkJpaKKA4x200c7f
         e+T+4R1v0DggHPqCrZuL+lbPq3Ila779xVwtnUAZhCnihcSvmNeUWiNzrC1cLs4vaRKp
         kH7DQVUkir3Fal0qU6ULO5j7BYYoF+FOAjErS0VviRHqmKTwh67Y1p88tl+ATzEOshyT
         RPbA==
X-Gm-Message-State: AOAM531G0+xvBrTR2lh+XlZvRpnNXnm7Qe6jTQ25aqFT6Up/X2Swd0D7
        llMIjQOF+wsEtOVhDvbwRP34Uu4LBLq8tKZGF+Y=
X-Google-Smtp-Source: ABdhPJwPDX4x3jMX/Rt8/h1JS4QPzLcFtUCzpuB5FVnhn7aFq406VNc7J8ggfeJgMgQNAOmGoZFEkL/RszSY4f5I+M4=
X-Received: by 2002:a2e:a364:0:b0:255:458c:797d with SMTP id
 i4-20020a2ea364000000b00255458c797dmr2006110ljn.529.1653740794065; Sat, 28
 May 2022 05:26:34 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:4ed:b0:1b9:ca22:a6c4 with HTTP; Sat, 28 May 2022
 05:26:33 -0700 (PDT)
Reply-To: jameskibesa@gmail.com
From:   James Kibesa <lambertjeffery86@gmail.com>
Date:   Sat, 28 May 2022 05:26:33 -0700
Message-ID: <CANiUo+9fhrP+jmC+-QiR6sRyDS_xyJHtb+WG-RYOcGMJ9SgyqQ@mail.gmail.com>
Subject: GPE COVID-19 relieve funds.
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22a listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [lambertjeffery86[at]gmail.com]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [lambertjeffery86[at]gmail.com]
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.3 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,

You have been approved to received GPE COVID-19 relief funds. Reply to
this email (jameskibesa@gmail.com) for claim procedure.

James Kibesa


Chief Financial Officer

Global Partnership Pandemic Relief Consortium

www.globalpartnership.org.pl
