Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52895221974
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 03:30:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgGPB3S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 21:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727948AbgGPB3S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 21:29:18 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AFCC061755;
        Wed, 15 Jul 2020 18:29:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:To:Subject:From:Sender:Reply-To:Cc:Content-ID:
        Content-Description:In-Reply-To:References;
        bh=CrygVX3V43OAJ4sE1y0sg4RxWnuXxdlG8xSoTRQ5Ri0=; b=BRh4aWqm/wvU7K5bIYiAnGvViw
        jukuwuqr6gZUDLFhINHUWN1IN5XndGlSgUkl2qRLQd/lW/1jyoqZj25VfJ+w7sZA7AN24OFowzkFy
        avRRysSv2uLnwTm+kQLPEKmxtTkig3tEzRBa+tv2Qmso/CN/233E9EaH3uhZSwEejQrdiWWQHq1Fl
        tmetnRBUTguZSJuc1OWDmQhtdHZUYLTF6AqYyl1NKGSyyLrI6IpH3SC47cMoLAuY/hMRdTKvj6lL1
        y2KyRRPP5MojX+vnlxUA//zM0AAPtO+ew/215fzbjduNnFKuIrxj9OLVVUzUryfZjpykNGN+oMyTp
        /owMXAnw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvsi2-0000Pj-D1; Thu, 16 Jul 2020 01:29:14 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] bpf: bpf.h: drop duplicated words in comments
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <6b9f71ae-4f8e-0259-2c5d-187ddaefe6eb@infradead.org>
Date:   Wed, 15 Jul 2020 18:29:11 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Drop doubled words "will" and "attach".

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: netdev@vger.kernel.org
Cc: bpf@vger.kernel.org
---
 include/uapi/linux/bpf.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- linux-next-20200714.orig/include/uapi/linux/bpf.h
+++ linux-next-20200714/include/uapi/linux/bpf.h
@@ -2419,7 +2419,7 @@ union bpf_attr {
  *			Look for an IPv6 socket.
  *
  *		If the *netns* is a negative signed 32-bit integer, then the
- *		socket lookup table in the netns associated with the *ctx* will
+ *		socket lookup table in the netns associated with the *ctx*
  *		will be used. For the TC hooks, this is the netns of the device
  *		in the skb. For socket hooks, this is the netns of the socket.
  *		If *netns* is any other signed 32-bit value greater than or
@@ -2456,7 +2456,7 @@ union bpf_attr {
  *			Look for an IPv6 socket.
  *
  *		If the *netns* is a negative signed 32-bit integer, then the
- *		socket lookup table in the netns associated with the *ctx* will
+ *		socket lookup table in the netns associated with the *ctx*
  *		will be used. For the TC hooks, this is the netns of the device
  *		in the skb. For socket hooks, this is the netns of the socket.
  *		If *netns* is any other signed 32-bit value greater than or
@@ -3986,7 +3986,7 @@ struct bpf_link_info {
 
 /* User bpf_sock_addr struct to access socket fields and sockaddr struct passed
  * by user and intended to be used by socket (e.g. to bind to, depends on
- * attach attach type).
+ * attach type).
  */
 struct bpf_sock_addr {
 	__u32 user_family;	/* Allows 4-byte read, but no write. */


