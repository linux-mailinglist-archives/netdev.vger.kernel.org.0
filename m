Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60E475E759B
	for <lists+netdev@lfdr.de>; Fri, 23 Sep 2022 10:23:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbiIWIXB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Sep 2022 04:23:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbiIWIXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Sep 2022 04:23:00 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4589F8C30
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:22:59 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id k2so12892655vsk.8
        for <netdev@vger.kernel.org>; Fri, 23 Sep 2022 01:22:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date;
        bh=qOrxwbZQQzmlea7ch7OgYPZMXBj99gl5M/LxWWADJ0k=;
        b=RddCD80t7IeamBf5j0u7Ym8g5ErwqSdQ0+AA1UGqlMCyLuxCdkFvS7jniy+zMG2GR5
         t6YJl3VuQzR5MtcQ9cz/i6Z+dst4faXBBBVFN7IAHdUXlqqkx9KfBixFGMx1iIslyTaA
         Hwo8KVC03QrGIsfgLlc5DIz5MoYLw5Jq/ulL2uicUqcoVun9p/MvY9FIUCj64/DPbSpv
         V96g99cOSbHZQo41aQvd2URifalh/Kp1bt7J9WWzYF9TG20rKdnJdFDhlkhfQj9h6cuG
         9Fi9D3RcXMnDEObbCuM6hbgCYuKVCqSiuESuGRaSnVi7kCgMFgFWFrTA3tovEQ87Js8/
         wjbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qOrxwbZQQzmlea7ch7OgYPZMXBj99gl5M/LxWWADJ0k=;
        b=YPoUvyobTv5xhB/vnw9/r7dnu9c5PfNx+GaFQ5By48atl33l2QTvfk0iyyZREGgB9m
         ElwePGR3igmPbMlWtXVRQDyCSIccr413XA0snoKZFzANhstlgb6YbLx9CEXjGX3+z8hE
         8yJO9SuS27gGy4ZZn1GsnuPKGusj1Tzhm9MXDfiXdLRpwLCNs0PG7xjmMUdYlfJJxhYr
         5L/uuPFXI/2LGvaa2siE6NILgR/zvU6bkKW47M2S83R0cgY1zEE+Bx1pjPAEiuvLDCYr
         TSlwibymBTtogsAVejaEzSpbpNQ47E4MoP+I1T/y1Jgl9BPDQcVrs976vRcR0Z1paGoc
         H+IA==
X-Gm-Message-State: ACrzQf0yf7K53G7a4v+6ZjevY/YpjgURfrpwWF5CnHSDHgZza0x7kTpB
        kv9SyYX60xOORiuKEgjHVNukLoQqZb9+HWfNGNQ=
X-Google-Smtp-Source: AMsMyM6rPfZAw5E32TDMy4Js8wZGpw5C3ETrOErdZknOjS0eEgVDZYsyTdIHi1Tle+xo5xV3TnNL2BdQUfcytXZqhng=
X-Received: by 2002:a67:ae45:0:b0:399:ce50:7171 with SMTP id
 u5-20020a67ae45000000b00399ce507171mr3138863vsh.18.1663921378968; Fri, 23 Sep
 2022 01:22:58 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d8a7:0:b0:2f6:1f39:5266 with HTTP; Fri, 23 Sep 2022
 01:22:58 -0700 (PDT)
Reply-To: sgtkaylam28@gmail.com
From:   sgtkayla manthey <sgtkaylam20@gmail.com>
Date:   Fri, 23 Sep 2022 08:22:58 +0000
Message-ID: <CA+RGHE-MFAOg-7q4B+CgY7O2MaOCSyRE77gBTF=Sg9FqbPJNXA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.2 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,UNDISC_FREEM autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2607:f8b0:4864:20:0:0:0:e30 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5035]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [sgtkaylam28[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [sgtkaylam20[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [sgtkaylam20[at]gmail.com]
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello,
Please did you receive my previous message? write me back
