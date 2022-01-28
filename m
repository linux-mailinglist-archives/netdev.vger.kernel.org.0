Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5AC24A01BA
	for <lists+netdev@lfdr.de>; Fri, 28 Jan 2022 21:12:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232439AbiA1UMz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Jan 2022 15:12:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230374AbiA1UMy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Jan 2022 15:12:54 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE4CBC061714
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 12:12:53 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id v5so6162316qto.7
        for <netdev@vger.kernel.org>; Fri, 28 Jan 2022 12:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=DkhOJxPGb96XhBNxvczEuJ4p+whH3mGtofLewGhWrCU=;
        b=dLv3b/NecIx6dJ7aWhAY26exhhW5mPxtQfTWOqo58SA9W1ExgO0PEOwxgHOqaWtHhB
         xE6hCufQ1YRozpafvUMcL7xUkRlqhhk4IF+uDUwWzvg5qRTCDYqV78n1Vq0MkQCX9hn1
         gMNfNwlkoeYccsNnF2lMtQfvBQWJl5PAgsfg3SyjYfhzdZVd42ugoWxFQB/RkG85W/ap
         8am9+l6IxKXhek6lEPqrWqZCBg3kQVWchdvonyDJi3AlsoLFAYdSQm5Ql3JoPbquPBDd
         V6fzuja4cCRfZ8SRx4t4XrAsr672kXkJcfVNCLglBMpCHarNs51Q3GCWswGwUMoHK8kW
         ZztQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=DkhOJxPGb96XhBNxvczEuJ4p+whH3mGtofLewGhWrCU=;
        b=1iq5D1mIna7XzcQFhWkRlAVsah2/Wkr0xhoH70bqpqC1Z7JiRYUjvMPLCJ5gQgDhp3
         08xW/vETuaebRnHoBPmCGxxMNvboDVcDc+HLVpJVNJNYOCNFIpYKfc6yF6igjtZny8G7
         k62fVYotcenazCRvaqZqwgSnnr4B57Xj5BGmxdGGkH3PqtpxRVqL1Px0yLXFemi0xpNX
         8wwtsokSNXgbgTsONjN2nlZfVfL+lbfsV3SoAEG4HSKOO/g5oHFbZTx481qLold/1gZf
         ZnW8l6mqfxz4kCZnVmG4XuxLbXPfO0cT/tLMHqmzOsNYBUZX92229o8rjxuMNXLaeT8t
         lBIg==
X-Gm-Message-State: AOAM533tTi3wxSITpurD+6pBpK3H3w16qrSzq4huzcGFMCixUuM7+75T
        AAyJ34F5jzwfIX/2b5CiAEa9xpV1j5uhXCoRgFQ=
X-Google-Smtp-Source: ABdhPJz0kFgjR/WTRZAhBj87BK0AGPQHSCbvynJC5iSa7xzbUoabMVhZJIb6p+zG428i3EV711Gq4a2wf/qKLWtUOi4=
X-Received: by 2002:ac8:7d8d:: with SMTP id c13mr7550155qtd.129.1643400773087;
 Fri, 28 Jan 2022 12:12:53 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a05:6214:2529:0:0:0:0 with HTTP; Fri, 28 Jan 2022 12:12:52
 -0800 (PST)
Reply-To: fionahill.usa@outlook.com
From:   Fiona Hill <ivanroberti284@gmail.com>
Date:   Fri, 28 Jan 2022 12:12:52 -0800
Message-ID: <CAKp8dfptLAzsJp_A55J2v4gzJmg_8O0EdA0GcgtDGqTgkcAMRg@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

-- 
did you receive my message i send to you?
