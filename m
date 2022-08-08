Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE3FB58CE7F
	for <lists+netdev@lfdr.de>; Mon,  8 Aug 2022 21:19:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244309AbiHHTTA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Aug 2022 15:19:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238416AbiHHTS6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Aug 2022 15:18:58 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 711A2105
        for <netdev@vger.kernel.org>; Mon,  8 Aug 2022 12:18:57 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id e8-20020a17090a280800b001f2fef7886eso10058918pjd.3
        for <netdev@vger.kernel.org>; Mon, 08 Aug 2022 12:18:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gateworks-com.20210112.gappssmtp.com; s=20210112;
        h=to:subject:message-id:date:from:mime-version:from:to:cc;
        bh=L1vC5R5YRVDMXPDH+NOmmzYAffT011Zf5qHIpaSkIDg=;
        b=NKZvuR8iNR3x3TearM8MpLRex8/AiPuciaQXaCmUSb/yVHV6f94LrLuUKXanVXMHHk
         EvLTCQEYUTERn9srXXgeT/dhceYNgBs0U8GOoh99O/juz3LqeMSY0xHyFISs9PjFLK72
         l0O3COR37Cjx/PvWJkYH1382o8u85/XcgH6tGTed0ezpE0X1Xufz/zaxcj9t+3H7jfS5
         gapgOvKKE1dVj2ZbHZNTXJS4bst3UfnqROAmPUhWt6gN16hs6N4zmCaWBeUv4ggu1+uT
         1wl3dZ1JGSmJd6dIOf81c3psSbMP6iYp6pMhsi+IUokxCyvUmkaEMeGBzOFoTvClXX8t
         C64Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc;
        bh=L1vC5R5YRVDMXPDH+NOmmzYAffT011Zf5qHIpaSkIDg=;
        b=1rRzVmeW8ne7sm97HlSgOG/j+zCdgCUhBh/vDb1g4ceCAxo0UT6AlTLh4srmlpmUgb
         22fyBdWiirwAXiS3jZceDfpli76bUnnyZftk0zud9/4jmCJoanY7Ioyw2P/D0kFNrVmc
         H3hUxYrnzkdohLrXb28oUU4GOSHtX+GfsWAPr+iESf7DOyn7spR1myPyX7scDg8QfJFs
         JnUpP7O9kMDCEUoZfXx5jPZkvqNF4+m05ZOsH3nZYRkTXh93Yl2V7+rujLiJimaNaLAq
         r/qmtv6oWVTx1dOWTcaUp5f6UIvU2DW1cI4+19k09otjUCJKMv8Tzo3Q+zHxHxZjWEwE
         kFvQ==
X-Gm-Message-State: ACgBeo1NRwTyx+LYU5cZjhnOJBVnNMUuX5iYbuc2TfUqztTj+8QCLG/Z
        5g6+yR1JQ6p8e91+JesPi+4WQo1oT4+vgwTObzvWedXiMRkErA==
X-Google-Smtp-Source: AA6agR7lCOkO5x+WRSnUaTgYhR/py/8C9CwUsLFoPEOAXdZ6LjzVs/E/Y0R+yHYCvghw0L0ChhAW5o5Khe9cRt8OqSE=
X-Received: by 2002:a17:902:694c:b0:16d:cc5a:8485 with SMTP id
 k12-20020a170902694c00b0016dcc5a8485mr20017314plt.90.1659986336483; Mon, 08
 Aug 2022 12:18:56 -0700 (PDT)
MIME-Version: 1.0
From:   Tim Harvey <tharvey@gateworks.com>
Date:   Mon, 8 Aug 2022 12:18:45 -0700
Message-ID: <CAJ+vNU05_xH4b8DFVJLpiDTkJ_z9MrBFvf1gSz9P1KXy9POU7w@mail.gmail.com>
Subject: ethernet<n> dt aliases implications in U-Boot and Linux
To:     netdev <netdev@vger.kernel.org>, u-boot <u-boot@lists.denx.de>,
        Device Tree Mailing List <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Greetings,

I'm trying to understand if there is any implication of 'ethernet<n>'
aliases in Linux such as:
        aliases {
                ethernet0 = &eqos;
                ethernet1 = &fec;
                ethernet2 = &lan1;
                ethernet3 = &lan2;
                ethernet4 = &lan3;
                ethernet5 = &lan4;
                ethernet6 = &lan5;
        };

I know U-Boot boards that use device-tree will use these aliases to
name the devices in U-Boot such that the device with alias 'ethernet0'
becomes eth0 and alias 'ethernet1' becomes eth1 but for Linux it
appears that the naming of network devices that are embedded (ie SoC)
vs enumerated (ie pci/usb) are always based on device registration
order which for static drivers depends on Makefile linking order and
has nothing to do with device-tree.

Is there currently any way to control network device naming in Linux
other than udev?

Does Linux use the ethernet<n> aliases for anything at all?

Best Regards,

Tim
