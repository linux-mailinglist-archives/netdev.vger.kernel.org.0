Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A6AA41FA51
	for <lists+netdev@lfdr.de>; Sat,  2 Oct 2021 09:45:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232550AbhJBHnf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Oct 2021 03:43:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232457AbhJBHne (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Oct 2021 03:43:34 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C7C061775
        for <netdev@vger.kernel.org>; Sat,  2 Oct 2021 00:41:48 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id dj4so44000606edb.5
        for <netdev@vger.kernel.org>; Sat, 02 Oct 2021 00:41:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=NmaACoMU7/F0Pg2X/PR7s4f2aefi4fRtWp2IPiYOLj8=;
        b=ALY8XftkszOHXwj3bMR6knIpNyZHHK/Ysk567mAxm+4HHYrIPKErPwSUVJLK14QvqZ
         FdztP/nLNsbbsJSjn9BeXRpQzalikYfMJU4q23giZ7O0zqrCWHmiOe6m8AyP7XU17CTi
         EpuB5LyB9C3MKvj0x62j6FwO4vVU583CpAizOfwZTwijvctUGmcn2UjjdC0X/G+7b55W
         vW5vLT/0OVJ94YN2JrVuC5xSkulX8PPiRwDQWk4ws0QrH0MI5fdPHbtHGL3mhy/z+qEC
         HV2rQyZFWnd7CFQPNB8WL1tBK1KgCTBjjR4CodWbJ90UyPLPYM0O4USjBof5zIy01tx0
         aacw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=NmaACoMU7/F0Pg2X/PR7s4f2aefi4fRtWp2IPiYOLj8=;
        b=HjoQKV8TegCGWrAGrZ/T9Y8E/wOaQIEnTaCulTN5JB/hK4voyBkiHFXeWJG8a8ZuA/
         pm19qv7snN/VgH47ZqiHi8rKLLBuWtg0d/XVKIpw3XPJPsoWbkq6ZPrKvNB/DZq1bU+a
         7SA5tR8WBidPvpBZ5OWGp6Wp/xKffn/qqjfLT+P2ELi/XoFbH+Y07HvXa5GAkl5yEJ3B
         t9INvnahKynqpALQpsswYvOHypHvrdGy1NQnD2iXmg1KjxClBfKhcywhJwjZD7s5VHW2
         alFB4H6CY0wAO1vXlU1Mp6baKtzRXkGKGbSK9jJfeA3nvjLp85roWatYay9kqFXhIKpB
         4ufw==
X-Gm-Message-State: AOAM533Hbc44ocTx3dyyE13+HUufbN/iiOnKS3qteOh7xT1Sh74MdR+4
        ApwZDnTyI7L0teS0VMxjWXXvqnZlKwZBp/H65XI=
X-Google-Smtp-Source: ABdhPJwAQL3vRms9cjVHRaNHAaQo+vZbTR/jeYbz3q+sgc50cSA3jxSozvE4FyBmlNkMZNfwRUiE2e0tTvqf5EuuaYs=
X-Received: by 2002:a17:906:c10e:: with SMTP id do14mr2970313ejc.84.1633160507228;
 Sat, 02 Oct 2021 00:41:47 -0700 (PDT)
MIME-Version: 1.0
From:   Michelle Jin <shjy180909@gmail.com>
Date:   Sat, 2 Oct 2021 16:41:36 +0900
Message-ID: <CAJg10rLWa8fc32KO8D3uz7YKgEj0dtQF+voKSM7P+kaADUsXkA@mail.gmail.com>
Subject: [duplicated merge report] net: ipv6: check return value of rhashtable_init
To:     davem@davemloft.net, johannes.berg@intel.com
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

commit f43bed7193a3 is
the next version of commit 111461d57374
and they are the same patch.
However, commit 111461d57374
was merged in mac80211.
commit f43bed7193a3
was merged in net-next.
So, is there anything I need to do?

Thank you.
