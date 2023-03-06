Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAE576ACE75
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 20:52:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230079AbjCFTwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 14:52:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCFTwj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 14:52:39 -0500
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD647416
        for <netdev@vger.kernel.org>; Mon,  6 Mar 2023 11:52:38 -0800 (PST)
Received: by mail-lf1-x12f.google.com with SMTP id m6so14307531lfq.5
        for <netdev@vger.kernel.org>; Mon, 06 Mar 2023 11:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678132356;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vK8bUdNSf/W3Da4uxUdWyBTkoZaxWgGFcA9KQyMW+lc=;
        b=QMXOn5FGLPsohxN0MV3UiZWTs0N5uCl4naiA/CO2mqdFOPdyUJADxzUCLkJLSaDRpA
         xPk2pkyefONdZj8weQDkQjVnQZ/3hCsqaXhBOWfGMQie4D5su9vKS0y+gzBQPuE13B0R
         zhbd61uZiqW+rTgJcfm8vPLUv/AgdgQP2m/jhrPVpSzf2oMuPkn0xEIvFHmw+Q3WdNya
         RjrgHGWFryGWZ6EdkLJ3qL9IfaxV9znYLZt00tHN1kgqqnDcDHB21CvyNyp2WYhGG2jY
         XWyJCBtJDxeaMLIGx0gJP1mXwZoNlcicffzpJ+MYjC1JJoUaipqWw4i84hSNo6na9Ni/
         qGpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678132356;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vK8bUdNSf/W3Da4uxUdWyBTkoZaxWgGFcA9KQyMW+lc=;
        b=W2fcDM05zTJhHO8j1ql3cVYT7bupvJvruaUWcBmBqZQV/bb1Thg8ovG32K4X+HGJlM
         ZlJykK9WiScejlazjtZAemh2Vy4dx5uO04lbnfOe42Z7XsVkGeeKXqmxGCLd/qQ1s/cl
         ROEDg1mn1WTtpEsHERx7pL25YJiIh/9BFco1Z+6/OTPzbo0r7c+WB0+3MAJ4JbOcCCpz
         l/A5g7j8Vl33u16R/pY9Os6kpvouBYVXuCKtVIL4440C+SEi1KxSiPBk7AbyvXpf0PFV
         FzBTIB7euIwJKBTzVrGjgkegn8saB5wyT1+hXSVeIDPpYnU19A0nNNCXg/vV/7QQKZXJ
         v/SQ==
X-Gm-Message-State: AO0yUKWLUrbffP97OTUXwh7AqYijwAVKYS9yBAwo7xpwNvxvFliHYFEO
        j5Z7fwIvhnMfsvNzZ5/ajnA6IL0RyZ1a4jplHwo=
X-Google-Smtp-Source: AK7set9U1STubYe3bKa+z/Q//EDbhn9V8ErRoeO5JmVAQs+i8tdpRR5B2SfuShimTJ5ZoTRBymmvtftXKMlPeARKCM4=
X-Received: by 2002:a19:7517:0:b0:4dd:805b:5b75 with SMTP id
 y23-20020a197517000000b004dd805b5b75mr3644430lfe.7.1678132356240; Mon, 06 Mar
 2023 11:52:36 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6022:31cc:b0:38:de19:723 with HTTP; Mon, 6 Mar 2023
 11:52:33 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <rw49060@gmail.com>
Date:   Mon, 6 Mar 2023 19:52:33 +0000
Message-ID: <CACL3VFOdFHMMV2ehU2uE2qTPeunH-L+9GG6Lggnn2AEzQ_5Yfg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear Friend,

How are you today, I have an important message for you just get back
for more details.

Sincerely,
Mr Thaj Xoa
