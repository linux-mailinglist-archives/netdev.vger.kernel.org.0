Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D75D46457ED
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 11:34:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbiLGKeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 05:34:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbiLGKeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 05:34:04 -0500
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABE9628E13
        for <netdev@vger.kernel.org>; Wed,  7 Dec 2022 02:34:03 -0800 (PST)
Received: by mail-qv1-xf2c.google.com with SMTP id p12so12330267qvu.5
        for <netdev@vger.kernel.org>; Wed, 07 Dec 2022 02:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8iVWWojAEnJj6pUA2sQB+wh6d4JleW9LhBEsWmIdw14=;
        b=D3OVKzwlqYmFXw4pKNLf1Tx5nDN4Ra53EBkYusmVCAN+d5uqQdwVjaAXAnM0Z5vpzb
         SVt8vfnInZi/2YPWdQUpXhMYy7alg1DANyqtLjbGX4hdVN72edkz2Y+GfhE0HPDf5NSY
         rRaljnQ0BowhdtCuD0Yz2f9QL0THDqzWLwPVzZZQNdc5CqWDCHzYdTUqwgLm/E+OkYFH
         gLISw93IHihIAhFc9rFnamOn0xB32Vl5JkapTgjkGSNjJvOuS8UZfzbKdoIKQww3iKsY
         8tebpwW3XLOYpReK4KdlqO8cu5xmy5CTpzdme1jnJSTeYqTYHW4r2bDc7lkIpFpVLQDQ
         ZxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8iVWWojAEnJj6pUA2sQB+wh6d4JleW9LhBEsWmIdw14=;
        b=NKW36lJzlTPZa0VFetRLKJMul//zBNk43E+29WIk0cJEf1EaNDN5KkQ72AdRsmFQbe
         z6lljY8HHKKpXAi/SNOeWwZTW7/eQPrnEzglgWLVmbzLpyrG+r25uX2IT75ZEGpEBGOg
         S5RxfR5UIgjOsBO2jnP6LdiMrtCOUVX4cKHZgAk18nA2lY18KJioCePpOGZy+4AOaR3R
         TRdZUIpJlw4EjeKvY6cPE6AHgLZMSXDSoy9NDXM9XzjpIqkpcbNeMe/RnLZstPmlZNgr
         DaBZMlrUwFvVYBqgQL7NKB6WiIMsHZmvcr7jEp2yCILXv3zrZBw244gTgjQ5NAT1rM/2
         3Xvw==
X-Gm-Message-State: ANoB5pldwiBnTEdvgOla/fBdO150xmN4Yf5CSGI3hVPm786wJ+pm8RmC
        UqhskXgOa3WazT2j9iHaeVej8bI6KAEBLp5Pfw==
X-Google-Smtp-Source: AA0mqf78btU0xDa53RmDgGrlnI+3m0zzsJMOg6DKSS0wDSnBG9rEQtXYh9DqJ8V689Ivkjx6oCg6LGQoNssHB1zCE2Y=
X-Received: by 2002:a0c:bf4f:0:b0:4c6:bcdd:3162 with SMTP id
 b15-20020a0cbf4f000000b004c6bcdd3162mr61701786qvj.15.1670409242643; Wed, 07
 Dec 2022 02:34:02 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:622a:2d2:b0:3a7:e999:f914 with HTTP; Wed, 7 Dec 2022
 02:34:02 -0800 (PST)
Reply-To: michellegoodman035@gmail.com
From:   Michelle Goodman <michellegoodman035@gmail.com>
Date:   Wed, 7 Dec 2022 10:34:02 +0000
Message-ID: <CAPJ5U19Bz4NfMoNrf73bx=x-DMfmRieSeOV6O9LJY8-C8ix_zQ@mail.gmail.com>
Subject: :Hello
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=1.1 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hallo! Lernen wir uns kennen?
Vielen Dank
Michelle
