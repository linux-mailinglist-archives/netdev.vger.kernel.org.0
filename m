Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9278551B375
	for <lists+netdev@lfdr.de>; Thu,  5 May 2022 01:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382338AbiEDXZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 May 2022 19:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1384170AbiEDXHq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 May 2022 19:07:46 -0400
Received: from mail-qk1-x732.google.com (mail-qk1-x732.google.com [IPv6:2607:f8b0:4864:20::732])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAE615521E
        for <netdev@vger.kernel.org>; Wed,  4 May 2022 15:59:43 -0700 (PDT)
Received: by mail-qk1-x732.google.com with SMTP id a76so2048412qkg.12
        for <netdev@vger.kernel.org>; Wed, 04 May 2022 15:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=pZ5t16xmUYF9vlg4rhps6C0wpQe4GxdEAsL/ThaDGYg=;
        b=p/a9QNW5letV7nz24TNrImXCy5T+bJrDMkYTTiOBTYxk4gHf+AALhP/1rM9W8Riavp
         zsftQgtSsvF5Yx6y0oi3OM7aawoHHlyXN3CrEdo+Ishg8R73rnFdu4gZme//jyxF4oUR
         vBDUUov83sI96fuJA3stg/vHR6dHjYEbd/8M/BvBsplGqBXKxkSRhQpq3whPvm6skA3P
         fC+HpxTenVKqIqhf5HAfroFCD5wfNWJawpiH+sCkP+RyuNblej/I8OlaRVVUDfu6hfm5
         rPaSYXS7+/4pLgg9X+td3qKYBDXpfSfG8t2KiNkXmPcPN9S9KkLf3ZImcJwBZG0tuEVa
         +7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=pZ5t16xmUYF9vlg4rhps6C0wpQe4GxdEAsL/ThaDGYg=;
        b=6vu3399seypIlNzA4L+K6g1zXUWUkTscjgKt0bKG0indLL6gznXqJnIE1zQA3LXyZm
         ayb7rTg43b57ytkq9KBx/WDM3/jNJyZoPZyJ0K0j/HDVsM4Eim5+D0kDfOBMILCC0nAK
         SfAs3Cj3F3kbxjzTTW7uBW9e8jAuOsrns5ZoIq6312RNU035iq0sHpseLGK1ag2WauG9
         5Qog//kD1BlFoKRO8qSoKeg7ehG6J/C/K7EWE2YMStIL2GVQXPiQimqIhp7x27fSoHvP
         p+1JBux4HqO51N995NJvMLDn2Z9j/IdE3o4C9ZNf5kBqS0IJZ3ErdTNRuXr46NFF+owa
         /Wdg==
X-Gm-Message-State: AOAM531Kfyn4gGlG4XVLybe4ry5XtUh8+v3GeYRs3tSBCOwHR5WgkjwI
        tE0yrkognO6+dnsC67gu0z2DCYc8L6EU4O08ukI=
X-Google-Smtp-Source: ABdhPJxQ51kmdHTx7RPvx7NbQwDCL3/rEBSrZaw8p2Vi1CyMZsRfTF5KB7GRh/PJHdlPUuN4BO0X6zWBsL23lUD58oo=
X-Received: by 2002:a05:620a:100b:b0:69f:d71e:3156 with SMTP id
 z11-20020a05620a100b00b0069fd71e3156mr13362205qkj.248.1651705126121; Wed, 04
 May 2022 15:58:46 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:ad4:5cc1:0:0:0:0:0 with HTTP; Wed, 4 May 2022 15:58:45 -0700 (PDT)
Reply-To: srelpaul.sarl@gmail.com
From:   Paul Isreal <isrelpaul.sarl@gmail.com>
Date:   Wed, 4 May 2022 22:58:45 +0000
Message-ID: <CACUauhpcHwzQ6CepLjwPrONAkTwr0XYvB3u=XK5YDqJfDskjEg@mail.gmail.com>
Subject: Greetings
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:732 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5521]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [isrelpaul.sarl[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.5 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In view of the global economic meltdown caused by the corona virus
pandemic, We are expanding our investment portfolios internationally
and would like to partner with all eligible individuals and Private
sectors Globally in support of their well being and project ventures.

We have the financial capacity to finance any type of project
irrespective of the location. E.g. Real Estate,Mining, Agriculture,
Oil & Gas, Bio and Renewable Energy, Health,water and power
infrastructure etc.


If you are interested in working with us, kindly send your business
plan for evaluation and consideration.

Regards,
Paul Isreal
