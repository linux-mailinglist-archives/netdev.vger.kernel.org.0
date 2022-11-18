Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7484762F359
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 12:09:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241862AbiKRLJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 06:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241712AbiKRLJP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 06:09:15 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58C78C49E
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:09:14 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-3691e040abaso46154127b3.9
        for <netdev@vger.kernel.org>; Fri, 18 Nov 2022 03:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w1OFCJVJXs+H4Yp4AIq7xc52tiltb20f2ctRYUcHABo=;
        b=iwmO9YsNvZMud07oTY5EGraYNiCB2NAe36KBGkPBDNkfSHe9TzdVessF+TA592WA6K
         OuKcZxD3Yt3T7Fr+j2eOxw9up9CZEYsO30Av92cdrjcRPee5joXGG13DxzZo+ifBBCEA
         kdG8aIZskH3fUhBmF1kxwaeebR5UEhlKA8SfhrJUsxJEP+jqaA2ZvSBRmVZahDLhzr51
         wSsc2cy16XB6hnwGoiTHiR0pIMqF3gNShA0AUe/sZmMWn1O9DM6+x50EYyNQZFEu2qC1
         vYCRNrzqsv7wH3hTJJi6OUPxVHYAfjneFCCODmoIReWErh9DaSrA6kx3vHw7Qay/5li7
         DYWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w1OFCJVJXs+H4Yp4AIq7xc52tiltb20f2ctRYUcHABo=;
        b=EzuTAYhquZd/U4YPnQVs97SVOmQWPlSfzgspkiO1tyB30tDKiixrT5Pl+//UJJGWLl
         ukH8tIRuKt/H24zJkM9WLXRwJm3Ha+LhFThv6HE8mWDaGCRTSttvkkeCaqw0i8Ay6HYx
         2+kInyfVeqpGn6V7M4f1nak5nTbMN7n6TLgRBXotnbw+TYhvcSNbeR2mFkR20fTXtltS
         BtCQZLZ3AVpsSn8VJoHguk89cNqnJShrTF+xWS3QvxxexK+g1BSDqT7m93IbkBtKxEjh
         lS9XTHCoI2TVDXEqaanHXg2ybI9aPXP5oVFW0n5YjyAAKTLq3h+uR2zlaWlOA02WtHQc
         aFNw==
X-Gm-Message-State: ANoB5pm5bV6Go1DOZENQ6gWMHH3I2e93SNGdGvwrbMaBvpqaHjJ8CuIb
        jyk0/fedmsAA1LzYsrUNshfkczisczTk2tzQm2/OysnrNA0=
X-Google-Smtp-Source: AA0mqf7wzDvZGM1UZn9CwEK+kM8wKPG5w1NOMfceUqF81CTUPhc5YKuWfnLX5w4hmjpzCGHYFoqyijQPfofjTqqoanY=
X-Received: by 2002:a81:5f04:0:b0:393:ab0b:5a31 with SMTP id
 t4-20020a815f04000000b00393ab0b5a31mr3908051ywb.55.1668769753653; Fri, 18 Nov
 2022 03:09:13 -0800 (PST)
MIME-Version: 1.0
References: <20221114191619.124659-1-jakub@cloudflare.com> <166860541774.25745.4396978792984957790.git-patchwork-notify@kernel.org>
 <CANn89iLQUZnyGNCn2GpW31FXpE_Lt7a5Urr21RqzfAE4sYxs+w@mail.gmail.com>
 <CANn89i+8r6rvBZeVG7u01vJ4rYO5cqe+jfSFvYDvdUHyzb5HaQ@mail.gmail.com>
 <87wn7t29ac.fsf@cloudflare.com> <CANn89i+iRoHnJ=+MFB5N3c36t5AeeDpd7aHqheBdgKjhNH17qA@mail.gmail.com>
 <877czsplx3.fsf@cloudflare.com>
In-Reply-To: <877czsplx3.fsf@cloudflare.com>
From:   Eric Dumazet <edumazet@google.com>
Date:   Fri, 18 Nov 2022 03:09:02 -0800
Message-ID: <CANn89iKZcq1Y81OH=qsVWbgpkW=gKC-jwRo4PC05PBcPpo55fQ@mail.gmail.com>
Subject: Re: [PATCH net v4] l2tp: Serialize access to sk_user_data with sk_callback_lock
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     patchwork-bot+netdevbpf@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        tparkin@katalix.com, g1042620637@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 18, 2022 at 3:00 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:

>
> Sorry, I don't have anything yet. I have reserved time to work on it
> this afternoon (I'm in the CET timezone).
>
> Alternatively, I can send a revert right away and come back with fixed
> patch once I have that, if you prefer.

No worries, this can wait for a fix, thanks.
