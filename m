Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8A2624AD3
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 20:43:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230311AbiKJTnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 14:43:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiKJTnP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 14:43:15 -0500
Received: from smtp3.cs.Stanford.EDU (smtp3.cs.stanford.edu [171.64.64.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6799445EFF
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:43:14 -0800 (PST)
Received: from mail-ed1-f44.google.com ([209.85.208.44]:43952)
        by smtp3.cs.Stanford.EDU with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <ouster@cs.stanford.edu>)
        id 1otDSD-0002ky-H8
        for netdev@vger.kernel.org; Thu, 10 Nov 2022 11:43:14 -0800
Received: by mail-ed1-f44.google.com with SMTP id i21so4715870edj.10
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 11:43:13 -0800 (PST)
X-Gm-Message-State: ACrzQf0j+6tWI8OMoTxyt9ysLUU8rZGHQo1kdA9x5VZur9LF7PG46ZbA
        gGtql/f0rlic/gRZi/TI2VkipnE0/PgzI7fT6eE=
X-Google-Smtp-Source: AMsMyM5VNCfZklUS92A4uKWrVc4om/HZmHDyPwyVnPSynUeFXlzyAdNjxPflVPBhe8xNJP/eVa4uIOCAL124qddg3mY=
X-Received: by 2002:a05:6402:3898:b0:461:beb2:76e with SMTP id
 fd24-20020a056402389800b00461beb2076emr3180550edb.5.1668109392698; Thu, 10
 Nov 2022 11:43:12 -0800 (PST)
MIME-Version: 1.0
From:   John Ousterhout <ouster@cs.stanford.edu>
Date:   Thu, 10 Nov 2022 11:42:35 -0800
X-Gmail-Original-Message-ID: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
Message-ID: <CAGXJAmzTGiURc7+Xcr5A09jX3O=VzrnUQMp0K09kkh9GMaDy4A@mail.gmail.com>
Subject: Upstream Homa?
To:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Score: 1.7
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
X-Scan-Signature: 4c7a780eb20f40a19c8376fd8d8b00d5
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Several people at the netdev conference asked me if I was working to
upstream the Homa transport protocol into the kernel. I have assumed
that this is premature, given that there is not yet significant usage of
Homa, but they encouraged me to start a discussion about upstreaming
with the netdev community.

So, I'm sending this message to ask for advice about (a) what state
Homa needs to reach before it would be appropriate to upstream it,
and, (b) if/when that time is reached, what is the right way to go about it.
Homa currently has about 13K lines of code, which I assume is far too
large for a single patch set; at the same time, it's hard to envision a
manageable first patch set with enough functionality to be useful by itself.

-John-
