Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B559739B186
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 06:31:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229573AbhFDEcr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 00:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbhFDEcr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Jun 2021 00:32:47 -0400
Received: from mail-vs1-xe30.google.com (mail-vs1-xe30.google.com [IPv6:2607:f8b0:4864:20::e30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DA42C06174A
        for <netdev@vger.kernel.org>; Thu,  3 Jun 2021 21:30:51 -0700 (PDT)
Received: by mail-vs1-xe30.google.com with SMTP id x8so4200440vso.5
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 21:30:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=zsBvuO69ZfYWWXbuFAdVQ0v18QOeHkSwguZfrgHI8gc=;
        b=kfSNSxkV8MnyBXn1dByT5L1YVryDBF9cGHIDXcclcDEKpi83gRvtwY8zVLr0jMdj8v
         7e2w0hyYKYXRr5nf/MAV3NJAREiIqtAdKqbBgAbB1ztUCxXvID6NJnuhy6/MchC9Flao
         kScPjyoPLQit2VQbF4hiZV6MB3/F13kkxlLrxaXXh6q4lSuNtPpHoq5yzxLFoVATG7Wv
         TVyWFKo0zD3450O0xUC7gPOmKgXG5s5436Uhjk7OYR1yyRSlzl7TdmkRSbaC2JU1bfOh
         mdFIa+DsSuN5zM2ovBzETzR3Z/Rr7OGCq5x79KbezIkaYAA09TKMUmAVJqveWQfyUdCg
         uMBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=zsBvuO69ZfYWWXbuFAdVQ0v18QOeHkSwguZfrgHI8gc=;
        b=CAVHqKBup5B1/tzW9xvf0Fq27BRWfWKQttl8mJ0mhcZKTdYfW9a5WGhrhCbU50VZwP
         08wL5OA2YpPnBltLCoEATe3INTLrZx1ywny32i0micV73589inWqowqIz5nlYe3zdDqZ
         VuuP35YKce6N98E2+NNEUVpgic7eLHDGJOqA5FwMOLDhpmXT/DLjeMHmWfFek0Qwllux
         iSwHlyHGP56BkVzwWhibkVZE2CvpyfRzytFsv1z19TT+QKXcJe9nEC+S1MuccxZX8k/0
         OzGC0gO0K6QvBQcpyVIBhSf2BsO62Hqpo08I42V91B1A77Ww1adIkuU2nofpo1YqZghC
         oqlA==
X-Gm-Message-State: AOAM530/TKNJqwMctQZ8SPZOzZEXEo27AHBn4Twrklc5tsC16DtDXBML
        z+BK8un5ZbsAV92y2ie5TeVc6wd6aoQfKCcGWsewI2D/2BjzVQ==
X-Google-Smtp-Source: ABdhPJzKKMkQPX0aJVopxLU1wViTus6OTTJT3nqRbaQD/Hff7hDDI6+BsAW7Zkjolg9myLhxzzDE4dL/T1bMCPSltjw=
X-Received: by 2002:a67:1a45:: with SMTP id a66mr1325407vsa.15.1622781050421;
 Thu, 03 Jun 2021 21:30:50 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?B?0JzQsNGA0Log0JrQvtGA0LXQvdCx0LXRgNCz?= 
        <socketpair@gmail.com>
Date:   Fri, 4 Jun 2021 09:30:39 +0500
Message-ID: <CAEmTpZEv7k8663ssuWSbM7MSFwQF7QNW7u1cCg_amfao=_cg=w@mail.gmail.com>
Subject: iproute: if%u documentation
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Referring to interfaces by index using "if%u" is not documented.

So `ip addr add if%5 1.2.3.4/24` works. I want to use the feature in
my project, but absence of documentations for this way stops me from
it.
I think, it should be documented and also added to help messages.

-- 
Segmentation fault
