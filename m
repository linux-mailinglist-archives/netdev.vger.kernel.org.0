Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ECC851A6121
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 01:51:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbgDLXvI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 19:51:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:42998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726185AbgDLXvI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 19:51:08 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735B6C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:06 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id c195so9063894wme.1
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 16:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+1HDAUOok+FsVjhhzjXBEJIQTDUbhit9FyQaUHNpAPE=;
        b=T61P/V2Fg+E3iDGZja/brkf0yjpwLB3aZ5+vBqhYHfqAX8wGf+xMSuVtrhYr6Nr31B
         /NRfI7LhlMKqxgY9XJV1j53iEGdmYTO4CiUjO1wpEEhLlxQlBQM/NBmWmsmiS/2d4szT
         0M81rChUwx3x6bjf2G2T6YtVlhjivh3UbOsI1J53zLrdFz6uVluAht1adoonNM0KZPuj
         UsQXGFk49/yMg4w3LBJXlnWHYRJ7bguaPAyAcePsI9qI/+BpNtNlWwFzWCAt4Bcce60v
         vQypmYmCx9Qq7lrBUkRNAwpzhoaW8HB8a8ooUQj4C00AmUqHX+B3LmqqjpPPj/VMh3Sk
         Th2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+1HDAUOok+FsVjhhzjXBEJIQTDUbhit9FyQaUHNpAPE=;
        b=QO207zYcTJReTN6TslbVAlbED49PW9ssH/du1QKwvZg/6cTtjgfPvv1IqIoVpohTM8
         ane5mHiPymvUsIAkz8X/EOnOJByQJyVNuB9ub7nZLx9Qw+F4Qoeye78ejx2ZliB58EO9
         J1sa27Et6jxNGWrBu4yX0NiaBXKsHGuYeApgXdPKXHHl/XVa69Ei/3kRvmY28oh6vdTb
         YxejEJq2ROTlUQTEhHjLiV36j+xD1oJmi9yu8/HbUPZkaK3arpAtxzNQzNJM9PNKNHe/
         d+0sEzK3NQXS6/QDg+DH1SU+hUksHZxirx07o2Ocw80v/w/YMqAU41VvZPFui7+67E2U
         rITg==
X-Gm-Message-State: AGi0PuZOJQZBnTiS4p6GQNqH0/X1MeiCfnTveIUfgl06pgTPXQA2pp8E
        zuNnh6hOKmzPasiNFGSaWXZE75H2
X-Google-Smtp-Source: APiQypLEvu4/y4nnjX4t1zA73Qr/q989oG53uFexii6fR2oMhMQh6Cq9ySbv+sULignHJRvm9y3UgQ==
X-Received: by 2002:a1c:ded4:: with SMTP id v203mr16150802wmg.106.1586735464512;
        Sun, 12 Apr 2020 16:51:04 -0700 (PDT)
Received: from localhost ([2a01:e35:2f01:a61:fc49:14b:88c:2a9c])
        by smtp.gmail.com with ESMTPSA id b191sm12870839wmd.39.2020.04.12.16.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Apr 2020 16:51:03 -0700 (PDT)
From:   roucaries.bastien@gmail.com
X-Google-Original-From: rouca@debian.org
To:     netdev@vger.kernel.org
Cc:     sergei.shtylyov@cogentembedded.com,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [V2][PATH 0/6] iproute improve documentation of bridge
Date:   Mon, 13 Apr 2020 01:50:32 +0200
Message-Id: <20200412235038.377692-1-rouca@debian.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200405134859.57232-1-rouca@debian.org>
References: <20200405134859.57232-1-rouca@debian.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please found a serie improving documentation of bridge device.

Please review and apply

I could not understand some options in this page:
- vlan_tunnel on  ? 


[PATCH 1/6] Better documentation of mcast_to_unicast option
[PATCH 2/6] Improve hairpin mode description
[PATCH 3/6] Document BPDU filter option
[PATCH 4/6] Better documentation of BDPU guard
[PATCH 5/6] Document root_block option
[PATCH 6/6] State of bridge STP port are now case insensitive

