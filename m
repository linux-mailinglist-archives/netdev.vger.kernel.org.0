Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A0BA48CE93
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 23:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234685AbiALWzi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 17:55:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234670AbiALWzi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 17:55:38 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 209E1C06173F
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:55:38 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id ie23-20020a17090b401700b001b38a5318easo7930567pjb.2
        for <netdev@vger.kernel.org>; Wed, 12 Jan 2022 14:55:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=d5oiBR0fRDJxqfLJMDImd5Sux00aITDOMAZc/PKXfC8=;
        b=QOyjB7PlU8+ekDkkCcjZSo9+1bQnjjcBTlFtNk5B9CRJtca3SCZIVYkwwlqFg1N6pz
         ymVkNroVgCw7I0xQjQtFpp3Np+oyqS0EUFg7kW6sUkDZnCP7HQV6Pqunei+qXJKnIaRK
         6B7CqKHQNDKHtvYVqWOk5tkALgiD1m/CJT7LL3PaC3GmmjQ9AR9C86Jrl4x5CECjmJ2o
         IRNPeZ/KX/XiIOdruUPRP9idMy4GtEtHzJL+7sRs9p2buVT09YaUyhSms85XUdEmerG1
         2GPjMbniDGtY6+rP6K5HjmW0JsYZSxppKMOuK7xrXkZaplYwSnWDTEGlzalGTG+TJpKV
         +s0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=d5oiBR0fRDJxqfLJMDImd5Sux00aITDOMAZc/PKXfC8=;
        b=X7llgl03Lee5cerwGEs8pF4JYNepcQ5RtCZvEqjXBkgMxrzhtsNm0iaY6AutPPTXfB
         sU5QB90sEH2U1XkBfbJD6VExeEz6oSjnO9/b8+B15Hp1buPECbf85lxbXq1Xrm7adDup
         ldiut7/PJhi0PzTnEssEqDtS9VLDU/qr+zvjCba3LkZ0f3KD5UPidKFyjWxNI0nS/JRG
         lTFmUgIAQbJul59GSTxkDwFGKPHk2UaO5v9E9Nj/buXHrCePbxJHdhf/L+SwMpGpfByU
         XOTdEWBaUiXRenT8tNKJwv8LkcFCI9PTX5whNKvGjOHJyGjLaBEB76S5erB/GBTDFNPC
         EFlQ==
X-Gm-Message-State: AOAM531QgPhhJoGyutM7hTDOsx6Irru8IL3RwiLoZmiuT6j/h9okRf/W
        gSfWy+A3Q273VP7tUYsI0Dn3qtkDOHzJCkEdVFk=
X-Google-Smtp-Source: ABdhPJyi4Q3gAItYnsToMrawln5PNwaBEsZsuxX3WvgsPUmYQgkxncN2Sm5bY5ynghchg99AnBeC4SylsAVRdp9gRv4=
X-Received: by 2002:a17:90b:4c50:: with SMTP id np16mr2017649pjb.208.1642028137736;
 Wed, 12 Jan 2022 14:55:37 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a17:90b:4b4e:0:0:0:0 with HTTP; Wed, 12 Jan 2022 14:55:37
 -0800 (PST)
Reply-To: fionahill.usa@hotmail.com
From:   Fiona Hill <angelaemmanue@gmail.com>
Date:   Wed, 12 Jan 2022 14:55:37 -0800
Message-ID: <CAKpYVvCyDz3Y6ii-5N+dd3Jxms0tC32Fcj4PUwKiRz1cj0TsMw@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 

Happy new year to you. I expect a letter from you i don't know if you
receive  my message?
