Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA637596C49
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 11:51:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234383AbiHQJrp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 05:47:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235174AbiHQJr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 05:47:27 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6FAE74E37
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:47:26 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id gk3so23573701ejb.8
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 02:47:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=JIfDfXKs8K3oxhbnlS3K2h9y1e9IsTdORXqjVH+tm2I=;
        b=NYVuLuR6IZjLdHhmYHO7cMZeKoHs/V5knTQx6mvbOJRNvKOsSW2zxSDZAUaBfyCCnU
         Rb++sgcik8qtrGZBwqA6hWfPs4Hgr7iBEohuV+EeCIGQX96oVeSiDmlqocj3u0s6BjET
         VwUQzHoxWqAMLhTijlVavOO3SovFwjeokHzKBVWbIswX/n+r7s7QDF9Xhg0sd0uhombh
         kIyWBvf5moW99j+H6ZlSPrwX3omi+MGXTjfOsYw4ZGcD70N6XWmJgJbKKh8Yk2o2r78g
         nuwyOaiEt4tG7prA7yRXs+CukG+ygLRBCOyzgxjv9ootkWShiNragAEbitKjQQkMJkME
         uiww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=JIfDfXKs8K3oxhbnlS3K2h9y1e9IsTdORXqjVH+tm2I=;
        b=JQdFPTx4Uq+tuP4hZo2LqNY4w0D1UpX/pSmrC+8HQGmJYtuAx04eQ9F7eIVjHwAdvo
         NBAb0uy5wpoatcN577i3WUPHd0TorcMs/IcRMBMmuCiRzAzW/B/QFTHh/e6nM8ByoVFg
         pGqtLlXvMjT7qViqLDV7byMmxP2oUd/nHCvmyDB9HmpUTngu9w6AAgudhx7C3xhaXHzv
         yf0y51iR43XoR8LjeMtXg2cckI0dQihEZN0bZwKFc7QV9M5sp1f9CjZhRKl8YsmIoURQ
         vuKswZHddrT7zxl0SfWau8gO/SoPr2k+9vJrIIS/8mM++YhPx6Q5y42M/EEyms36Ruga
         cYTA==
X-Gm-Message-State: ACgBeo09CJ17xRg7cJ6Psf6BfWjQy8NPCPn83T9b2acEmSBkS3TQm1To
        3FKYHbJYrkDBr23m3i2yB+nJqO5nJ6P7twBK2eQ=
X-Google-Smtp-Source: AA6agR6cbBETyvGDp7Qqwn0DxYsYYOxO1VKqB+WPD2BEiNWz6xUxecGKVP3QHbiVdmjkJ01mvL6ywN4Zem3exk6fDtQ=
X-Received: by 2002:a17:907:781a:b0:730:ccea:7c29 with SMTP id
 la26-20020a170907781a00b00730ccea7c29mr16204562ejc.85.1660729645202; Wed, 17
 Aug 2022 02:47:25 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a17:907:8a14:b0:734:bc2f:7423 with HTTP; Wed, 17 Aug 2022
 02:47:23 -0700 (PDT)
Reply-To: mr.adamyawo@gmail.com
From:   Adama Yawo <dossoamadou4@gmail.com>
Date:   Wed, 17 Aug 2022 09:47:23 +0000
Message-ID: <CAKFgWkvCiULXR5y8aZ8j4511GB58uXDXE9fj5panhP_O+7RS+Q@mail.gmail.com>
Subject: Re: GOLD FOR SALE FOR SBLC/DLC,
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=7.4 required=5.0 tests=BAYES_50,DEAR_SOMETHING,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,SUBJ_ALL_CAPS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:636 listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [dossoamadou4[at]gmail.com]
        *  0.5 SUBJ_ALL_CAPS Subject is all capitals
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [dossoamadou4[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  2.0 DEAR_SOMETHING BODY: Contains 'Dear (something)'
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.1 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *******
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Sir/Ma

We are interested to supply you gold bars at a considerable price, for
serious buyer/ We pay Commission Per a Kilo for agent. and we accept
SBLC/DLC for our gold bar guarantee as well. Contact us.

Best Regards
Adama Yawo,
