Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0808D337035
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 11:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbhCKKkB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 05:40:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbhCKKjn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 05:39:43 -0500
Received: from mail-pg1-x52a.google.com (mail-pg1-x52a.google.com [IPv6:2607:f8b0:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85C04C061574;
        Thu, 11 Mar 2021 02:39:43 -0800 (PST)
Received: by mail-pg1-x52a.google.com with SMTP id o10so13423488pgg.4;
        Thu, 11 Mar 2021 02:39:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=ksz1ClkKIObXGUsnxvYXkjPZ5AxFir+5GzKwQdaVeZ4=;
        b=glGAYCb2J+aohcnZfHsxGcq9gmaxxzKkFCmlrMc6B1lphAB8nA6a2Nsz9kFn6IZZKH
         jsh/Uh1Mp+v0dqYDvDSoJqmVDy4wNOotAuhIDtUzqYHQenVuaDfJveQCI9K3h+IOOsjz
         rofSB1BhuEJ551ut36Tp0UfH/p+w8zdhRZDMVouaO9oq36v0p91r6C9kG49EPYj52lnd
         J0kGks9mqU7PqqddC0SQpdfVc9FDLTESZhOFnO1T9GYj3vT0eIDPuCz+eFNkZIRbUiN/
         tvG2lIw+NYt3ZxEaQqI2sxw2I8EWedMy98aw4HqwxP8l0CMylqLMoQYb7XJUSscZSQdL
         kszw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=ksz1ClkKIObXGUsnxvYXkjPZ5AxFir+5GzKwQdaVeZ4=;
        b=gaky0EnwbhUzxp30rVZEJsBVri2ATZiONkdm+01ipcsdWG5etlgKswYkqb0yyVTJti
         +55An4+R+Wj6ilQzpGMXm62X1aADyPcA854ex6CbCU82HSX61EzJirTkj1JPLSsTwpY7
         cs7bIrXyTfjSBEo00ZGqb8hA9x81cfmf3k3MEqZ3LjVx9jAJWpH/Nl7HlKJWVeIJncRz
         fIhUZfxG2hDZc7I6qCdgUdLPekpqMa2gHbfTA1JxIy/w1VtKIUL2BUXkH3eNXWvL9uli
         BkEBK425AXAHpn9h5KPT8ylJheeVXd0z9gKsIDsb0Z6QdKfz+xDPlnv8VjAXAPIIkkpc
         SgyA==
X-Gm-Message-State: AOAM532SfZKrdFGJnc707GwHdZiU3yq/7+9RYkn2SSy3YtprpGv1kgC2
        iQJdJFO6x9CaWXEG8IHfYNA=
X-Google-Smtp-Source: ABdhPJySrGWHgC0rmPQWoAcau37pT3ZtM+/0dd4hayOxBC9cK9LxRGaHAfwGzdxctWOn89FetRYNMQ==
X-Received: by 2002:a62:7bc4:0:b029:1f1:58ea:4010 with SMTP id w187-20020a627bc40000b02901f158ea4010mr7224368pfc.70.1615459183097;
        Thu, 11 Mar 2021 02:39:43 -0800 (PST)
Received: from localhost ([122.179.55.249])
        by smtp.gmail.com with ESMTPSA id z3sm2047725pff.40.2021.03.11.02.39.42
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 11 Mar 2021 02:39:42 -0800 (PST)
Date:   Thu, 11 Mar 2021 16:09:40 +0530
From:   Shubhankar Kuranagatti <shubhankarvk@gmail.com>
To:     davem@davemloft.net
Cc:     kuba@kernel.org, edumazet@google.com, willemb@google.com,
        mchehab+huawei@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] net: core: datagram.c: Fix usage of space before tab
Message-ID: <20210311103940.2szjikrdghhosswz@kewl-virtual-machine>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: NeoMutt/20171215
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Removed an extra space before the tab key.

Signed-off-by: Shubhankar Kuranagatti <shubhankarvk@gmail.com>
---
 net/core/datagram.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/datagram.c b/net/core/datagram.c
index 7b2204f102b7..be0caaec9add 100644
--- a/net/core/datagram.c
+++ b/net/core/datagram.c
@@ -790,7 +790,7 @@ int skb_copy_and_csum_datagram_msg(struct sk_buff *skb,
 EXPORT_SYMBOL(skb_copy_and_csum_datagram_msg);
 
 /**
- * 	datagram_poll - generic datagram poll
+ *	datagram_poll - generic datagram poll
  *	@file: file struct
  *	@sock: socket
  *	@wait: poll table
-- 
2.17.1

