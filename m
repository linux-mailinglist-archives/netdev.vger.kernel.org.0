Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CC301D8D89
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 04:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbgESCUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 22:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726302AbgESCUD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 May 2020 22:20:03 -0400
Received: from mail-qv1-xf2e.google.com (mail-qv1-xf2e.google.com [IPv6:2607:f8b0:4864:20::f2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EFB7C061A0C
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:20:02 -0700 (PDT)
Received: by mail-qv1-xf2e.google.com with SMTP id g20so5784262qvb.9
        for <netdev@vger.kernel.org>; Mon, 18 May 2020 19:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=fC/7m9P81Xpu2A4hvZ0/KaGj6jX57sEBYUYJfnXdagZEXGlbCyVGscogL70w7BsnMB
         syRNIO3HjC9s58tQTvHKqGPh0DH2UyaHo6w3V1gAHY7bjntLsZZNhDyd3YiNH+TT90Yv
         SV9htHYkoHPqOCTCYoKnF6OxqvF5PYEPPAUJLKtvVsvTppkWylASr2Cp+CIU71U+vN/y
         IlSwBH/UTk0/w+JR5WXl+1H3AlkYoXfUIhxhj+PPLYLIRzTwlmN0q1uGMT4hlUw7Nq6f
         jreHA5L3c5nBdUlQ9Tutj82Bw8Maa426PfdxIFGVRaxOGqrVa98gwCuDGCFBeurNHUx7
         CXpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wjunn4+x2QEs4HRrQcozT7INn2DM0lGSHIZkmkDz3T0=;
        b=tTaOChZussaFUcZ8z4Mz7oX0lqps93ElD8SiCNo2FSdox0SIHSI5HUagsGZCJ49Zt7
         xTQDzlgNMHZsReO1wvMWQ3uat3OWTobc3FsUwaUuaLoTe3cLjc4/h6fWsy1iuoTfMNOq
         Zs2A1tkuZl3TtTLHMlTL8/Re94UjXTHX2nUfJcuDdWmK4+HsXet3b+LNWVpg3c1G0oc1
         aGgx/bRp9Mj1fF2FDKeRq7wQWI4t5FGsfJ/h3GXhDuIvXH2oltclPVU7geNPZkWarpst
         dYKt4S2c/oMbje1sLhkBZfdeN3Ozil0M6+CBaxdTuuO4FEJfRGzreyW549e54tqUL91d
         qjWg==
X-Gm-Message-State: AOAM530wfLPOSPSMuC9FhmpWcNy7KY7jWZzGXOzW75egDH3Pa+Z58jZZ
        JLWf6hmjUeChhd29pR0d4PRgb02A3t0O0Vkeb2uy6w==
X-Google-Smtp-Source: ABdhPJytWcuWr3mA6rg9/rJaL4yz97PHqOYU3K6TAsj7Qkcw1xoOYACkSYdCxUlaXgx7S4EtqKQhZVqHO9g3v87TAVw=
X-Received: by 2002:a05:6214:7a7:: with SMTP id v7mr19172477qvz.27.1589854801172;
 Mon, 18 May 2020 19:20:01 -0700 (PDT)
MIME-Version: 1.0
From:   Bhakti Sagar <bhaktisagar1@gmail.com>
Date:   Mon, 18 May 2020 19:19:49 -0700
Message-ID: <CAKY1ijE5od-zndb6oWgRF6t2Q2VcfOGNCErRc8+p_37y6A1CuQ@mail.gmail.com>
Subject: 
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

unsubscribe
