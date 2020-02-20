Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C164B165EB6
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 14:27:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgBTN1I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 08:27:08 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:28177 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727996AbgBTN1H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 08:27:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582205226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6x+9QZcXKnD7gFsEX+f2d3prdgMkMA/ZjQbl/yyMNo=;
        b=d1FIXMmODpl8UmV0YiFThXdDKyKl2RXNSsgVb1LzD31Yl8Lb5XZGcrJoe0xQUVwpxVKIpO
        ElubciqDFdUQcZexgMo0Zt70teB8QU0pOdd8s4rIiaw1DfOEjHKvhhz3VNgqBAYRvybC2u
        GDdJjClYoUF+9j510Z5harvIZogjkB8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-232-spnbQsLzNmi-XzXvRtHSxQ-1; Thu, 20 Feb 2020 08:27:05 -0500
X-MC-Unique: spnbQsLzNmi-XzXvRtHSxQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8E53E108442E;
        Thu, 20 Feb 2020 13:27:03 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B22AF19486;
        Thu, 20 Feb 2020 13:26:59 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v5 1/3] libbpf: Bump libpf current version to v0.0.8
Date:   Thu, 20 Feb 2020 13:26:24 +0000
Message-Id: <158220518424.127661.8278643006567775528.stgit@xdp-tutorial>
In-Reply-To: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
References: <158220517358.127661.1514720920408191215.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

New development cycles starts, bump to v0.0.8.

Acked-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
---
 tools/lib/bpf/libbpf.map |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index b035122142bb..45be19c9d752 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -235,3 +235,6 @@ LIBBPF_0.0.7 {
 		btf__align_of;
 		libbpf_find_kernel_btf;
 } LIBBPF_0.0.6;
+
+LIBBPF_0.0.8 {
+} LIBBPF_0.0.7;

