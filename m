Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08B8782620
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 22:34:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730034AbfHEUer (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 16:34:47 -0400
Received: from mail-wm1-f49.google.com ([209.85.128.49]:50513 "EHLO
        mail-wm1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727460AbfHEUer (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 16:34:47 -0400
Received: by mail-wm1-f49.google.com with SMTP id v15so75990766wml.0;
        Mon, 05 Aug 2019 13:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=HOfabLRn+ve90T3st4u5VCNCOkR3fyl1Yw5g4t6Qnb4=;
        b=TR366iaC6f7LSwP7ZWWrk6c1XmpZmL1bflpDeQk22UplwA7bX4s4AtX3SFSFgJpX8f
         UEKbVsLDy8oEjAtWAQKPHCqmjFwH08FfDbmdUVAp7FYcTvDjMeCnJcLc60wQBdGbrbpS
         O0CdPwXlBtwcZVHLT3bvOHIUG14PG8omerBmy3OYR62hwLcezKqkTHt2Oi+nIgmEIsWa
         8ZktUHihaL5iLJDL8Dq94+c3rPY2rR3RgcTff3ZA0K8/RIXhOo0niB6FG/3B38nxTUoM
         OW7dum6Wql8M990P+E/+/9r7Y6IRY36OQU6jIaxzWA/th4aZ8XMj0MV2u8sNPQXgR7PB
         11OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=HOfabLRn+ve90T3st4u5VCNCOkR3fyl1Yw5g4t6Qnb4=;
        b=dtWgts7eMDKKETDDKK6S9tytqGg7Ax1hUozq/C1bpJx1xPvGnKoFY4x5Avu2tJ2sZY
         ekj4pdHoFp5ibWsxwNQ9YuDK+u7XdNVVQ11pY8gtBix8WYcth4lTPhjJkrlDz6+jgUav
         awRiihmk3olP8OnxEN9An2qMJ04F4VjC9E/ok5HWL1zO1UH83o0MiN7Oqeea4ZEkugUE
         Jy/3D0FQ+WH7YJDKN1DVGX6bAV/pHCBsDU+peg5AuV6nilvFf/+02x0WoNc9UlqpYp4a
         aV1+SDKx90TKDy24e2kIfnoGmoGBXjMq359EDKtNsUDpPf8137onOLSFxehXdF//oVWn
         FVRQ==
X-Gm-Message-State: APjAAAX4p6hGRxDj69V96sx8Q7osAhuORye9uHaZ87vdMn+VG9eWG41c
        lTgs9u++Sg33OHFoea9VGA==
X-Google-Smtp-Source: APXvYqwF4kizdUhpMofD82NLZi3vXmCighJmR1zVJYcMbYdgmJNcSMI+GPQG+VzQ++CdOz4E84HFXw==
X-Received: by 2002:a1c:9813:: with SMTP id a19mr136969wme.11.1565037284361;
        Mon, 05 Aug 2019 13:34:44 -0700 (PDT)
Received: from avx2 ([46.53.248.54])
        by smtp.gmail.com with ESMTPSA id s10sm110725866wmf.8.2019.08.05.13.34.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Aug 2019 13:34:43 -0700 (PDT)
Date:   Mon, 5 Aug 2019 23:34:41 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, lvs-devel@vger.kernel.org
Subject: [PATCH net-next] net: delete "register" keyword
Message-ID: <20190805203441.GA24674@avx2>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Delete long obsoleted "register" keyword.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---

 drivers/net/ethernet/apple/bmac.c |    4 ++--
 drivers/net/slip/slhc.c           |   30 +++++++++++++++---------------
 net/netfilter/ipvs/ip_vs_ctl.c    |    4 ++--
 net/netfilter/ipvs/ip_vs_lblcr.c  |    4 ++--
 4 files changed, 21 insertions(+), 21 deletions(-)

--- a/drivers/net/ethernet/apple/bmac.c
+++ b/drivers/net/ethernet/apple/bmac.c
@@ -815,8 +815,8 @@ static int reverse6[64] = {
 static unsigned int
 crc416(unsigned int curval, unsigned short nxtval)
 {
-	register unsigned int counter, cur = curval, next = nxtval;
-	register int high_crc_set, low_data_set;
+	unsigned int counter, cur = curval, next = nxtval;
+	int high_crc_set, low_data_set;
 
 	/* Swap bytes */
 	next = ((next & 0x00FF) << 8) | (next >> 8);
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -91,8 +91,8 @@ static unsigned short pull16(unsigned char **cpp);
 struct slcompress *
 slhc_init(int rslots, int tslots)
 {
-	register short i;
-	register struct cstate *ts;
+	short i;
+	struct cstate *ts;
 	struct slcompress *comp;
 
 	if (rslots < 0 || rslots > 255 || tslots < 0 || tslots > 255)
@@ -206,7 +206,7 @@ pull16(unsigned char **cpp)
 static long
 decode(unsigned char **cpp)
 {
-	register int x;
+	int x;
 
 	x = *(*cpp)++;
 	if(x == 0){
@@ -227,14 +227,14 @@ int
 slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
 	unsigned char *ocp, unsigned char **cpp, int compress_cid)
 {
-	register struct cstate *ocs = &(comp->tstate[comp->xmit_oldest]);
-	register struct cstate *lcs = ocs;
-	register struct cstate *cs = lcs->next;
-	register unsigned long deltaS, deltaA;
-	register short changes = 0;
+	struct cstate *ocs = &(comp->tstate[comp->xmit_oldest]);
+	struct cstate *lcs = ocs;
+	struct cstate *cs = lcs->next;
+	unsigned long deltaS, deltaA;
+	short changes = 0;
 	int hlen;
 	unsigned char new_seq[16];
-	register unsigned char *cp = new_seq;
+	unsigned char *cp = new_seq;
 	struct iphdr *ip;
 	struct tcphdr *th, *oth;
 	__sum16 csum;
@@ -486,11 +486,11 @@ slhc_compress(struct slcompress *comp, unsigned char *icp, int isize,
 int
 slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 {
-	register int changes;
+	int changes;
 	long x;
-	register struct tcphdr *thp;
-	register struct iphdr *ip;
-	register struct cstate *cs;
+	struct tcphdr *thp;
+	struct iphdr *ip;
+	struct cstate *cs;
 	int len, hdrlen;
 	unsigned char *cp = icp;
 
@@ -543,7 +543,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 	switch(changes & SPECIALS_MASK){
 	case SPECIAL_I:		/* Echoed terminal traffic */
 		{
-		register short i;
+		short i;
 		i = ntohs(ip->tot_len) - hdrlen;
 		thp->ack_seq = htonl( ntohl(thp->ack_seq) + i);
 		thp->seq = htonl( ntohl(thp->seq) + i);
@@ -637,7 +637,7 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 int
 slhc_remember(struct slcompress *comp, unsigned char *icp, int isize)
 {
-	register struct cstate *cs;
+	struct cstate *cs;
 	unsigned ihl;
 
 	unsigned char index;
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -262,7 +262,7 @@ static inline unsigned int
 ip_vs_svc_hashkey(struct netns_ipvs *ipvs, int af, unsigned int proto,
 		  const union nf_inet_addr *addr, __be16 port)
 {
-	register unsigned int porth = ntohs(port);
+	unsigned int porth = ntohs(port);
 	__be32 addr_fold = addr->ip;
 	__u32 ahash;
 
@@ -493,7 +493,7 @@ static inline unsigned int ip_vs_rs_hashkey(int af,
 					    const union nf_inet_addr *addr,
 					    __be16 port)
 {
-	register unsigned int porth = ntohs(port);
+	unsigned int porth = ntohs(port);
 	__be32 addr_fold = addr->ip;
 
 #ifdef CONFIG_IP_VS_IPV6
--- a/net/netfilter/ipvs/ip_vs_lblcr.c
+++ b/net/netfilter/ipvs/ip_vs_lblcr.c
@@ -160,7 +160,7 @@ static void ip_vs_dest_set_eraseall(struct ip_vs_dest_set *set)
 /* get weighted least-connection node in the destination set */
 static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 {
-	register struct ip_vs_dest_set_elem *e;
+	struct ip_vs_dest_set_elem *e;
 	struct ip_vs_dest *dest, *least;
 	int loh, doh;
 
@@ -209,7 +209,7 @@ static inline struct ip_vs_dest *ip_vs_dest_set_min(struct ip_vs_dest_set *set)
 /* get weighted most-connection node in the destination set */
 static inline struct ip_vs_dest *ip_vs_dest_set_max(struct ip_vs_dest_set *set)
 {
-	register struct ip_vs_dest_set_elem *e;
+	struct ip_vs_dest_set_elem *e;
 	struct ip_vs_dest *dest, *most;
 	int moh, doh;
 
