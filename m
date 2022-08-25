Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD1B5A1098
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 14:34:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241773AbiHYMeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 08:34:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241753AbiHYMeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 08:34:04 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F695B1BA3
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:34:03 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id l23so8249874lji.1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 05:34:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc;
        bh=jCJsXsDD/iNK9yC84Ot8gXJYydwvdgJYruOO+RMKvrI=;
        b=X0emtHDFGDi9aZeHp4BbPnWfi2/2Y32/qXORcbMbYWKU3E3zW5qYD2fFIX9vkLLtbi
         GaxVEAVJ88+KouE2ppQZ1YY/cHhojhRCMC+vYQvEyA529wnA7GZYMADaflfACAs+eo9S
         LpWxcvfP08C6kv3IIx+pF1r2CpLfNnjV5HYFfJ98nZWa695TZCeQo9FvF7JycXV5HX1y
         iGzw5FSl03UOLGVwYURZ1S7qSEZtxQRN3kDgZnPqXfF3F0rbcF8zK1GSKzUooOwi6vv+
         +jCBhDdJmpvL8ugv1xyrnxp5d6WZ70yIpp6RMlwK5mHmMlwA+sOxcvkaRKaJT+f7J/0N
         3chA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc;
        bh=jCJsXsDD/iNK9yC84Ot8gXJYydwvdgJYruOO+RMKvrI=;
        b=ZEvun9qBX6vuKbYyyQZ96ISiP+98CV25rHFoYzw8HfhG7C098rJT7QrhwWHz2V8tll
         7RZEasayS7NQB02bGS2LfRMZ2nD0mA4q7flBn6HtOOqWWg+4grpZbpRZGR9rNGExIAxA
         JJhCJSi8YnrAOcS8y6/hxEul71TytB9+bbykH92SFhtCmECTPucBqmc/4naAONPwOAMl
         Epq5xH4fCU8psYSfs+njgd+H5OIUedf4c8VrKw+XLcg9kKv+git7xiT23uA9p3EiEdAe
         WAmBCORv5zrZqkBtI4/5UJylgcbjUEA/NyM538a1goRodlbxo2W39jye/Wd77uLcb4jh
         6LGg==
X-Gm-Message-State: ACgBeo3W/rqWkieRZyvJB/yHE5iQuBcCAEWLdc7zMxC/RSTOgCb+zlC7
        yygwUO7hp7s3LBEvQSdxKjDU70d8UW3WOjPlfLUmASTKba8WrA==
X-Google-Smtp-Source: AA6agR6P48JPVyPvNYYU45h+T28rV7KicTf1wAxtBzXQfFFtmoh/0TG6In5HCdF/3tGmR1cHKNPnpP1O8JBei2WPMG8=
X-Received: by 2002:a2e:5cd:0:b0:261:a774:36d0 with SMTP id
 196-20020a2e05cd000000b00261a77436d0mr1080313ljf.312.1661430404639; Thu, 25
 Aug 2022 05:26:44 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6520:2f81:b0:211:5365:cd04 with HTTP; Thu, 25 Aug 2022
 05:26:43 -0700 (PDT)
Reply-To: abdwabbom447@gmail.com
From:   Maddah Hussain <abdwabbomaddah93@gmail.com>
Date:   Thu, 25 Aug 2022 05:26:43 -0700
Message-ID: <CAHUCj6ePPKO2fZ8N5TaAgUZpdqdMe+kBm_RVpKXi-1araOz89w@mail.gmail.com>
Subject: Get Back to me (URGENT)
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: Yes, score=5.3 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLYTO,FREEMAIL_REPLYTO_END_DIGIT,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Report: *  0.0 URIBL_BLOCKED ADMINISTRATOR NOTICE: The query to URIBL was
        *      blocked.  See
        *      http://wiki.apache.org/spamassassin/DnsBlocklists#dnsbl-block
        *      for more information.
        *      [URIs: again.it]
        * -0.0 RCVD_IN_DNSWL_NONE RBL: Sender listed at
        *      https://www.dnswl.org/, no trust
        *      [2a00:1450:4864:20:0:0:0:22c listed in]
        [list.dnswl.org]
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 FREEMAIL_FROM Sender email is commonly abused enduser mail
        *      provider
        *      [abdwabbomaddah93[at]gmail.com]
        *  0.2 FREEMAIL_ENVFROM_END_DIGIT Envelope-from freemail username ends
        *       in digit
        *      [abdwabbomaddah93[at]gmail.com]
        *  0.0 SPF_HELO_NONE SPF: HELO does not publish an SPF Record
        *  0.2 FREEMAIL_REPLYTO_END_DIGIT Reply-To freemail username ends in
        *      digit
        *      [abdwabbom447[at]gmail.com]
        * -0.0 SPF_PASS SPF: sender matches SPF record
        * -0.1 DKIM_VALID Message has at least one valid DKIM or DK signature
        * -0.1 DKIM_VALID_AU Message has a valid DKIM or DK signature from
        *      author's domain
        * -0.1 DKIM_VALID_EF Message has a valid DKIM or DK signature from
        *      envelope-from domain
        *  0.1 DKIM_SIGNED Message has a DKIM or DK signature, not necessarily
        *       valid
        * -0.0 T_SCC_BODY_TEXT_LINE No description available.
        *  3.2 UNDISC_FREEM Undisclosed recipients + freemail reply-to
        *  1.0 FREEMAIL_REPLYTO Reply-To/From or Reply-To/body contain
        *      different freemails
X-Spam-Level: *****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Dear,
I had sent you a mail but i don't think you received it that's why am
writing you again.It is important you get back to me as soon as you
can.

Maddah Hussain
