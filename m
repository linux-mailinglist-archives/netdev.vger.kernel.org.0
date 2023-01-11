Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A79666333
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 20:00:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231286AbjAKS7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 13:59:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234648AbjAKS7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 13:59:44 -0500
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 107213D1C7
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:59:43 -0800 (PST)
Received: by mail-ed1-x535.google.com with SMTP id w14so6399565edi.5
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 10:59:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=I0JA6d6UV2PSHLhm63X65leZmBU8x30oJ0jmNbaSxaKkMGdhnAmp0tn1TH4xQwRKS+
         864cfYiLlDV0KvsRzqbIAODrhtjlFMTjeuHxVgyPtXfGZuxLnA1/s4i/c73T++nBBXqX
         48Fa1IZ/ldwFPcYC+JTPZGla9D/5gHNi4k9maIVDBML+dsyBS0Yy6uMZrOvbNebrcmP7
         AwLHDw+DIZMwu3eL7CL4knWB6ucjoO0lOXTcVSvTmobaz0DjaOBv803jKnx+BtAZKnn3
         FycMKqxzuAfhrSbIHHmtSXToUtb7Ylrmi1T+q4CQCmuZ+hy/s27Q9/dXw+mAe+NPcjh/
         QWSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SzBlYeGeT15Xra75w9IZDBjQ7Da3XKSmRdlnDJDYrko=;
        b=fB/zHUBrsltklm7kfUGRklny9FLZWt6703fvNBCq92u2cVySloVAsiq0frlzbULpW3
         oCL9A4UgaPsDlEj1QiL2hEgQr1Ru2rLAiKT4AxXaaHJgf5eVwN8XJAlAPDrAEAIfq9cs
         +8vEv3HcvCDdzkAu8tL92E4FOgpl7u79RmuSwN0rqGWBINjd0SuC57xbpaxr+sCPobK0
         eZ7yie4c5BYvm1ZVvaj0ymXFeKBxlStSdDur20FEhy+TovwDBeUh8BRtxmf0KD04lOK1
         yWSQPuI+HJW1z60BGgLBshh3R7cDPjXT2096PZXoKOwKj8BFhqCzJB9DTSpdxHBcHEy+
         sQDg==
X-Gm-Message-State: AFqh2kpZOHCHNJfzcnW3QLBxix7RXOIr8t3XwZrGZdgtw/iNxWyfmGNk
        uxFHqulHYwD4dfh5Ze4SIGjhaiQftOK1O0xJ1Mw=
X-Google-Smtp-Source: AMrXdXtEM7QbE34KxODJHtPxdlDMPVaaVRTpm9raj60/ISRjulHv5KI6QmHwE2U+5O5oR2VqGGsWmhwxvOsu/octM+c=
X-Received: by 2002:aa7:cd01:0:b0:498:f125:97a2 with SMTP id
 b1-20020aa7cd01000000b00498f12597a2mr1898381edw.109.1673463581580; Wed, 11
 Jan 2023 10:59:41 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7208:9020:b0:61:2cef:f0bf with HTTP; Wed, 11 Jan 2023
 10:59:41 -0800 (PST)
Reply-To: mr.abraham022@gmail.com
From:   "Mr.Abraham" <davidkekeli99@gmail.com>
Date:   Wed, 11 Jan 2023 18:59:41 +0000
Message-ID: <CANAp_-dh-_jopAi67i5jqzcTYvLTybbJAQOwRM_NdKgH4yzyHg@mail.gmail.com>
Subject: Hi
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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
