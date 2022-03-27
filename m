Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8EE4E8875
	for <lists+netdev@lfdr.de>; Sun, 27 Mar 2022 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235866AbiC0Piv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Mar 2022 11:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiC0Piv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Mar 2022 11:38:51 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561C112AB4;
        Sun, 27 Mar 2022 08:37:12 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id bq24so4926783lfb.5;
        Sun, 27 Mar 2022 08:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UNSedBTmK5s8jtfKnJd8Rt4VC9q5wdizP+aeJDiEQDY=;
        b=i2al3x/FX7wp5hltGACwMNiE4tkiVXSm6X2KMQNUOTMYYHzeUJuCSmjT3Ho/yqT8PE
         PMYl+/SAWkJkz9o/t/8TnEWmD/RO7b0UfB7ORgPyZ/w0V+FCg/3r92svvQsizC+Zddng
         V21Nl5Wo7XF1uArGm7YKDBUweN+q6B7hI2pZyEU5xc+3MymDSWElwEp/Uva1RGmHdd0Z
         Stg0zMs5MBTdFCpmRwR43q8v+v6i4NrGaea1/K/fCt6K2cf72f31+qveMfFqlTua6eaD
         HApM0DoJ55jZieX4f/4edEbmnjB01CaNb+JQYxzrHhWPsJoLNqkoHF7qBOXKR8oaZL4B
         5PhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UNSedBTmK5s8jtfKnJd8Rt4VC9q5wdizP+aeJDiEQDY=;
        b=z1aY/CTKX5I5VwdWLNQZGojdEosTlk3Xjc/sX6Q9CwBDdB1q7BfTYuzhUbSbJemoBQ
         SLSGCMiZEsq/jzyfRdrSVtHqXkVqA6RtOzgwS1yQYM2MOElx/TAy7q4qUV7eif9auZ4h
         lNBq/JcAwusKo2VYuqxWFqTxifD6HfvvgEfWuXwH7UE0KlwKYvUHM1upwvVHDS0g7OZI
         ONxEYc5+X7Svymtew4p3Kj7iTlknYn53pHPo7dSBGadViJ4jZqr9NHqaHz3vzxD1uNh9
         78As12smzvi6C0IVJ8l7y748Rn0E1iHxpqtEWUw2ARcCJa6P7lvq/F7Wa4ufb7DFfda6
         cqjQ==
X-Gm-Message-State: AOAM532wQSVLIpA3VG1CcDNFv24eQjA4niY4cA7DMOTBX6NyHXzBaip5
        FhZeANDTnyl7S4N3UW5nvMkGxf4/rAT3gGN4z4RcIcld
X-Google-Smtp-Source: ABdhPJzNQ/D3J+P5lFg8VFfei9L+uWNmSxm8Te5WcP3eVpNNHD0iRMxXcLL08rz65afKdE/58ciEDRYOH1SGpNlTMSw=
X-Received: by 2002:a05:6512:3981:b0:448:40e5:cf90 with SMTP id
 j1-20020a056512398100b0044840e5cf90mr15342168lfu.656.1648395430264; Sun, 27
 Mar 2022 08:37:10 -0700 (PDT)
MIME-Version: 1.0
References: <20220318185644.517164-1-miquel.raynal@bootlin.com> <20220318185644.517164-6-miquel.raynal@bootlin.com>
In-Reply-To: <20220318185644.517164-6-miquel.raynal@bootlin.com>
From:   Alexander Aring <alex.aring@gmail.com>
Date:   Sun, 27 Mar 2022 11:36:59 -0400
Message-ID: <CAB_54W41hPU-7Z3AqyLUst7Fohdrqtf7gP3ycmh74jqcnksQzg@mail.gmail.com>
Subject: Re: [PATCH wpan-next v4 05/11] Revert "at86rf230: add debugfs support"
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "open list:NETWORKING [GENERAL]" <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Fri, Mar 18, 2022 at 2:56 PM Miquel Raynal <miquel.raynal@bootlin.com> wrote:
>
> This reverts commit 493bc90a96839ffde5e6216c62c025d2f9e6efc3.
>
> This commit was introduced because of some testing capabilities
> involving ack handling. Not we want to collect errors so let's first
> revert this commit, then right after reintroduce the Tx trac handling
> which is the only one that makes sense for now.
>
> Suggested-by: Alexander Aring <alex.aring@gmail.com>

I didn't want to have a revert of the commit or... yes I wanted but
not in such a way as `git revert...`, just that the whole debug
feature is dropped (which was introduced by a commit) because you
implemented a real first use case to make something with those values
now and do not leave a half of the debug feature upstream.

Nevertheless it's okay, this way will do it as well...

- Alex
