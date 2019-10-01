Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2DAC328D
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 13:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732185AbfJALd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 07:33:29 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:44970 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732086AbfJALd1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 07:33:27 -0400
Received: by mail-pg1-f196.google.com with SMTP id i14so9403410pgt.11;
        Tue, 01 Oct 2019 04:33:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=09lI8sA7GBmAEMY2ZHF2GfLfirrTO8tbiRtZGHSh2eo=;
        b=HRaTJrbn7HI6PaiCQm9rKuYy1mccgKsXAOfaPFlYC1bvJUIysqgQ1PO51Yw7JlMNCU
         j4Ba/kpmHtiaHL/K1eLBDrIjETgKRAZgfXIaUtshwZKKPDTdw/rhFx4D/HzNpX4+2ab5
         rI2TGfxxsOXPUwYB47r0K82qmnY2DVgoh0z4HlJghPktYRuWObIbqdLWalZH5zn0SmPI
         uj4Nre6CcOL+LoSaUkP2v9EK6sk6YBsbr2ujPHz7TNNP9us3o8XQMrYhXMTH3kfjIzJn
         BfduXWpI+DXhu36AXo7IX67AGF1fd8OcOT0s5OvXwRWNMkyTnsYsgRzPK1TbLmKvtvXa
         OZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=09lI8sA7GBmAEMY2ZHF2GfLfirrTO8tbiRtZGHSh2eo=;
        b=MPaHDYhV28RJtgomv5ej6QKZ8JHtzqWdWErYwI0UL49rSnMXPTtQdl4KeOZPLeYD0d
         WG/6sTH9MIzolBIFFq0m0Asn18tzBn078AaszG5JJ2s7dTYJ2V85dEtURbgitTAmCkuz
         T9TnfX1OvH8RI9E/Zc2VFdBHrjtb+5ADX5JzPPDB8ltWs6ScmrI75cU/JgD0e6Dg1CLn
         aMtof9woU02oQe4+frCYDrJENfacZOUcdUDe4UAJGylGMezCRWy6lrpQL4Nj4Hi8fKEM
         YcldIq/gm+DTz62Qh4MTJmlFIt12mqGxovam85dSoCA7uTnmecaqaw/LE2/0cunzjeXK
         Azxg==
X-Gm-Message-State: APjAAAWu1Cxpc7ZIEQPMm8OMrp7RsOokrwKqas5TOP4qKwsybVNAbn4v
        lwWt/8mGzdOJ2p4u4f7pp+vLd+H/+PoHpg==
X-Google-Smtp-Source: APXvYqxI2XEKH6x0Vt6kBCMsXWh4Ts8VEMTFQ+fqehWx1Mwoq+Wby4LwhnS6ZWII8JzeEf4TjMwYcA==
X-Received: by 2002:a17:90a:d98a:: with SMTP id d10mr4929715pjv.65.1569929606610;
        Tue, 01 Oct 2019 04:33:26 -0700 (PDT)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id a29sm16238634pfr.152.2019.10.01.04.33.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2019 04:33:26 -0700 (PDT)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     linux-kernel@vger.kernel.org, acme@kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, adrian.hunter@intel.com, jolsa@kernel.org,
        namhyung@kernel.org
Subject: [PATCH 2/2] samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
Date:   Tue,  1 Oct 2019 13:33:07 +0200
Message-Id: <20191001113307.27796-3-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001113307.27796-1-bjorn.topel@gmail.com>
References: <20191001113307.27796-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

To remove that test_attr__{enabled/open} are used by perf-sys.h, we
set HAVE_ATTR_TEST to zero.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1d9be26b4edd..42b571cde177 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,6 +176,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
+KBUILD_HOSTCFLAGS += -DHAVE_ATTR_TEST=0
 
 HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
 
-- 
2.20.1

