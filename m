Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6B6E44F002
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 00:23:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233128AbhKLX0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Nov 2021 18:26:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231320AbhKLX0k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Nov 2021 18:26:40 -0500
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99CE2C061766
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 15:23:49 -0800 (PST)
Received: by mail-yb1-xb32.google.com with SMTP id u60so27630753ybi.9
        for <netdev@vger.kernel.org>; Fri, 12 Nov 2021 15:23:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=gJgZb9EvGpebzm+SAx7VhB4vyjnvNx1S3x/DOTXcvdc=;
        b=kbdpiH/0t+5eug/zv0xRpdgCEAHpIOX8LpApFD8VlZWE30F3AhL84liCvXALwfXOwo
         9AJMxA8yVFIU967VfcR5oWc5EEKGHvjknVy/DRLhloSThvdzWwp5/60ZWJKXvA2nj0fw
         6DIbSjFkDmNMtel4Ukwc/H2/oyt2xuRxmJ3isHbAscYNxn1Iitjs/V1leIdiXghJ7v8X
         fjanvmoClGeni+JOe2kff5b9ydJrsr3m21eonNEtKjqLvZqD4gZaoahijeDMD7VUpwo0
         KsYOTrIvr+x5NijR4bAgbTbyW+j5RcveV7G0hrh+z5AIQroTc7d7+qpceb6OvdIACvqn
         xFfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=gJgZb9EvGpebzm+SAx7VhB4vyjnvNx1S3x/DOTXcvdc=;
        b=1ElZ+Fu7MGlj8TkNnhtF1YrQ3zt0cW2TPCJsQQe9fsnPOng37SqhnHcs7qQGwVWSNY
         1pDaC18kfg/1cYOcg55YGZ0BiRPRV5DP0suG5Ue+7YTiuJHb48gdmfSSKN3l0P9G4HEo
         H0HRa5tzR8XuoXwxbOe3PK64fSqw30OqeMpPo13zJd84cQSmUx3wMkt4EtZm3Imya8RZ
         FYqi/vSelusOGp1urtdPU9yqtegXvecEOfpZFzP2r9AmcTUZyELYgszYFp8pKd2WE6A5
         4Bt6waWCHIr3ivS/r1DSDSgfaNcXBC7GcxRR05oPadCrO4poiqHT4671C6gECgItqgNq
         YKew==
X-Gm-Message-State: AOAM532PYElOhJvwlHDFmHdpcXEA41Plf/zaU8x7S+ccKt3wGlkisl0F
        HSdCkQ4TtGwqD00zt3TSCPleBtRJ0+jEUA9AsRo=
X-Google-Smtp-Source: ABdhPJxdF6WjwwCvUqzvE/YqJjc9YG5mrZFop7ZIAtS37+UbYONgPsatyCUO2zZT/Sq4fjZJjAG5EG3f5qprV2cuMA8=
X-Received: by 2002:a25:bd52:: with SMTP id p18mr20002394ybm.484.1636759428811;
 Fri, 12 Nov 2021 15:23:48 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a25:d6d7:0:0:0:0:0 with HTTP; Fri, 12 Nov 2021 15:23:48
 -0800 (PST)
Reply-To: fionahill.usa@hotmail.com
From:   Fiona Hill <fionahill578@gmail.com>
Date:   Fri, 12 Nov 2021 15:23:48 -0800
Message-ID: <CAFw126HGLgG+sV-WQy51OVKbn5uQgRmA6-cbahuEp9rVg5RXvw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
Hello did you see my message i sent to you?
