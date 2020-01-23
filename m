Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3F5147496
	for <lists+netdev@lfdr.de>; Fri, 24 Jan 2020 00:21:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729765AbgAWXVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jan 2020 18:21:41 -0500
Received: from mail-pg1-f202.google.com ([209.85.215.202]:54741 "EHLO
        mail-pg1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729277AbgAWXVl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jan 2020 18:21:41 -0500
Received: by mail-pg1-f202.google.com with SMTP id i21so210841pgm.21
        for <netdev@vger.kernel.org>; Thu, 23 Jan 2020 15:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=TN+/5KknFZAUnST37tMeBssMvLKEjSgJv9HzOQGI/KM=;
        b=VNZeeBoDgXX3uIJMTX6BbhK9CXqLTzo47HYVX6hcSY5kkJuuIPYj/n0+rTy2qIQaSJ
         H5pqgQxVwKegrgqL2dXfn34ALAVGqXgA5J6lgtWp1FMztIRxBgdwfy24ook+IF4x2awa
         fJBjPEfdxZj7qSaGxrcqj9ltpx+lBtk5/+Xxb8oZpaGx6fcEsFWtBnkpuZyydqgHhpH8
         oOudRY4JsPNhAooq9Y+f7BU0LfCzvtkZdP+UrAlZY8OkothdEUHiKEt7Bd5XjQQWv/V0
         my5XOGPGuoK4juxnnaYJuiiNu1hez8Y/7V5LaV2pz9VhUL8bMZU65O718kKmSp9wDbqw
         4WPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=TN+/5KknFZAUnST37tMeBssMvLKEjSgJv9HzOQGI/KM=;
        b=fzr0U+ob06xldb3VswGqDa9TNVgtQj7fkLweSKLALV+1rb5a/La/+ShoynioIAKsT8
         DqBGrzGJsLwX32NXm0V4wcsUZWjZR/wjLqIFoV1Xym0oGogqartYwRhKKAyOUvbuX9xB
         +p1u/9TFuo4fyIxZqBDP5pnwuE72oc5Kirax7PDrZVcPNJeh7D3L4KRebtQzoEJRume/
         Nr2h7Jj61zdO4yz2Lh3JhOFqo7TX2AfPABdk7wC2lsdNuU53B4AbBr86dLIf9C4qsAf5
         AYlmMmIed0ByoFg1algdmoEm4OB3UN6o5qInTB+Yg3x/oxkCj/kznV9d571DBxIhEiG8
         Sf3g==
X-Gm-Message-State: APjAAAVVcgjhZl6FCv1ur0566rKH3WO42bXmYIs9BAGRuLUN1VQTWpA5
        XRdDvk3SSM4cubqLttPCTtVSahZFg2UKEkVcYa8WfKwwuK4vqT+RmU7ABOFFWUxDcFul1Yz/cKb
        xOaLBMwjqRNzCOaOGoJOzIxwJzVuk6jvqBOkO5ShyEHyFJma6EJd9bjnAlcuZ0Q==
X-Google-Smtp-Source: APXvYqzFd/5uR4a5NIPBxtQSRoz+1jf1xPdMqgylN5/gUZ+Hy484GmChuTv6kx954PJzQdjwVhGAr9HHcwQ=
X-Received: by 2002:a63:5b59:: with SMTP id l25mr886858pgm.382.1579821700372;
 Thu, 23 Jan 2020 15:21:40 -0800 (PST)
Date:   Thu, 23 Jan 2020 15:21:36 -0800
Message-Id: <20200123232136.184906-1-lrizzo@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.25.0.341.g760bfbb309-goog
Subject: [PATCH net-next] net-xdp: document xdp_linearize
From:   Luigi Rizzo <lrizzo@google.com>
To:     netdev@vger.kernel.org
Cc:     Jesper Dangaard Brouer <hawk@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, sameehj@amazon.com,
        Luigi Rizzo <lrizzo@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---
 Documentation/ABI/testing/sysfs-class-net | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-class-net b/Documentation/ABI/testing/sysfs-class-net
index 664a8f6a634f..5917af789c53 100644
--- a/Documentation/ABI/testing/sysfs-class-net
+++ b/Documentation/ABI/testing/sysfs-class-net
@@ -301,3 +301,11 @@ Contact:	netdev@vger.kernel.org
 Description:
 		32-bit unsigned integer counting the number of times the link has
 		been down
+
+What:		/sys/class/net/<iface>/xdp_linearize
+Date:		Jan 2020
+KernelVersion:	5.6
+Contact:	netdev@vger.kernel.org
+Description:
+		boolean controlling whether skb should be linearized in
+		netif_receive_generic_xdp. Defaults to 1 (true).
-- 
2.25.0.341.g760bfbb309-goog

