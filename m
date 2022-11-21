Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8370B632B31
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 18:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229541AbiKURjh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 12:39:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiKURjf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 12:39:35 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB7F8C68BD
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:39:34 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id q9so11987256pfg.5
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:39:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=XjB/spLyXcyfSqGONyTTPfHpVe863su81+JSYMScefCyCX2nj9n9+ts4RFBAx1zPdI
         1yzMglKom6j8QdzasdQquq3mJUSQb8hvtOZkbKCO2XhaAYhxPYn0QxGwBCs6w/igXlCD
         WDvSHQ3IEIY36AiJMGULIoSvdl393SE3y1QHiDJYSWgl2P66QZ6XFr822NBOvlkaBoDf
         YKfTCWULgnmHR/+dtPyLHTfZDj1t4BEvV7ExvVFoMiKiyqIvzRuJvA3kfQEFGw0llLCj
         xXjQsethcTbxcTcA4exitotQXDRVd3kt5dIGkVHZxNcC9rsJ9XvikNU/5YgTkjtfU1Y/
         Fw3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:reply-to:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DLuxvrtTwLpjQCdZkBOlAPtT4PuOt7o3XUb4SWGRYeY=;
        b=ae4Hd9pKpOPtFXks+xLeSDudCmStzbICHfhnjfoqNDiSl60oC85LMex38RTa4hlclM
         R1/ge/FBek6r/+jzcuS4WuxDOIiCDU9iPXLXnJE/XJHY/6MDHaxhGSJ2vinbWtNsuZdM
         JVarAqTTPZJpMrFHH9v6wPp+/uaCxPbY4V2Zc15yuWFLKSfBuggUvi9B23RrPeO3KXfR
         E5cc33EdD0Fp8+8GJnKHz/GqBKtjx2jcIQwPcGAhvVQfD8j146IhMX0zg0jtBRcJnl1E
         w5/JVMZTxAv5w9Obb3WbY9ga92lto5QJfvfj0GV5qsv9FzVMEte7xR0DiJ4jwgFk7JZU
         51sg==
X-Gm-Message-State: ANoB5pnxhl6+QVYcPPuDLJpONGM5/s+qIRDMoV7QgiyZTuUGAErRuIzs
        e7trjLcOwubqm9RMdIip9ovjDS5tEHPbCz+eiYU=
X-Google-Smtp-Source: AA0mqf6ICttQCEpTAXzTuxr2XvYTSXURnZYDNdpAwS7afUXvdPLjNwX4+tWNXbVGOvBo+IksEoMXh2Yf0Xc3g0a1M/Q=
X-Received: by 2002:a63:de14:0:b0:477:4a61:eb99 with SMTP id
 f20-20020a63de14000000b004774a61eb99mr10619401pgg.48.1669052374432; Mon, 21
 Nov 2022 09:39:34 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:7301:6c81:b0:88:fbe8:9336 with HTTP; Mon, 21 Nov 2022
 09:39:34 -0800 (PST)
Reply-To: thajxoa@gmail.com
From:   Thaj Xoa <andrewcamron1611@gmail.com>
Date:   Mon, 21 Nov 2022 17:39:34 +0000
Message-ID: <CAGFyNuWi2at9LFHQcxkdFuL4=_rDk8x0oco23wwEErMnFioj9Q@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.7 required=5.0 tests=BAYES_50,DKIM_SIGNED,
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

I have an important message for you.

Sincerely,

Mr thaj xoa
Deputy Financial State Securities Commission (SSC)
Hanoi-Vietnam
