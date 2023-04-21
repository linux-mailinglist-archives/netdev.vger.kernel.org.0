Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDF06EA39A
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 08:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbjDUGQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 02:16:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229805AbjDUGP5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 02:15:57 -0400
Received: from mail-vk1-xa2b.google.com (mail-vk1-xa2b.google.com [IPv6:2607:f8b0:4864:20::a2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98B8F83C9
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 23:15:55 -0700 (PDT)
Received: by mail-vk1-xa2b.google.com with SMTP id 71dfb90a1353d-44035aba96aso412403e0c.2
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 23:15:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682057754; x=1684649754;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I8/2MvSU6oFc7wGd3T9soFc0JfRNmsYKIOjSLM8PQvU=;
        b=bZkde9pvmHVQIhLwWtRXWqIQuovRRq7bNS2GmwO56hlgg2CP/IvpNv6YCEj45nG0UL
         7Latzp8xYx4RvLMpK4wCaf3v5E/Cf4qHi1jFk1YXv4L/Vxfd1wRPov8nO8mMP96HEOI6
         4IMGMoTRgmEgcwDXAsCTQD5GowEyqpM8a+v4X/c+gq0ZZ1D82Nuj3HG0eOMfTiOHD/Rw
         eXS5z1uEXf29CNFujqoBSNzAOk2EbATMEpOeVb4yKyrZpoZIX3C9hPXzAjznxL7TsBoa
         jgDwc281D1lQaAq65jVTmArz/koWMvoXz9UGRnZFdTscFIi3QEZxSmfp1e7g7P7a/eOg
         +rIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682057754; x=1684649754;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I8/2MvSU6oFc7wGd3T9soFc0JfRNmsYKIOjSLM8PQvU=;
        b=kvUe/v5FBctDaeoUiTH2PamQXsZFJ69yuSed3jJr44kpfPBRGorDk6gr6SnohRWjxB
         a3xrNI8DjlhBvCdortSKVJLKcgXHZuibQOPz+PQjwT0NbVM2fjASY+3GLB+7lwhhab6T
         7FbetX2tUchpJoFeaI12D3uKXdru1v5u/U2HQMCab9qNk9UNxLZyuZ47jU2AGDOrsHrr
         oy8O6ZgC/3Co6cHYzscMf3e7fNi/+zHevyUjLoEQ6dXmMHYZh1SnpGX1RX+5Kkc/anlj
         bJ05btukNwakDyE4aynYgzWUAvKN9+h7hFFNcduR+twL4eUwUXDLbCV0DwuKeIgdP+Fw
         St1A==
X-Gm-Message-State: AAQBX9e03L/Aaz/9I7LJqDnVYW4oMZnaO9zNMz5k3p/QzhVK+5uS9n/L
        Kk8YyLJi9FFg8nGDwLWHBdaZSUx4AmeqstYwnJo=
X-Google-Smtp-Source: AKy350bTBFvLtVO1ijhomscF68SNO+wYw5s414tdawX8udEkWseTlWmTvVRtQtAR0YzX/jdiu18Dzl9gqeTM0qpueFo=
X-Received: by 2002:a1f:d907:0:b0:3e2:ecf4:9f82 with SMTP id
 q7-20020a1fd907000000b003e2ecf49f82mr382973vkg.11.1682057754688; Thu, 20 Apr
 2023 23:15:54 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:b0ea:0:b0:385:8ff8:d0b5 with HTTP; Thu, 20 Apr 2023
 23:15:54 -0700 (PDT)
Reply-To: barley.sonia@yahoo.fr
From:   SONIA SONIA <melvindakore@gmail.com>
Date:   Fri, 21 Apr 2023 07:15:54 +0100
Message-ID: <CAHjkYz1bNC4N2+zMuJ3QguUrrZVxgWNicNZG9S9v=FderUiXXw@mail.gmail.com>
Subject: Re: Investment Proposal
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        LOTS_OF_MONEY,MONEY_FREEMAIL_REPTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNDISC_FREEM,UNDISC_MONEY autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:a2b listed in]
        [list.dnswl.org]
        * -1.9 BAYES_00 BODY: Bayes spam probability is 0 to 1%
        *      [score: 0.0000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [melvindakore[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.0 LOTS_OF_MONEY Huge... sums of money
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.0 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  2.2 MONEY_FREEMAIL_REPTO Lots of money from someone using free
        *      email?
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
        *  3.2 UNDISC_MONEY Undisclosed recipients + money/fraud signs
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Valued Partner,

I know you may have forgotten me, I am very happy to inform you about
my success in getting the money transferred under the co-operation of
a new partner who did not want his name to be mentioned here.

Please consider this mail serious despite the fact that you did not
expect it .Kindly contact Rev.Wilson Duke, immediately or forward this
email to him, asking

him to send the ATM Visa Card valued at US$3,200,000.00 to you for
your reward. Although my new partner is not happy that I have to
allocate such amount to you bearing in mind your attitude toward the
transaction at its crucial stage.

Kindly contact him via this address bellow;
Rev Wilson Duke,
E-mail: rev.wilsonduke@gmail.com

Yours Sincerely,
Ms Sonia BARLEY
