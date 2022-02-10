Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CAB94B1843
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 23:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345020AbiBJWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 17:35:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:56102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345024AbiBJWfN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 17:35:13 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8727F2737
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:35:13 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id u20so14423955ejx.3
        for <netdev@vger.kernel.org>; Thu, 10 Feb 2022 14:35:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=MWT7TlY51pVRi08fmufQ6B6wl4dgaxY15dwxgYKurua4wwaJm0NFKCYqDW/xkdcB5I
         8ni/K6R2P5nt8lvpy3b/coR1Pe5szu1YfowZCnHPwknpsV1q0xSLdJFq1nqqi0mB0IQz
         EHJKaWyTw9+zTkIBfWysoFAyydFSOZLuRjCm2ywbVXF9fXpxHFMdOI5rXJhYEfc4ciQm
         qCahiY+r8Gf+TZamHweViag0jzBIyg1xrnZ17pma8wUIAcBYSX2H9F6rHauyLkD2ihyH
         KCHUZpCyDrSixQlkdA2uBcNIRslkpZ2GOp5YOv6MIvXcBr8oFbAGLbhHbIJFVjJu2gHK
         Hc9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=gae0iqrJma0ubJGx+korPq/UL8n+mTcx7+m98ESw/To=;
        b=b3shIWbVF4P+mDfIvu1KdOxZ579NLkcn2mIxkK7fcADQBoZmX+TFIqUuPXwaF6g1H2
         eooc8CLW5Yr0d879swzeU5O+DOpzxspjv6w50RdUxoU+2TRdpHlxYrwdTvxCeZjdbSVP
         kieCzOI5BfAGXFa+XrCy88vSwxtwV++gaoDdiXtqkIVdg/Dl435vN7WENhj81QHCEXEB
         XaKMrpvi92mVZYX4FEHyNh1f3mygvJqYLHCZNwGX9A0XrNbp9EAX8VBH89WlEBdUsih+
         ORv0Dks5t0MirtHLSixn3E+6N0Q9M4QWz5fRqbSYcZo72vovIExAiVIJQxlBmR4vY40h
         iyJg==
X-Gm-Message-State: AOAM533/Du4+UFXEDPc27uqbVhNJdWcoNwSk+uc+EASCKTE7mHuAmlX6
        5g/Rw5/4gH6xZOpbfG3IpscAhKkNvd1CeQ87KlQ=
X-Google-Smtp-Source: ABdhPJxQdmhxEp0aSaJzVB7rh/WxR3W7wn/CJpjgW1pY1LwC2BcGexWROxuihpr99iUlbOep1OUXLCTfodG55JiMD4E=
X-Received: by 2002:a17:907:7ba3:: with SMTP id ne35mr3156964ejc.100.1644532512184;
 Thu, 10 Feb 2022 14:35:12 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:907:7b98:0:0:0:0 with HTTP; Thu, 10 Feb 2022 14:35:11
 -0800 (PST)
Reply-To: tiffanywiffany@gmx.com
From:   Tiffany Wiffany <klouboko@gmail.com>
Date:   Thu, 10 Feb 2022 14:35:11 -0800
Message-ID: <CA+Adgp69rG9Twt4PRGqP9RfXYL2=kYL-=b8K5cgu6Lp7otkCjA@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNDISC_FREEM autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

Hi, please with honest did you receive our message ? we are waiting
for your urgent respond.
