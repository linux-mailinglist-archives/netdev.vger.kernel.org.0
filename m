Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DCF7492231
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 10:07:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345303AbiARJHa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 04:07:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345346AbiARJHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 04:07:18 -0500
Received: from mail-yb1-xb2c.google.com (mail-yb1-xb2c.google.com [IPv6:2607:f8b0:4864:20::b2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E66C06161C
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:07:17 -0800 (PST)
Received: by mail-yb1-xb2c.google.com with SMTP id e195so23620791ybb.7
        for <netdev@vger.kernel.org>; Tue, 18 Jan 2022 01:07:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=AIHedDQeQ2nfeFyhlIY6iBZ7Eo/kAlP72EhStgPHV1I=;
        b=YzhnDX/mPEneGMzgPa3dCb9MUrLbMllH77Iq4UrJ9q2c1DDyzQpvjwvZ5j+2VaOBoX
         RFLE4f72gZu1cxPicl8LXrv+hMJvU05bdWpeEO85lAHtEVPc9o5s+0zzZw3h22/0Zfn/
         z9ErGxTqHRqVxcYCU6r0+PXKJhVkymNIYBAxQQgxjU7fp9G+5u6mHogz6BaAcQX2Na7C
         24qyjhq2TeqEQHXiYPb4ps4lQqX1baNEdfTjMj8Diftcrq3ilKNF+o5MIAieQ/ABz0IK
         HCBZTYZUqbU9/lN4A2Zqy9Rht7BFZr0TQuE/2QB+SlISTshTCiD7XG2IkWY8wRjQ3ZVQ
         wnpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=AIHedDQeQ2nfeFyhlIY6iBZ7Eo/kAlP72EhStgPHV1I=;
        b=ulLY4UGmTTyjBjQiEwTls/KI0e8L6yydb56ZpekNBNLB8Cp9MIG8/xwi7L82QQnbwR
         FP4ntjGqZ+ykycXmuKA+yFyDEA2QZmFTBG2A3ZRY9dS/ZXvH+QkImOCKVN/yNUMoRxJ4
         7GTDTVs1cjEkZMzzyigiYY3pXAPNBXGo69MHko1r1NWj2DnBlIRu1WTU5IGgX7/OK3p/
         6u9UDLMyvVRy9dwwD+6S1naM7shVytzLLt1sKeyxtfcEejTOjRQZNc7b/7EILU9r7Ryh
         n/ykJgmoKeD/GwmMtfxmN6vKHU7VBrkKgzsA34MMN4M2tFOY7mUYaGwFT6h0JHXluyYl
         zCgA==
X-Gm-Message-State: AOAM531RpcO0hWfgQEBaWITdN9GVgktTpmOFZhLhD30OKnjuS038dvJW
        LkfS6D42RZm3W29v3sClDhqqurEVUeRmv3YKspg=
X-Google-Smtp-Source: ABdhPJyF+oV2TRIWyllHntkA4Yx2yE/7b0Ikh3gc5HxYSk3zamu0u4GmsZ5fzzhdzgSjkggpcij52/5j/gLzQF94eRM=
X-Received: by 2002:a05:6902:1006:: with SMTP id w6mr18026417ybt.238.1642496836980;
 Tue, 18 Jan 2022 01:07:16 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7108:3655:0:0:0:0 with HTTP; Tue, 18 Jan 2022 01:07:16
 -0800 (PST)
Reply-To: asil.ajwad@gmail.com
From:   Asil Ajwad <graceyaogokamboule@gmail.com>
Date:   Mon, 17 Jan 2022 21:07:16 -1200
Message-ID: <CA+Yy_gBhEwRmOE8XtkDKWCw6voXv2DNRtj+9KZUeEP-BsnrQeQ@mail.gmail.com>
Subject: Greetings,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Greetings,

I am Mr.Asil Ajwad, I work with United Bank of Africa, can you use
an ATM Visa Card to withdraw money at, ATM Cash Machine in your
country, if yes I want to transfer abounded fund the sum of $10.5million
US-Dollars, to you from my country, this is part of the money that was
abounded by our late old client a politician who unfortunately lost
his life and was forced out of power Du to his greedy act, the bank will

change the account details to your name, and apply for a Visa Card
with your details, the Visa Card will be send to you, and you can be
withdrawing money with it always, whatever any amount you withdraw
daily, you will send 60% to me and you will take 40%, the Visa Card
and the bank account will be on your name, I will be waiting for your
response for more details, thanks to you a lot for giving me your time.

regards,
Mr.Asil Ajwad.
