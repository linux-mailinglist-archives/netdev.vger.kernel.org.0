Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25D1052B952
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 14:13:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235893AbiERL6Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 07:58:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235976AbiERL6P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 07:58:15 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCEAB3631B
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:58:14 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id q4so1528304plr.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 04:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to;
        bh=qOGmMpU6cQSpl/71fyCpHtzhIfiFKIUXW9dc0ENItMw=;
        b=EXHwTVvRaER1bFGh3q3sSgBQY3RY5fmlIQF+pU9wLYdD1ZsikzZ2+AH+M+XKov3R6r
         7MQWLDqz6ZfdZS+c3GjKlnu8iuzgx22xc73wYca1ERi9rtYrLXdoD/EPREWd3HHwEbtJ
         EWBs+vl/ToOcNzhqpbhilwC5oUOB5woAV4PDFD1/UG/kpXMRtSg3DRlEAJV+3eJOA041
         8AteCu/6Gn7AqJviRmHrrYN7PRKW7p63NilVDqw72uot4g9dcP4Bf8mQKWat3BTxv8PG
         daF4gWyKmRKAVVDERBKj549SitU08RPSGaH0oDOVKvziOSguF3mFrHnTdsC8zpD0KHI0
         aPWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to;
        bh=qOGmMpU6cQSpl/71fyCpHtzhIfiFKIUXW9dc0ENItMw=;
        b=l0jsa3gVVkLuj7OEJsXPjfClo9GZgWT8TZwU5HvzFobhCyhLHUC5JYBXjuGim5TP69
         GMpgRtLnhbWc1LZ5azMOxg/IR8dVLsG9koVYUjOi6fvM46CF1Y0vehaNSgu54ow7xvob
         bGLBKz13qgeWN+YNuc5pHfkBQXFCjrcTh1T+rD4OQSzRi0YwjkcIziacBtiI9wn2V1fk
         jQNBaRvMQOx7nDQf4eBm3ZMsQCSk+KE18AdnJiKOIQNw6r5LtdtUN6vDqSjwkkdR5I8N
         qTf/SczWZnzFINgU1Aabrir9vOM4OwgJclDCRmuLpbA5HjlSmjSBsVhox2jvse5jcBEy
         zMOQ==
X-Gm-Message-State: AOAM530eV5u7R/u9ZCIYv+LHl4+LjMT+9TIJozok7c0zYiBddBIy+aFW
        lWvOwA1TV4+wWRsojrkd9Yw+8HBZDT0FK+QE3H4=
X-Google-Smtp-Source: ABdhPJylMOpjMd7tZoKMGkNufpqeTsr1KOE5Ijf/BNZ9LMr3ZSmv0fLczXBUg7dQ5m5/Rl+GsQeu9utEVZb3wdVFe/o=
X-Received: by 2002:a17:90b:4a51:b0:1df:7617:bcfb with SMTP id
 lb17-20020a17090b4a5100b001df7617bcfbmr12130022pjb.207.1652875094136; Wed, 18
 May 2022 04:58:14 -0700 (PDT)
MIME-Version: 1.0
Sender: munnaprajapati9898@gmail.com
Received: by 2002:a17:90a:a087:0:0:0:0 with HTTP; Wed, 18 May 2022 04:58:13
 -0700 (PDT)
From:   Mrs Aisha Gaddafi <mrsaishaay798@gmail.com>
Date:   Wed, 18 May 2022 07:58:13 -0400
X-Google-Sender-Auth: 4oBxpSR1_ajXFJRtW7osZvPFLhQ
Message-ID: <CAHRyjXDDAEkxo3LPGrGu+1nr-BhTkyEqpHGtkXjOCVYf55gWYg@mail.gmail.com>
Subject: Assalamu Alaikum
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.0 required=5.0 tests=BAYES_60,DEAR_FRIEND,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,HK_NAME_FM_MR_MRS,
        LOTS_OF_MONEY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_MONEY autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:632 listed in]
        [list.dnswl.org]
        *  1.5 BAYES_60 BODY: Bayes spam probability is 60 to 80%
        *      [score: 0.6241]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [munnaprajapati9898[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [munnaprajapati9898[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.6 DEAR_FRIEND BODY: Dear Friend? That's not very dear!
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  1.5 HK_NAME_FM_MR_MRS No description available.
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        *  1.4 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: ******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Friend

I have investment fund worth $57,500 million dollars deposited in the
bank which i want to entrust on you for investment project in your
country or your company. as i am under political asylum protection and
as a refugee in a foreign land together with my 3 Children i am not
allowed to have a direct access to this investment fund to handle this
project myself therefore I need mutual respect, trust, honesty,
transparency, adequate support and assistance, Hope to hear from you
for more details.

Warmest regards
Mrs Aisha Gaddafi
