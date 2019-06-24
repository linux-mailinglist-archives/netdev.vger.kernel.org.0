Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D691F500F6
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 07:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfFXFZ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 01:25:26 -0400
Received: from mail-pf1-f180.google.com ([209.85.210.180]:33340 "EHLO
        mail-pf1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726304AbfFXFZ0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 01:25:26 -0400
Received: by mail-pf1-f180.google.com with SMTP id x15so6837717pfq.0;
        Sun, 23 Jun 2019 22:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V9rJzZcXuoLDtrkFWHRyX992s5fq2c3C47qbTibbjGA=;
        b=NtT27z9mEL3sPywpIcjvYkcqf8gzwetcS51Vcbi96TFxCO0UFvLYs13K4iBJOpjnbO
         iwmPl5GZFxyWjkBYeaaDN51L5o1dz0qftaZx2MioHfap6X1STSxvfQTI4xUD8E2mMjOn
         Ror3Od8S5vm1D83gV4yj9rWjpfDXygKc5dQMp8MJn2DEEoJMygwAmtKwvkJoqcc9nvEt
         opSyDNMOsQBpN5NE6sgEHs23wdkYnSBogOB6+jCYkZJHi77Vdg0KpWARSd3S9ySOMz6J
         stNpYv31sawg/1ll66XGLDsmjl3Sn5fwbV4Er71I/CBoh3lgbrONGa9XVbH7NPQ1xYjL
         G0oA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V9rJzZcXuoLDtrkFWHRyX992s5fq2c3C47qbTibbjGA=;
        b=tD6TEBKJmMPw5abLZO1ROUImk6OU6e2ZlJX2tdh8y9m04O7KuRgsuXvpUiqiD5UWDl
         L/pv78LBIXRTu1pnNIX6MzUMOSzQAWh9QDzNd+pVoTFcGd/N9UIxDpt9dC0a43crrQKZ
         6g1uHrU5WU88CKq2DNxaEtJ0qznMYkb606rH0cmwwHR40s+/VBV+osDeOYrxXtPaXXa6
         JElruSbKsK4JAD5MYJjJyXpLz1RklhonxSi1ZsciOM29gvlM/1f0xus2JxdwlNtZBZbm
         PuCc525/yfg5+6/hYb00x2/VTM/V8zhjybU5uf5aB652yIRHaoWypzipgP0gNNecROIM
         QGJQ==
X-Gm-Message-State: APjAAAWDrnwRK7CMaXhex/WaaB5OjCvoC4rQiazmUbB1O6UrB7RrOHy4
        2aoLX10kvolBboCbfEZcMUU=
X-Google-Smtp-Source: APXvYqzl3tWhsX9AhmihDCClNnGFkHMUpa0GR83mr4cNgtGbHnwb3Lp47MsL81G/Qfoy6DM/N/XsjQ==
X-Received: by 2002:a63:735d:: with SMTP id d29mr18372263pgn.276.1561353925515;
        Sun, 23 Jun 2019 22:25:25 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.54.44])
        by smtp.gmail.com with ESMTPSA id y193sm9333002pgd.41.2019.06.23.22.25.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 23 Jun 2019 22:25:24 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.lemon@gmail.com
Subject: [PATCH bpf-next] MAINTAINERS: add reviewer to maintainers entry
Date:   Mon, 24 Jun 2019 07:24:55 +0200
Message-Id: <20190624052455.10659-1-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Jonathan Lemon has volunteered as an official AF_XDP reviewer. Thank
you, Jonathan!

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0cfe98a6761a..dd875578d53c 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17284,6 +17284,7 @@ N:	xdp
 XDP SOCKETS (AF_XDP)
 M:	Björn Töpel <bjorn.topel@intel.com>
 M:	Magnus Karlsson <magnus.karlsson@intel.com>
+R:	Jonathan Lemon <jonathan.lemon@gmail.com>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Maintained
-- 
2.20.1

