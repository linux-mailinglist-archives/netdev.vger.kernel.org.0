Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8A75BC9C3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 12:47:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230093AbiISKrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 06:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbiISKqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 06:46:48 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B62C28721
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:33:15 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id bg5-20020a05600c3c8500b003a7b6ae4eb2so4374198wmb.4
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 03:33:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=zJ2NTFSuwbgn1shPsMG7t3f98JKsP5lqwb6cWvxUrKw=;
        b=mUjm281cp/WOAN2SoiW+NyKYNY/0W2euJ3FYLn/S4LEY64ngofZf7EbhqOM1RitmNN
         wRlrgg58K97krcBpVuoCTXSXa6qaxuloMHAdMR5k/tdyDy+9LzjgYw2RN1PfeNXry3qd
         SzCAgQQ3Oh+VwIY49EUa2L0gIz/+2vwkQxYXmba4JRnXJnuW+3RGPNoIqKrz0llFxxUi
         NEWbdX5uhhmc+iCzKKOVZXYAPfRKgm+TX4yXr4mjF/BBZaIuYFEcl8kNQ2Hvt/qbgrrQ
         TZYz9nIZmHRuJ1jcvppWlBulD7ZyoCYAyr+vxfcpq5Vi6AdhyrDqk/D2+UJONMD0ilXO
         BvZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=zJ2NTFSuwbgn1shPsMG7t3f98JKsP5lqwb6cWvxUrKw=;
        b=2BYgA8GMOWpE4fwfFETS53npUUSLoMhCgAbFKB2W880aj4/9vpRzz1+sHnm9I5o5Ss
         kCePDtTJUx9o0ydUgzddOevzxrQUj9bfdD79lgpKgr+E1i23h88jc0ItjXFdf7vH7n0Z
         avVweuhEPvwiNNOheqjeJpDBu8XW7y/4sIB81Vw9lpvWqKFxFCynP1p2+ArMyRi+osxU
         qixNQERCLmDwkiiFTUSCeN9Nb4HvswLu6fnqTn2YJNVyemXZ45K7nIdZnYtNvNRDKXPK
         tWF1v/DtzQBNwRalz6oV8mLK7UhdVXN4otOl+7O27egJjolgJulHUTBD8zskEFgzJwyF
         GBNA==
X-Gm-Message-State: ACrzQf3tmL3A/b80RokTJ3bNU0vpjG2PbTtWqADgBEfiXmQ1xWQOOie5
        vpcd2p7RndyTXMUwObXj8pll0io9FidFWBmTN9E=
X-Google-Smtp-Source: AMsMyM408TdzuOiEjfWCP/cZAcZsaksURpdl84YImmA9M7s9cu7TT8fDgBH6DPXzvThumqhZaX0PP2n5KGysCOJYdI4=
X-Received: by 2002:a05:600c:4f0f:b0:3b4:c09b:37c5 with SMTP id
 l15-20020a05600c4f0f00b003b4c09b37c5mr8821552wmq.181.1663583593649; Mon, 19
 Sep 2022 03:33:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a5d:5984:0:0:0:0:0 with HTTP; Mon, 19 Sep 2022 03:33:13
 -0700 (PDT)
Reply-To: rw7017415@gmail.com
From:   Richard Wilson <barristermichealakpan@gmail.com>
Date:   Mon, 19 Sep 2022 10:33:13 +0000
Message-ID: <CAHZ=omyStgKHh8-z2ibUTrD9S-or=PZjpEYc7KAf1eiD+hEjrg@mail.gmail.com>
Subject: Deposit
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear
I am contacting you to assist retrieve his huge deposit Mr. Alexander
left in the bank before its get confiscated by the bank. Get back to
me for more detail's
Barr's Richard Wilson
