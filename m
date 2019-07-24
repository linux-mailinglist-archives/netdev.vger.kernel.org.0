Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 743AE73643
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 20:03:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726347AbfGXSDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 14:03:08 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37689 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725944AbfGXSDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 14:03:08 -0400
Received: by mail-qk1-f193.google.com with SMTP id d15so34408945qkl.4
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 11:03:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/KLvkv4tip+BqrrzM/6HDFgUbGfXypU4li8j41EUxc=;
        b=esEh6rrgYf14wnGGIbDla4wDwBmGMy4ALT1k7GP0pan1hFhG/NPRnMV10gyP+L2mmv
         Q3wIgWS4zOYhJJakbA9zl24LkwCjDze6hJdSPr7Iqi40A4wfTlhDXRBg3PechvjawMsX
         QWklx88u8Gd5B0KQCzqXWyEbEN58kH4DUCf2Hbb+SPemaCZGbw6T7HBmA/26QC7oa7zD
         pViwbc+l/PTSCAi/bar2E/wHaFmeYbH5kaoEGqbk3J2XXszPqX5wiWksyTWqMEgfEtjA
         b8mblbfOnI58mTMmJnOHSYezsmXmxLTSMNbKCU1hnlb/GyTylitZdoPO3RfXgEp6KR5s
         vulQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9/KLvkv4tip+BqrrzM/6HDFgUbGfXypU4li8j41EUxc=;
        b=BvTFDKPkQxLiEGKLG00FWEqpSI6VZvjZ5vw1HD9vS9VCuSQma63nHec9SgaSxDSEHh
         6jVgsRbYflPzGcozTLWd6miizuPg6Jpu/XEg3LWZJ+8Qd0g4DMs92v28dE0Ei40a5nMA
         oSTfi22XoZ443NaaOppg1QJY8HcnHwj2fruUpLUUlEbn1IDPf2LUM4LAMq3lC+PK2Yeh
         87+Jgh1U4a4Zx4i0YsuCIcsCWoEQcRle3cAH9ONB1T5j7V54ySNosp82Pvejpe0XtE79
         ExOk47Vc+xZ62NueIQ5iR7SaplV6DYpfYPFa8GqZAgu2Dm7cUDRH+XXJTtob2zZWrIO2
         9TzA==
X-Gm-Message-State: APjAAAWa/Acb4/1+vFbbY0yeI7lVrTPvrh/4l4w29lnTlLpNhGvpnUYZ
        X8eTwk/DdVoumqSmhCPYgIr0lA==
X-Google-Smtp-Source: APXvYqx229ri36+pxYdmwBP3zHhjw3694U9CSYJ+GncJcid6tc44DELfnF2bvtGKG8wy43PfHt1vzA==
X-Received: by 2002:a37:5942:: with SMTP id n63mr52443957qkb.69.1563991387585;
        Wed, 24 Jul 2019 11:03:07 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id z4sm24574212qtd.60.2019.07.24.11.03.04
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 24 Jul 2019 11:03:06 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net, alexei.starovoitov@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, aviadye@mellanox.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        simon.horman@netronome.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net-next] net/tls: add myself as a co-maintainer
Date:   Wed, 24 Jul 2019 11:02:48 -0700
Message-Id: <20190724180248.6480-1-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I've been spending quite a bit of time fixing and
preventing bit rot in the core TLS code. TLS seems
to only be growing in importance, I'd like to help
ensuring the quality of our implementation.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Simon Horman <simon.horman@netronome.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 783569e3c4b4..3ff2e6ab3cf4 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -11282,6 +11282,7 @@ M:	Aviad Yehezkel <aviadye@mellanox.com>
 M:	Dave Watson <davejwatson@fb.com>
 M:	John Fastabend <john.fastabend@gmail.com>
 M:	Daniel Borkmann <daniel@iogearbox.net>
+M:	Jakub Kicinski <jakub.kicinski@netronome.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	net/tls/*
-- 
2.21.0

