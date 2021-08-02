Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB5543DCE99
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 04:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231560AbhHBBuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 21:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbhHBBuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 21:50:50 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31B52C06175F;
        Sun,  1 Aug 2021 18:50:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=gnxwpShwhCvw1mKwTiP+8dRhlpSbg4hgjJco6fFVJhY=; b=KPgQJML5UfDpfUG+szqCNX/Q8p
        vVf8/AOjOltgV9+24b8LucLsYYmCcYKPizUXutkKF7c/cNC367Nsv0zbEKWbkKXuKcJCiuu87mQ6e
        0NH52oY7MsZoyJxia0dM7C4SYOF5weeKS/O2bSJj7PhbdCbjw1E8ys49+rXr+P8GSe/6BMHBGk77L
        fgKpeDeAWHU+Won6jBYnHHTqET+4ss5d+2mANy83fzvZh/lrebFpk+VA3eZRPI9llf+L5c5xlr4Ii
        CyU1hsgjz7PFLQAuGmgoLCq35ZZsrrc0CoYYiixyz4J0O743ERTn30j6Pzs14Han+NEkxeD5GgGHb
        dy/fDhyA==;
Received: from [2601:1c0:6280:3f0::aa0b] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mAN6E-00EfBW-RC; Mon, 02 Aug 2021 01:50:38 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     netdev@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Grant Seltzer <grantseltzer@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>, bpf@vger.kernel.org
Subject: [PATCH] bpf: libbpf: eliminate Docum. warnings in libbpf_naming_convention
Date:   Sun,  1 Aug 2021 18:50:37 -0700
Message-Id: <20210802015037.787-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "code-block: none" instead of "c" for non-C-language code blocks.
Removes these warnings:

lnx-514-rc4/Documentation/bpf/libbpf/libbpf_naming_convention.rst:111: WARNING: Could not lex literal_block as "c". Highlighting skipped.
lnx-514-rc4/Documentation/bpf/libbpf/libbpf_naming_convention.rst:124: WARNING: Could not lex literal_block as "c". Highlighting skipped.

Fixes: f42cfb469f9b ("bpf: Add documentation for libbpf including API autogen")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Grant Seltzer <grantseltzer@gmail.com>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: bpf@vger.kernel.org
---
 Documentation/bpf/libbpf/libbpf_naming_convention.rst |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- lnx-514-rc4.orig/Documentation/bpf/libbpf/libbpf_naming_convention.rst
+++ lnx-514-rc4/Documentation/bpf/libbpf/libbpf_naming_convention.rst
@@ -108,7 +108,7 @@ This bump in ABI version is at most once
 
 For example, if current state of ``libbpf.map`` is:
 
-.. code-block:: c
+.. code-block:: none
 
         LIBBPF_0.0.1 {
         	global:
@@ -121,7 +121,7 @@ For example, if current state of ``libbp
 , and a new symbol ``bpf_func_c`` is being introduced, then
 ``libbpf.map`` should be changed like this:
 
-.. code-block:: c
+.. code-block:: none
 
         LIBBPF_0.0.1 {
         	global:
