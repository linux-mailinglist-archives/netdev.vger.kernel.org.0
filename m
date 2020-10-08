Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41872287790
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:36:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731002AbgJHPgP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729833AbgJHPgP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:36:15 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC9FC061755
        for <netdev@vger.kernel.org>; Thu,  8 Oct 2020 08:36:14 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id x1so6309411eds.1
        for <netdev@vger.kernel.org>; Thu, 08 Oct 2020 08:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=exyQJUA4sRs7CeDnU2+L4csbJdnwL5qaQHsz7gkchybttNghXCe603FUXpKH11h+RV
         K7iWEu44kTLwcNhbJ0x2C9Ajli6j4FH9zPn6bBQW8Wg4yury8pcgm9zjQOe6PyWLKlAw
         F/zb3TtGo7UfEuslo+/AiIMhhkbSjQeoEQme0Lutycspr/h52jspBQ8Ex5yDn9xt1x35
         N0FQs+lZ7cwaI+JukmoLvmWKrXfuSUNvjfrvjqkOO7ff4QykWqGL0qPS0baPV7f+7+Cg
         xAA2xPtbpYWz8YzP7d0dTVzwDwOJY29lYeSmoo2ZgQltBGf4cDU0MqXP9sH/uOqvsqpU
         mMKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=OG/eQQeX7SvKx5avPhL+xNoiHpAGJENCxah1cnf7JmlBdX7FJ3NJbkP+BE/IgV7+8o
         AkhOgqP9QPLbqtKEaI2GxsA9yVplYBUJDStn6SJEuejQWXav0RQWqVfzV5Ow3ne6vntl
         c3ibEOJNwOS4nLptdyFUtx7r6O/XrAdPUS9Q8IgrQVJkBvmdWQQRd/cp7LFbST6EQJJv
         3n8TygcuGz5ffUSSnzh4qTC+vQdnSkJfYw5yfZTvZEphBEl8G3PeXWXc9ne2U1DQJjVM
         5xVhJnlelREv/HYfzZMXFPrucxnynx/8ZyFdrIoTSqc8gEFo+5paxLefmWkrvR3Q5zEx
         t8IQ==
X-Gm-Message-State: AOAM533E8S5/AYmfAELojkf6n8x3PX6FkmYTvnyfDyjKqO2oOG6nHhbM
        Ih+U55g0xzejN7GCZARbddeZ2BZoS6J/H0JbdMI=
X-Google-Smtp-Source: ABdhPJwA4ElxwnJH1VVh3U2/C8sutNdAZ9A9ja3KztVMpSv/PuFXA5M8wDONMFl2QehAs1Do9XK8PD9Ul3CibZUjizo=
X-Received: by 2002:a50:e442:: with SMTP id e2mr9846587edm.186.1602171373600;
 Thu, 08 Oct 2020 08:36:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a54:3b8b:0:0:0:0:0 with HTTP; Thu, 8 Oct 2020 08:36:13 -0700 (PDT)
Reply-To: mohammedmusa082@gmail.com
From:   mohammedmusa <mohammedmusa082@gmail.com>
Date:   Thu, 8 Oct 2020 15:36:13 +0000
Message-ID: <CAOi8f47OmLGMAX-3358Sgjkrn3qFHK-S9siH=pVG426CtRkDqw@mail.gmail.com>
Subject: =?UTF-8?B?15TXkNedINen15nXkdec16og15DXqiDXlNeU15XXk9ei15Qg15TXp9eV15PXnteqINep?=
        =?UTF-8?B?15zXmT8=?=
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


