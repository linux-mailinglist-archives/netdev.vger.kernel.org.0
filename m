Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D277D36BCC9
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 02:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234700AbhD0A6R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 20:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbhD0A6R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 20:58:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FBABC061574
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 17:57:32 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id f15-20020a05600c4e8fb029013f5599b8a9so4028402wmq.1
        for <netdev@vger.kernel.org>; Mon, 26 Apr 2021 17:57:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rasmussen.co.za; s=google;
        h=mime-version:from:date:message-id:subject:to;
        bh=RZCyttgOMoY7n0WrkpMs3KNmHby7s5VlUoAa7l5OB8w=;
        b=V1u6c88wrHgVOePgOJX85tCLDeWJOH5dWNhTN5q157qS4vOkqlHdLGhqWVMwa2iR/a
         LSfkdY90unIMMGdTBl1eztZuQ5+iVdKEJoov+z6I1nAgGtCeQfLjyOTTSGFRTXNda6l5
         lYg32VRC/jZbMtG5kKDE/PyjnKy2FoVbw/FuQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=RZCyttgOMoY7n0WrkpMs3KNmHby7s5VlUoAa7l5OB8w=;
        b=hRTUQsz6h8aW6aCcD3sC58DYbUZZuR1fqKBggYLIIXpILyRrcRtW4CBeBmdYJFDxoK
         fsrRstlr/UN5Rcs/Ukc+wpY+mInGSXgvcKbr5S9bqclM4osHCNDVkUYLi4HOm9/TjO3T
         tknctg6tekc4ZAeoIyAD+eEUmKnDTWAPR9470PgwgHB+uSzTJLIH9o4hnftdMXn1XXOR
         XX3UhP4GsHeZhQAPexzYe5p6R0a1TsLh3jl4KlRau3q1UsRDgUl3Yy9BAdTrfeG5klpK
         Hxk+WC1U0HcXpxAVouLopmYIxOgxzeQLxcSIvc8TM6odV2UJbVRtubQ4dpdHE7RcDaYN
         HWug==
X-Gm-Message-State: AOAM5325+N0G6gThSAP0/74Lfync5R+iXtfryllaUHr2J92G6qUfRmQK
        FM2svPRkx10lOm6nEWI2pA+D92izK2229ZknejP+rxAMPy5gQQ==
X-Google-Smtp-Source: ABdhPJyL5vUb2J0Dui3yhcElqjLMX3sEmNCyq2OX4w8qQIEGNH4EamgQYQOGofCQu/Z0plYDXERHhD60xI3INxORa6U=
X-Received: by 2002:a7b:c5c8:: with SMTP id n8mr22799789wmk.2.1619485051028;
 Mon, 26 Apr 2021 17:57:31 -0700 (PDT)
MIME-Version: 1.0
From:   Norman Rasmussen <norman@rasmussen.co.za>
Date:   Mon, 26 Apr 2021 17:57:20 -0700
Message-ID: <CAGF1phZANG3gV4Fa0jMYpgbUbWRsnakb=AvJ+7gYtdd1KqQV1Q@mail.gmail.com>
Subject: iproute2: ss: feature request: matching dst or src host/port
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I think it would be nice to be able to match on dst|src and
dpost|sport with a single predicate, something like "host ADDRESS"
(expands to "dst ADDRESS or src ADDRESS") or "port PORT" (expands to
"sport PORT or dport PORT").

Thoughts?

-- 
- Norman Rasmussen
 - Email: norman@rasmussen.co.za
 - Home page: http://norman.rasmussen.co.za/
