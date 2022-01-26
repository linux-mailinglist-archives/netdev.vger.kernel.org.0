Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97E2649D462
	for <lists+netdev@lfdr.de>; Wed, 26 Jan 2022 22:19:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230390AbiAZVTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jan 2022 16:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229569AbiAZVTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Jan 2022 16:19:41 -0500
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E059C06161C
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 13:19:41 -0800 (PST)
Received: by mail-yb1-xb2f.google.com with SMTP id m6so2559207ybc.9
        for <netdev@vger.kernel.org>; Wed, 26 Jan 2022 13:19:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:sender:from:date:message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=DjXbsuZyPWTRE9J9sQHgE+lX4DsVsE1aXOQsHxwPDFdl62UecPRO8uyVEvtbtuhNyc
         JWw3KlxOrTaqlvpfitZapGG+9kUla4409sNVU0+LJiOam3f2oRkMVYL+Tpz6VEV0cVyK
         WWsU2c4fW3tSHFcos8K8hBVHDMLOp8R2DbDTolOzZ+Lxapv7mzANVYGgHbDjBxMbCMuz
         VBT3xkSM2j72mPtEWpQs/xuAOWKoQ2sOTmOYIf/4jkC5MG50SNEmupIBcvGEhQa4Vi1W
         sb0BbBS/ntBaEq3EdBHZ0+pvQ6r1L+o66CDb/M0QkeFwzLyw4f5FxhaUa6MyBZlpaI7a
         kEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:sender:from:date
         :message-id:subject:to;
        bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
        b=7AtKsp+mVeTr1EmDmdjyZsiWjdGA6rLrE8n1zkLMn74klZdiZmirh4vsk1e9wJizN7
         lzBfbRaNvc4sdJhgGp4JOTqD3rTBnS+RCpJ38AsdWzxKylp1EM5ADNbh8qeaViA1bzFF
         fu9iwuZ6BxGNKDV+gRVpdiv0lzVbshed+MTiFG9vpv+r94pCMaqvluWLNu4hGb3SQt6L
         PwMbBOzkoEoXkf0KOkVwptHwtcpNQgo+8vUGEH13ryX0up85+HhQYDNPBT4s78MFrdev
         qZkKx0K3np16f2xy07CQuVomptvnYMYD2T6vCrihJtSj5vRLjMS/rFC6J7t+RL5U/+Gz
         R5rA==
X-Gm-Message-State: AOAM5300sr+ru3qMH90zpdAeUukLEKMmfEuAhyZrLvwCNpYP1iS6Fg/i
        ts7ymyb5h6Kj9Wo39ZY0LT6GF6Fg0c2eIXwZjw==
X-Google-Smtp-Source: ABdhPJz90NZ77qb4N5/GoUFqujkgDJMkByBrR1bKUU6ba/SGmyKOZl0OB8qyoBwJC0p/lnNtTC5Woiq3Nl7wLMGBmoA=
X-Received: by 2002:a25:7446:: with SMTP id p67mr1077551ybc.735.1643231980319;
 Wed, 26 Jan 2022 13:19:40 -0800 (PST)
MIME-Version: 1.0
Reply-To: martinahrivnakova@post.cz
Sender: compensattionoffice26@gmail.com
Received: by 2002:a05:7000:bd9e:0:0:0:0 with HTTP; Wed, 26 Jan 2022 13:19:39
 -0800 (PST)
From:   HANNIBAL SEHESTED <a.mboma0@gmail.com>
Date:   Wed, 26 Jan 2022 22:19:39 +0100
X-Google-Sender-Auth: Xg_vnLqy9beeKq5zG6UlgqO35Mo
Message-ID: <CAGyEYSRO1+YadtGnTnUkGsU8VgKpdzbFn0GWPaNmEmTu+OE=8g@mail.gmail.com>
Subject: HELLO
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


