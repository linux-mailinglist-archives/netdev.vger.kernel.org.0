Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEB647717
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 21:15:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229984AbiLHUPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 15:15:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229990AbiLHUPQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 15:15:16 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F997E829
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 12:14:54 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id g4so3029919ybg.7
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 12:14:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=nnLT1fTTc7s1QepCKI43zHeurxVA/WJa+bDEq5t2QDVIFeb+XySnVpib5K0WowVNuU
         HiqxVd/6Fw7RXxVS3zZxaChjVtx6CpglUfnsilcLLSAkmlPma9tottakkyE2q+mZrd4h
         GIDchEHjrTjh9AWmQX0ljl3gufT3gS28XdibDA2BpwtILWI54bip5EX14HsWBfN3c0iH
         xr8EOFuweFfqSH5l1f+U3RqS6JnrSRDqMz24Tf/QSTFgcB8iokKdMazo3ieW5XB5sVWG
         tIlTABKXppn+9mFdiY0QZPSOfPtpXh09I0ZymHXv8ojtvFX67Ry/9kTRm0bGavItweso
         ayiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=LAUPfjmHcOH88rC+SA/p2zYSoVDxDvHBL4G7pBZmAn0YEZa/4iq5VDijoeJMvbsb0C
         dah3gfqYNBCUzkUJmhyYG0udqvzzFP0AR6lBfpPLaKsWYH9P+P3Ih5xNWKNh5nUT67e8
         HvXpUHRUUOuJKrB5l+NoruR5LmIL1CXhUdu2cqsGbBLYliB2rqiO3kmA28wSZ5wCH8K9
         H7lzbk4PtgMov01Jer1SR8A47b97VS7pAzJEF9bxOKjWWIrzymib/O/TepWoqJ33dGW/
         JSJLBTPfrUl2WbSRnvL3JXQmfs4cVc/fa8sVJMxQKWhKb63gYWI83MBlyXEABIGR/paF
         jWKA==
X-Gm-Message-State: ANoB5pmHvJc94KuTkhB2ho32QjDOszP9Y1aBaxNRvdb0ddbdA5LGB6c1
        uilqgWA/0Gnq0A3l5akZ2qYGHpUT4hTJO6i4tb8=
X-Google-Smtp-Source: AA0mqf4pZYqfLpC1YjEgCR9gZ9RXO/TRJmN28YNIw6Xaby/R5NGiliYkwj+THJbsWgJJr83nQvk0esKeO5vhy+0vCgk=
X-Received: by 2002:a25:b03:0:b0:6f3:eaf5:4da3 with SMTP id
 3-20020a250b03000000b006f3eaf54da3mr59522492ybl.193.1670530493760; Thu, 08
 Dec 2022 12:14:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7010:7a8c:b0:313:9136:3d25 with HTTP; Thu, 8 Dec 2022
 12:14:53 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <davidkekeli442@gmail.com>
Date:   Thu, 8 Dec 2022 20:14:53 +0000
Message-ID: <CABGDXtrYLdqQwMtqWUzEN26aSTg0nKrNxpq9+CjLX5Stk05o_A@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.9 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_HK_NAME_FM_MR_MRS,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My Greeting, Did you receive the letter i sent to you. Please answer me.
Regard, Mr.Abraham
