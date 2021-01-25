Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC3C304A0E
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 21:26:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729176AbhAZFRk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:17:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729861AbhAYPgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 10:36:07 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C559C061222;
        Mon, 25 Jan 2021 07:23:00 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id g10so13031622wrx.1;
        Mon, 25 Jan 2021 07:23:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=OOTy6fNrhJY2K2USMMux+wkYQZdHpCv0X8RL8tZbIEU=;
        b=HgWwTns+zy4irzb2UxnAOmScmhS/xutBzEqYQCws6MB/PZwmJv1cJ0RaaPHSNYUwfU
         gVhPCjLHjbQHtopqjQ6clvFk0jIa99vV6d5WKGsluy0B1AL7KODMB4g32faHQAqcOvE6
         QDeq7cnG3RY26FtdAxx9sSAx09InH8AwoOH/w5d4ki6EcZLQVVO2VwpuXjPi0fZkorBB
         XjI8nrnZ1QLIwIAPtnxKE/WyyYqbRbvaUaeVp8pSlgo7qzmutyFIuWmC0o8x99mV63uh
         scDwyXh3+hiey6ktOb0pTUeVYLoUmxrlDfP/JSDUsklTIuB7fLK/EtwFj8DXN+WykvwI
         fUdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=OOTy6fNrhJY2K2USMMux+wkYQZdHpCv0X8RL8tZbIEU=;
        b=O4bhx/T4GxRfQY4yj0/hRErpS6boG9Vk8kdGe5PumyV1zeP18oczeJi85U9qePOsVt
         6GSDYrr6bX5zGwRuMzlAnBfBxZZwunimyxpdyy9epO5UxU6S5ppBUT86ZGwCCM4cvQix
         CZWmKqJmZkBGALbILEfZbMIfFlPlLa/lPsgxUxc2NTLalYlKItUxLNISKflovuKK+DiG
         s2D8bDG+29iRWDhh/i4yTnOX5O2RtYAcCr/f1Qn11MCP1oClSlLZuEEiXi5TnL9MvE/p
         pC2xfwuvhkytuZ2fki4cvuXg0WE7EDHZcRvHNl8JZ/tEvlev+0UP9yzb8iweHE4ek8eo
         Jhxw==
X-Gm-Message-State: AOAM530hTGXiZhjEW0Daov5KlrLf1bVrvCcBARIURWR8LMPLWoFwoZ+w
        f5JCalB60sRYx9+kRo4a7Os=
X-Google-Smtp-Source: ABdhPJzb3WmqjpPKO6PKDfrZ2pGpWIH/ADfEzi0kcnHuuzUQ+P2Tcnx6b8BfdZ46g+JWnI/BO4Earw==
X-Received: by 2002:adf:83a6:: with SMTP id 35mr1563489wre.274.1611588179101;
        Mon, 25 Jan 2021 07:22:59 -0800 (PST)
Received: from LABNL-ITC-SW01.tmt.telital.com (static-82-85-31-68.clienti.tiscali.it. [82.85.31.68])
        by smtp.gmail.com with ESMTPSA id l84sm13071307wmf.17.2021.01.25.07.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Jan 2021 07:22:58 -0800 (PST)
From:   Daniele Palmas <dnlplm@gmail.com>
To:     =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, linux-usb@vger.kernel.org,
        Aleksander Morgado <aleksander@aleksander.es>,
        Daniele Palmas <dnlplm@gmail.com>
Subject: [PATCH 0/2] net: usb: qmi_wwan: new mux_id sysfs file
Date:   Mon, 25 Jan 2021 16:22:33 +0100
Message-Id: <20210125152235.2942-1-dnlplm@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

this patch series add a sysfs file to let userspace know which mux
id has been used to create a qmimux network interface.

I'm aware that adding new sysfs files is not usually the right path,
but my understanding is that this piece of information can't be
retrieved in any other way and its absence restricts how
userspace application (e.g. like libqmi) can take advantage of the
qmimux implementation in qmi_wwan.

Thanks,
Daniele

Daniele Palmas (2):
  net: usb: qmi_wwan: add qmap id sysfs file for qmimux interfaces
  net: qmi_wwan: document qmap/mux_id sysfs file

 Documentation/ABI/testing/sysfs-class-net-qmi | 10 +++++++
 drivers/net/usb/qmi_wwan.c                    | 27 +++++++++++++++++++
 2 files changed, 37 insertions(+)

-- 
2.17.1

