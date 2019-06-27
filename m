Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C80A58AE6
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 21:20:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbfF0TUu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 15:20:50 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45637 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726441AbfF0TUu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jun 2019 15:20:50 -0400
Received: by mail-pf1-f196.google.com with SMTP id r1so1690947pfq.12
        for <netdev@vger.kernel.org>; Thu, 27 Jun 2019 12:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=x5Kxjv9oCqaXzB748WyOVVOtbxspMpkkLokI9sK+//I=;
        b=Kg7FbFWurbHi3bd8gzcU9rubpjAVS3u6qUQwFjMjuqAggCQeTLlD0zoF262HeYQEqc
         QZWWt2758VQnN8ekb4sn1t33mRKx5QtPyigQBgRg6IvZW5TkCPP4AjVBOlboAss7oECZ
         4VjGkT3/4EUjFJFm6puD3PDvAg4CKdH4g1ABRE4PQBFYJ3tONxMfNoVRit+4/MQD7jEd
         2bT4xfhBmOIBHeI9TTGqtJvidbT/smBbtlIQHa10E0tKD95BaDBvn32AJ217lZYICYmk
         WnMgGJHjA7b9HJllfkdXpz6ApVUHwdctqyHtV+dl83X54MWAdVuLG5R33E9Q5OJY9FWT
         A4pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=x5Kxjv9oCqaXzB748WyOVVOtbxspMpkkLokI9sK+//I=;
        b=V8HWPA8zGhzDNIsI9IraQ/7qiOqGg74XgxUHtvKeRUTy/vWP0cvEYpCX4jYvpajtGF
         x1zAG+TYquBQvu+63oCmhr8IRtmuEoG5A7///KB3XjKdMOgTSn2qGenEk59lTegW9OtG
         PfhA2xGNr/zn41wA+xhQAkCtOhGS3zWskszBLCLd7G46S5TNHJ5czIFdod/+cOM2iZn8
         57xiz5icudCPdhTXlyVE+jIhHEsFLaFx49eF79F9QfsluubiYIiGL5HaYlXOiNoveNVr
         WuhIny7+FHjWNI9UxYiwXm6FGPuvNfB6QdNwvzbYf2SWv0pyLOYorwXG5mwF4FNVuGpJ
         hJKA==
X-Gm-Message-State: APjAAAVaXUc1scZOUrkeQdct1x8UeRUdDg0sp3Z/tbgW2fJ4iIWA67Zg
        T3CHph7ADc/ZwV2yu82gLK+Ksg==
X-Google-Smtp-Source: APXvYqwKF89hiKPltD+jPesXatYFVOcxQs5keV5boaInd0FxsorU9XxmIbx21vG2WaYBy477Q9ciIQ==
X-Received: by 2002:a65:534b:: with SMTP id w11mr5425554pgr.210.1561663248818;
        Thu, 27 Jun 2019 12:20:48 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f15sm6335pje.17.2019.06.27.12.20.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 12:20:48 -0700 (PDT)
Date:   Thu, 27 Jun 2019 12:20:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        David Ahern <dsahern@gmail.com>, Jiri Pirko <jiri@resnulli.us>,
        davem@davemloft.net, jakub.kicinski@netronome.com,
        mlxsw@mellanox.com
Subject: Re: [RFC] longer netdev names proposal
Message-ID: <20190627122041.18c46daf@hermes.lan>
In-Reply-To: <20190627183948.GK27240@unicorn.suse.cz>
References: <20190627094327.GF2424@nanopsycho>
        <26b73332-9ea0-9d2c-9185-9de522c72bb9@gmail.com>
        <20190627180803.GJ27240@unicorn.suse.cz>
        <20190627112305.7e05e210@hermes.lan>
        <20190627183538.GI31189@lunn.ch>
        <20190627183948.GK27240@unicorn.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 27 Jun 2019 20:39:48 +0200
Michal Kubecek <mkubecek@suse.cz> wrote:

> > 
> > $ ip li set dev enp3s0 alias "Onboard Ethernet"
> > # ip link show "Onboard Ethernet"
> > Device "Onboard Ethernet" does not exist.
> > 
> > So it does not really appear to be an alias, it is a label. To be
> > truly useful, it needs to be more than a label, it needs to be a real
> > alias which you can use.  
> 
> That's exactly what I meant: to be really useful, one should be able to
> use the alias(es) for setting device options, for adding routes, in
> netfilter rules etc.
> 
> Michal

The kernel doesn't enforce uniqueness of alias.
Also current kernel RTM_GETLINK doesn't do filter by alias (easily fixed).

If it did, then handling it in iproute would be something like:

diff --git a/lib/ll_map.c b/lib/ll_map.c
index e0ed54bf77c9..c798ba542224 100644
--- a/lib/ll_map.c
+++ b/lib/ll_map.c
@@ -26,15 +26,18 @@
 struct ll_cache {
 	struct hlist_node idx_hash;
 	struct hlist_node name_hash;
+	struct hlist_node alias_hash;
 	unsigned	flags;
 	unsigned 	index;
 	unsigned short	type;
-	char		name[];
+	char		*alias;
+	char		name[IFNAMSIZ];
 };
 
 #define IDXMAP_SIZE	1024
 static struct hlist_head idx_head[IDXMAP_SIZE];
 static struct hlist_head name_head[IDXMAP_SIZE];
+static struct hlist_head alias_head[IDXMAP_SIZE];
 
 static struct ll_cache *ll_get_by_index(unsigned index)
 {
@@ -77,10 +80,26 @@ static struct ll_cache *ll_get_by_name(const char *name)
 	return NULL;
 }
 
+static struct ll_cache *ll_get_by_alias(const char *alias)
+{
+	struct hlist_node *n;
+	unsigned h = namehash(alias) & (IDXMAP_SIZE - 1);
+
+	hlist_for_each(n, &alias_head[h]) {
+		struct ll_cache *im
+			= container_of(n, struct ll_cache, alias_hash);
+
+		if (strcmp(im->alias, alias) == 0)
+			return im;
+	}
+
+	return NULL;
+}
+
 int ll_remember_index(struct nlmsghdr *n, void *arg)
 {
 	unsigned int h;
-	const char *ifname;
+	const char *ifname, *ifalias;
 	struct ifinfomsg *ifi = NLMSG_DATA(n);
 	struct ll_cache *im;
 	struct rtattr *tb[IFLA_MAX+1];
@@ -96,6 +115,10 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 		if (im) {
 			hlist_del(&im->name_hash);
 			hlist_del(&im->idx_hash);
+			if (im->alias) {
+				hlist_del(&im->alias_hash);
+				free(im->alias);
+			}
 			free(im);
 		}
 		return 0;
@@ -106,6 +129,8 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 	if (ifname == NULL)
 		return 0;
 
+	ifalias = tb[IFLA_IFALIAS] ? rta_getattr_str(tb[IFLA_IFALIAS]) : NULL;
+
 	if (im) {
 		/* change to existing entry */
 		if (strcmp(im->name, ifname) != 0) {
@@ -114,6 +139,14 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 			hlist_add_head(&im->name_hash, &name_head[h]);
 		}
 
+		if (im->alias) {
+			hlist_del(&im->alias_hash);
+			if (ifalias) {
+				h = namehash(ifalias) & (IDXMAP_SIZE - 1);
+				hlist_add_head(&im->alias_hash, &alias_head[h]);
+			}
+		}
+
 		im->flags = ifi->ifi_flags;
 		return 0;
 	}
@@ -132,6 +165,12 @@ int ll_remember_index(struct nlmsghdr *n, void *arg)
 	h = namehash(ifname) & (IDXMAP_SIZE - 1);
 	hlist_add_head(&im->name_hash, &name_head[h]);
 
+	if (ifalias) {
+		im->alias = strdup(ifalias);
+		h = namehash(ifalias) & (IDXMAP_SIZE - 1);
+		hlist_add_head(&im->alias_hash, &alias_head[h]);
+	}		
+	
 	return 0;
 }
 
@@ -152,7 +191,7 @@ static unsigned int ll_idx_a2n(const char *name)
 	return idx;
 }
 
-static int ll_link_get(const char *name, int index)
+static int ll_link_get(const char *name, const char *alias, int index)
 {
 	struct {
 		struct nlmsghdr		n;
@@ -176,6 +215,9 @@ static int ll_link_get(const char *name, int index)
 	if (name)
 		addattr_l(&req.n, sizeof(req), IFLA_IFNAME, name,
 			  strlen(name) + 1);
+	if (alias)
+		addattr_l(&req.n, sizeof(req), IFLA_IFALIAS, alias,
+			  strlen(alias) + 1);
 
 	if (rtnl_talk_suppress_rtnl_errmsg(&rth, &req.n, &answer) < 0)
 		goto out;
@@ -206,7 +248,7 @@ const char *ll_index_to_name(unsigned int idx)
 	if (im)
 		return im->name;
 
-	if (ll_link_get(NULL, idx) == idx) {
+	if (ll_link_get(NULL, NULL, idx) == idx) {
 		im = ll_get_by_index(idx);
 		if (im)
 			return im->name;
@@ -252,7 +294,13 @@ unsigned ll_name_to_index(const char *name)
 	if (im)
 		return im->index;
 
-	idx = ll_link_get(name, 0);
+	im = ll_get_by_alias(name);
+	if (im)
+		return im->index;
+
+	idx = ll_link_get(name, NULL, 0);
+	if (idx == 0)
+		idx = ll_link_get(NULL, name, 0);
 	if (idx == 0)
 		idx = if_nametoindex(name);
 	if (idx == 0)
@@ -270,7 +318,10 @@ void ll_drop_by_index(unsigned index)
 
 	hlist_del(&im->idx_hash);
 	hlist_del(&im->name_hash);
-
+	if (im->alias) {
+		hlist_del(&im->alias_hash);
+		free(im->alias);
+	}
 	free(im);
 }
 

