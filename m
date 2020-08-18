Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11191248297
	for <lists+netdev@lfdr.de>; Tue, 18 Aug 2020 12:10:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgHRKK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Aug 2020 06:10:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726366AbgHRKKZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Aug 2020 06:10:25 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B31B8C061389
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:24 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id o22so14644473qtt.13
        for <netdev@vger.kernel.org>; Tue, 18 Aug 2020 03:10:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=1DZc96nsT4KrcrRRSvUtdp6sHSIj8H0qj/TSPwBMbws=;
        b=W0EQ/ELdURpP/Nc2HfaWB/mckHvFiZ1VTnm0JyrpXzuyvFWCVYIFrP3SXbnmlR7niy
         WK5Ub/DfgzZHPbZD6hsqMl1pITvaq14W1Fy1QrCVPKyqPJyHWIn7XPmZGM+bB+7XRk60
         JU+s9j8I3U/9H7/mWA2ihDLvf90Ti5HRQ7gDFVu1CvUVrCkRQkFxvfImjofQ81oEYsE3
         OWXlEsUukZ6VpILIahhldNaM6vbwOdxnotugbDQvdY3YmyxaIbxoOhv1Q5r9V41ASvew
         1fHiHI68bfd1W+KQTTSHtxSbjBlsLGcr3oTF8ONP8iHmHMjh6hsQRJjDFKBRVxoy54ao
         IzEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=1DZc96nsT4KrcrRRSvUtdp6sHSIj8H0qj/TSPwBMbws=;
        b=fUKDoldn2hmRV/19twNthl7dI+DAh79smoe8BKRbPxfojm8x3rrpFBvIVADA2KsHvT
         y3TopUjdE8tLB1OlDNBhzr+kfHOc9KhYIvWvdti0bKhXh1tL88xkWZZgUu1coPs5OCgW
         yeQW6NWNAqs6wp9oX9/2sj4b9Xfi9NNy0SYW4/hfgazttodfLMBHVM4rzjHrOl1xI2gS
         Vy+oN/XBZCpCeJo56zBbwDe5wncdH24XYs4rNNoMreECeONcKJZYxAlnGQyKLuvC6Cox
         yPepxJNat6DeSAvOIBtRLUUCxmPsZjQ0d3ATMokpetSWeGswzdX4imPVwiDJTQJIKGIQ
         j4WQ==
X-Gm-Message-State: AOAM5327lCKbUR/55l+JWF48FqE04eCrs7IQ5MKHf1fWqP1Xq275Orwz
        Ad44qnh/457EgQNTILy2RcGSYaWIgfc=
X-Google-Smtp-Source: ABdhPJz3hbKtY4yk9Xlx6ltbR61V+9My/fqzWj2hixGULJ/XByah+xiKowNjLGQdqwJ7qXdgxP11Qg==
X-Received: by 2002:aed:22cb:: with SMTP id q11mr16792707qtc.200.1597745423579;
        Tue, 18 Aug 2020 03:10:23 -0700 (PDT)
Received: from localhost.localdomain ([50.236.19.102])
        by smtp.gmail.com with ESMTPSA id 20sm20632139qkh.110.2020.08.18.03.10.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 18 Aug 2020 03:10:22 -0700 (PDT)
From:   xiangxia.m.yue@gmail.com
To:     dev@openvswitch.org, netdev@vger.kernel.org
Cc:     pshelar@ovn.org, Tonghao Zhang <xiangxia.m.yue@gmail.com>
Subject: [PATCH net-next v1 0/3] net: openvswitch: improve codes
Date:   Tue, 18 Aug 2020 18:09:20 +0800
Message-Id: <20200818100923.46840-1-xiangxia.m.yue@gmail.com>
X-Mailer: git-send-email 2.15.0
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tonghao Zhang <xiangxia.m.yue@gmail.com>

This series patches are not bug fix, just improve codes.

Tonghao Zhang (3):
  net: openvswitch: improve coding style
  net: openvswitch: refactor flow free function
  net: openvswitch: remove unnused keep_flows

 net/openvswitch/actions.c    |  5 +--
 net/openvswitch/datapath.c   | 35 ++++++++++---------
 net/openvswitch/flow_table.c | 65 +++++++++++++++++-------------------
 net/openvswitch/flow_table.h |  1 -
 net/openvswitch/vport.c      |  7 ++--
 5 files changed, 57 insertions(+), 56 deletions(-)

-- 
2.23.0

