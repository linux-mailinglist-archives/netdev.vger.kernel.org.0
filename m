Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B807216124A
	for <lists+netdev@lfdr.de>; Mon, 17 Feb 2020 13:44:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728611AbgBQMoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 07:44:04 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:54497 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728572AbgBQMoD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 07:44:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581943443;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n6x+9QZcXKnD7gFsEX+f2d3prdgMkMA/ZjQbl/yyMNo=;
        b=HvLQcHXGE8SgHJohc4SVboWRkBfj2W3TLnfu242zcqeQTJ1CN9farT+A95+jZmMDOu11w9
        2uXcQ9v7FgjFqrOpJSbBfd87uVyUdhK1OjlAAKp0O59N8lPKWHT7pp/mnYMweQGANmjqRG
        r4jIXPS90fFsANLJ4NrfiahFK1etVKE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-159-lstl68k4OryOBmipzwic0w-1; Mon, 17 Feb 2020 07:43:57 -0500
X-MC-Unique: lstl68k4OryOBmipzwic0w-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 15F59185734C;
        Mon, 17 Feb 2020 12:43:56 +0000 (UTC)
Received: from localhost.localdomain (wsfd-netdev76.ntdv.lab.eng.bos.redhat.com [10.19.188.157])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C2A060BF1;
        Mon, 17 Feb 2020 12:43:55 +0000 (UTC)
From:   Eelco Chaudron <echaudro@redhat.com>
To:     bpf@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, kafai@fb.com, songliubraving@fb.com,
        yhs@fb.com, andriin@fb.com, toke@redhat.com
Subject: [PATCH bpf-next v4 1/3] libbpf: Bump libpf current version to v0.0.8
Date:   Mon, 17 Feb 2020 12:43:26 +0000
Message-Id: <158194340589.104074.11108114040261096725.stgit@xdp-tutorial>
In-Reply-To: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
References: <158194337246.104074.6407151818088717541.stgit@xdp-tutorial>
User-Agent: StGit/0.19
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
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

