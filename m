Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE79174195
	for <lists+netdev@lfdr.de>; Fri, 28 Feb 2020 22:43:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726673AbgB1Vm5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Feb 2020 16:42:57 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:41798 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726167AbgB1Vm4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Feb 2020 16:42:56 -0500
Received: by mail-pf1-f195.google.com with SMTP id j9so2364103pfa.8
        for <netdev@vger.kernel.org>; Fri, 28 Feb 2020 13:42:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MWvgjLtjiHILSQWumsoRceFprr87C6sixHs+u36BO+I=;
        b=0vM4EBZnEqWly4iML2RY6/e0LXvLVMHcV7wbCJQKRpkL8ZKQPaC5IoJ4wxGLeIz5lU
         d9N+tU2Iqtc2JNtU5fa1/n6Ew6tsWiOKjDX3sZ41jn9JA8tfxV6Hks04f1HFObZvhc+l
         o4Li7qk04+rVkZ0BK1EIF5/REQTvbR3y4hT34+IfYouoTGhO1i+Ui1z8Cv0k92RwcXZ2
         UEf+uE8DWqfiTpIZn8eEIwzJjXXAQF/LqLObiJ8CQzDiKxWOq7s9UaDC4zQCvzyQ28Oe
         h1OIZw5Hg7zVQaJdOK1hINJEwHkrPsPlk4QaavKyIxSiFDFelKB/8yfQZ2tEN9Y70N5a
         SlIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MWvgjLtjiHILSQWumsoRceFprr87C6sixHs+u36BO+I=;
        b=naieGe9qbU+BbsSOu1xRVI0csl8jeYolOPWsH6cP9RH5RAJaKSXr2/1Lqu9TX5qjHz
         dpEHinf+4zopHI2vzJ2iMV7y90nWRhuJPoDkBbWTTrA7N8grsviOsl3yE4TcLGKP6KRn
         ZMztv7z/uH2696EF/S+BhhZm5zu51pNu0dnLDgs0OXKzMDhCOneYdlyjHivZK/ehZu7f
         JnEUpQUkbw6GkRtnDddui/cfP54ZVstdW2XdHWaEgCnTcd9Xrvv8f+uadB54LQ2jcNsS
         J9mj1MHs+Khpq1GMYGJBiYPzzX740YLj77t20yPqYpaY7CEQshe2e7HO+7zdVxocV0j/
         PgpQ==
X-Gm-Message-State: APjAAAWJVygdBblDOXuRwES9DF10DUc56jH6F1ZjfPrIiPC4cunS0OyJ
        1XPuS6fPD691P9chRUig99CMwpO42aM=
X-Google-Smtp-Source: APXvYqxEViPAHO2xKenL2lTgzT8coPhvdF0xzgVJXWHbN11t2fLA2xvIZRsru9b+EWMUYhDaM9pFdQ==
X-Received: by 2002:aa7:991d:: with SMTP id z29mr6375395pff.35.1582926172765;
        Fri, 28 Feb 2020 13:42:52 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id u41sm11856780pgn.8.2020.02.28.13.42.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2020 13:42:51 -0800 (PST)
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH iproute2 1/2] ss: remove asssignment in conditional context
Date:   Fri, 28 Feb 2020 13:42:42 -0800
Message-Id: <20200228214243.27344-1-stephen@networkplumber.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel style is to not use assignment in conditional context.
Also resolve some other checkpatch discovered formatting issues.

Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
---
 misc/ss.c | 223 +++++++++++++++++++++++++++++++-----------------------
 1 file changed, 128 insertions(+), 95 deletions(-)

diff --git a/misc/ss.c b/misc/ss.c
index 3ef151fbf1f1..b478ab47da4e 100644
--- a/misc/ss.c
+++ b/misc/ss.c
@@ -618,7 +618,8 @@ static void user_ent_hash_build(void)
 
 		snprintf(name + nameoff, sizeof(name) - nameoff, "%d/fd/", pid);
 		pos = strlen(name);
-		if ((dir1 = opendir(name)) == NULL) {
+		dir1 = opendir(name);
+		if (!dir1) {
 			free(pid_context);
 			continue;
 		}
@@ -660,7 +661,8 @@ static void user_ent_hash_build(void)
 
 				snprintf(tmp, sizeof(tmp), "%s/%d/stat",
 					root, pid);
-				if ((fp = fopen(tmp, "r")) != NULL) {
+				fp = fopen(tmp, "r");
+				if (fp) {
 					if (fscanf(fp, "%*d (%[^)])", p) < 1)
 						; /* ignore */
 					fclose(fp);
@@ -869,7 +871,8 @@ struct tcpstat {
 
 /* SCTP assocs share the same inode number with their parent endpoint. So if we
  * have seen the inode number before, it must be an assoc instead of the next
- * endpoint. */
+ * endpoint.
+ */
 static bool is_sctp_assoc(struct sockstat *s, const char *sock_name)
 {
 	if (strcmp(sock_name, "sctp"))
@@ -1423,7 +1426,7 @@ static void sock_addr_print(const char *addr, char *delim, const char *port,
 		const char *ifname)
 {
 	if (ifname)
-		out("%s" "%%" "%s%s", addr, ifname, delim);
+		out("%s%%%s%s", addr, ifname, delim);
 	else
 		out("%s%s", addr, delim);
 
@@ -1488,7 +1491,8 @@ static void init_service_resolver(void)
 			   &progn, proto, &port, prog+4) != 4)
 			continue;
 
-		if (!(c = malloc(sizeof(*c))))
+		c = malloc(sizeof(*c));
+		if (!c)
 			continue;
 
 		c->port = port;
@@ -1654,7 +1658,8 @@ static int inet2_addr_match(const inet_prefix *a, const inet_prefix *p,
 
 	/* Cursed "v4 mapped" addresses: v4 mapped socket matches
 	 * pure IPv4 rule, but v4-mapped rule selects only v4-mapped
-	 * sockets. Fair? */
+	 * sockets. Fair?
+	 */
 	if (p->family == AF_INET && a->family == AF_INET6) {
 		if (a->data[0] == 0 && a->data[1] == 0 &&
 		    a->data[2] == htonl(0xffff)) {
@@ -2113,7 +2118,8 @@ void *parse_hostcond(char *addr, bool is_port)
 			*port = 0;
 			if (port[1] && strcmp(port+1, "*")) {
 				if (get_integer(&a.port, port+1, 0)) {
-					if ((a.port = xll_name_to_index(port+1)) <= 0)
+					a.port = xll_name_to_index(port+1);
+					if (a.port <= 0)
 						return NULL;
 				}
 			}
@@ -2200,7 +2206,8 @@ void *parse_hostcond(char *addr, bool is_port)
 	/* URL-like literal [] */
 	if (addr[0] == '[') {
 		addr++;
-		if ((port = strchr(addr, ']')) == NULL)
+		port = strchr(addr, ']');
+		if (port == NULL)
 			return NULL;
 		*port++ = 0;
 	} else if (addr[0] == '*') {
@@ -2216,44 +2223,43 @@ void *parse_hostcond(char *addr, bool is_port)
 		if (*port == ':')
 			*port++ = 0;
 
-		if (*port && *port != '*') {
-			if (get_integer(&a.port, port, 0)) {
-				struct servent *se1 = NULL;
-				struct servent *se2 = NULL;
-
-				if (current_filter.dbs&(1<<UDP_DB))
-					se1 = getservbyname(port, UDP_PROTO);
-				if (current_filter.dbs&(1<<TCP_DB))
-					se2 = getservbyname(port, TCP_PROTO);
-				if (se1 && se2 && se1->s_port != se2->s_port) {
-					fprintf(stderr, "Error: ambiguous port \"%s\".\n", port);
-					return NULL;
-				}
-				if (!se1)
-					se1 = se2;
-				if (se1) {
-					a.port = ntohs(se1->s_port);
-				} else {
-					struct scache *s;
-
-					for (s = rlist; s; s = s->next) {
-						if ((s->proto == UDP_PROTO &&
-						     (current_filter.dbs&(1<<UDP_DB))) ||
-						    (s->proto == TCP_PROTO &&
-						     (current_filter.dbs&(1<<TCP_DB)))) {
-							if (s->name && strcmp(s->name, port) == 0) {
-								if (a.port > 0 && a.port != s->port) {
-									fprintf(stderr, "Error: ambiguous port \"%s\".\n", port);
-									return NULL;
-								}
-								a.port = s->port;
+		if (*port && *port != '*' &&
+		    get_integer(&a.port, port, 0)) {
+			struct servent *se1 = NULL;
+			struct servent *se2 = NULL;
+
+			if (current_filter.dbs&(1<<UDP_DB))
+				se1 = getservbyname(port, UDP_PROTO);
+			if (current_filter.dbs&(1<<TCP_DB))
+				se2 = getservbyname(port, TCP_PROTO);
+			if (se1 && se2 && se1->s_port != se2->s_port) {
+				fprintf(stderr, "Error: ambiguous port \"%s\".\n", port);
+				return NULL;
+			}
+			if (!se1)
+				se1 = se2;
+			if (se1) {
+				a.port = ntohs(se1->s_port);
+			} else {
+				struct scache *s;
+
+				for (s = rlist; s; s = s->next) {
+					if ((s->proto == UDP_PROTO &&
+					     (current_filter.dbs&(1<<UDP_DB))) ||
+					    (s->proto == TCP_PROTO &&
+					     (current_filter.dbs&(1<<TCP_DB)))) {
+						if (s->name && strcmp(s->name, port) == 0) {
+							if (a.port > 0 && a.port != s->port) {
+								fprintf(stderr, "Error: ambiguous port \"%s\".\n", port);
+								return NULL;
 							}
+							a.port = s->port;
 						}
 					}
-					if (a.port <= 0) {
-						fprintf(stderr, "Error: \"%s\" does not look like a port.\n", port);
-						return NULL;
-					}
+				}
+				if (a.port <= 0) {
+					fprintf(stderr, "Error: \"%s\" does not look like a port.\n", port);
+					return NULL;
 				}
 			}
 		}
@@ -2270,6 +2276,7 @@ void *parse_hostcond(char *addr, bool is_port)
 out:
 	if (fam != AF_UNSPEC) {
 		int states = f->states;
+
 		f->families = 0;
 		filter_af_set(f, fam);
 		filter_states_set(f, states);
@@ -2329,48 +2336,49 @@ static void inet_stats_print(struct sockstat *s, bool v6only)
 	proc_ctx_print(s);
 }
 
-static int proc_parse_inet_addr(char *loc, char *rem, int family, struct
-		sockstat * s)
+static void proc_parse_inet_addr(char *loc, char *rem, int family, struct
+				 sockstat *s)
 {
 	s->local.family = s->remote.family = family;
 	if (family == AF_INET) {
 		sscanf(loc, "%x:%x", s->local.data, (unsigned *)&s->lport);
 		sscanf(rem, "%x:%x", s->remote.data, (unsigned *)&s->rport);
 		s->local.bytelen = s->remote.bytelen = 4;
-		return 0;
-	} else {
-		sscanf(loc, "%08x%08x%08x%08x:%x",
-		       s->local.data,
-		       s->local.data + 1,
-		       s->local.data + 2,
-		       s->local.data + 3,
-		       &s->lport);
-		sscanf(rem, "%08x%08x%08x%08x:%x",
-		       s->remote.data,
-		       s->remote.data + 1,
-		       s->remote.data + 2,
-		       s->remote.data + 3,
-		       &s->rport);
-		s->local.bytelen = s->remote.bytelen = 16;
-		return 0;
+		return;
 	}
-	return -1;
+
+	sscanf(loc, "%08x%08x%08x%08x:%x",
+	       s->local.data,
+	       s->local.data + 1,
+	       s->local.data + 2,
+	       s->local.data + 3,
+	       &s->lport);
+	sscanf(rem, "%08x%08x%08x%08x:%x",
+	       s->remote.data,
+	       s->remote.data + 1,
+	       s->remote.data + 2,
+	       s->remote.data + 3,
+	       &s->rport);
+	s->local.bytelen = s->remote.bytelen = 16;
 }
 
 static int proc_inet_split_line(char *line, char **loc, char **rem, char **data)
 {
 	char *p;
 
-	if ((p = strchr(line, ':')) == NULL)
+	p = strchr(line, ':');
+	if (!p)
 		return -1;
 
 	*loc = p+2;
-	if ((p = strchr(*loc, ':')) == NULL)
+	p = strchr(*loc, ':');
+	if (!p)
 		return -1;
 
 	p[5] = 0;
 	*rem = p+6;
-	if ((p = strchr(*rem, ':')) == NULL)
+	p = strchr(*rem, ':');
+	if (!p)
 		return -1;
 
 	p[5] = 0;
@@ -2836,7 +2844,7 @@ static void tcp_tls_conf(const char *name, struct rtattr *attr)
 	}
 }
 
-#define TCPI_HAS_OPT(info, opt) !!(info->tcpi_options & (opt))
+#define TCPI_HAS_OPT(info, opt) (!!((info)->tcpi_options & (opt)))
 
 static void tcp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 		struct rtattr *tb[])
@@ -3059,6 +3067,7 @@ static void sctp_show_info(const struct nlmsghdr *nlh, struct inet_diag_msg *r,
 	}
 	if (tb[INET_DIAG_INFO]) {
 		struct sctp_info *info;
+
 		len = RTA_PAYLOAD(tb[INET_DIAG_INFO]);
 
 		/* workaround for older kernels with less fields */
@@ -3252,6 +3261,7 @@ static int tcpdiag_send(int fd, int protocol, struct filter *f)
 static int sockdiag_send(int family, int fd, int protocol, struct filter *f)
 {
 	struct sockaddr_nl nladdr = { .nl_family = AF_NETLINK };
+
 	DIAG_REQUEST(req, struct inet_diag_req_v2 r);
 	char    *bc = NULL;
 	int	bclen;
@@ -3365,10 +3375,9 @@ static int show_one_inet_sock(struct nlmsghdr *h, void *arg)
 		if (errno == EOPNOTSUPP || errno == ENOENT) {
 			/* Socket can't be closed, or is already closed. */
 			return 0;
-		} else {
-			perror("SOCK_DESTROY answers");
-			return -1;
 		}
+		perror("SOCK_DESTROY answers");
+		return -1;
 	}
 
 	err = inet_show_sock(h, &s);
@@ -3402,10 +3411,12 @@ static int inet_show_netlink(struct filter *f, FILE *dump_fp, int protocol)
 		family = PF_INET6;
 
 again:
-	if ((err = sockdiag_send(family, rth.fd, protocol, f)))
+	err = sockdiag_send(family, rth.fd, protocol, f);
+	if (err)
 		goto Exit;
 
-	if ((err = rtnl_dump_filter(&rth, show_one_inet_sock, &arg))) {
+	err = rtnl_dump_filter(&rth, show_one_inet_sock, &arg);
+	if (err) {
 		if (family != PF_UNSPEC) {
 			family = PF_UNSPEC;
 			goto again;
@@ -3430,7 +3441,8 @@ static int tcp_show_netlink_file(struct filter *f)
 	char	buf[16384];
 	int	err = -1;
 
-	if ((fp = fopen(getenv("TCPDIAG_FILE"), "r")) == NULL) {
+	fp = fopen(getenv("TCPDIAG_FILE"), "r");
+	if (!fp) {
 		perror("fopen($TCPDIAG_FILE)");
 		return err;
 	}
@@ -3516,7 +3528,8 @@ static int tcp_show(struct filter *f)
 
 	/* Sigh... We have to parse /proc/net/tcp... */
 	while (bufsize >= 64*1024) {
-		if ((buf = malloc(bufsize)) != NULL)
+		buf = malloc(bufsize);
+		if (buf != NULL)
 			break;
 		bufsize /= 2;
 	}
@@ -3526,7 +3539,8 @@ static int tcp_show(struct filter *f)
 	}
 
 	if (f->families & FAMILY_MASK(AF_INET)) {
-		if ((fp = net_tcp_open()) == NULL)
+		fp = net_tcp_open();
+		if (!fp)
 			goto outerr;
 
 		setbuffer(fp, buf, bufsize);
@@ -3535,8 +3549,11 @@ static int tcp_show(struct filter *f)
 		fclose(fp);
 	}
 
-	if ((f->families & FAMILY_MASK(AF_INET6)) &&
-	    (fp = net_tcp6_open()) != NULL) {
+	if (f->families & FAMILY_MASK(AF_INET6)) {
+		fp = net_tcp6_open();
+		if (!fp)
+			goto outerr;
+
 		setbuffer(fp, buf, bufsize);
 		if (generic_record_read(fp, tcp_show_line, f, AF_INET6))
 			goto outerr;
@@ -3633,16 +3650,19 @@ static int udp_show(struct filter *f)
 	    && inet_show_netlink(f, NULL, IPPROTO_UDP) == 0)
 		return 0;
 
-	if (f->families&FAMILY_MASK(AF_INET)) {
-		if ((fp = net_udp_open()) == NULL)
+	if (f->families & FAMILY_MASK(AF_INET)) {
+		fp = net_udp_open();
+		if (!fp)
 			goto outerr;
 		if (generic_record_read(fp, dgram_show_line, f, AF_INET))
 			goto outerr;
 		fclose(fp);
 	}
 
-	if ((f->families&FAMILY_MASK(AF_INET6)) &&
-	    (fp = net_udp6_open()) != NULL) {
+	if (f->families & FAMILY_MASK(AF_INET6)) {
+		fp = net_udp6_open();
+		if (!fp)
+			goto outerr;
 		if (generic_record_read(fp, dgram_show_line, f, AF_INET6))
 			goto outerr;
 		fclose(fp);
@@ -3673,18 +3693,22 @@ static int raw_show(struct filter *f)
 	    inet_show_netlink(f, NULL, IPPROTO_RAW) == 0)
 		return 0;
 
-	if (f->families&FAMILY_MASK(AF_INET)) {
-		if ((fp = net_raw_open()) == NULL)
+	if (f->families & FAMILY_MASK(AF_INET)) {
+		fp = net_raw_open();
+		if (!fp)
 			goto outerr;
 		if (generic_record_read(fp, dgram_show_line, f, AF_INET))
 			goto outerr;
 		fclose(fp);
 	}
 
-	if ((f->families&FAMILY_MASK(AF_INET6)) &&
-	    (fp = net_raw6_open()) != NULL) {
+	if (f->families & FAMILY_MASK(AF_INET6)) {
+		fp = net_raw6_open();
+		if (!fp)
+			goto outerr;
 		if (generic_record_read(fp, dgram_show_line, f, AF_INET6))
 			goto outerr;
+
 		fclose(fp);
 	}
 	return 0;
@@ -3768,6 +3792,7 @@ static int unix_show_sock(struct nlmsghdr *nlh, void *arg)
 		name[len] = '\0';
 		if (name[0] == '\0') {
 			int i;
+
 			for (i = 0; i < len; i++)
 				if (name[i] == '\0')
 					name[i] = '@';
@@ -3869,7 +3894,8 @@ static int unix_show(struct filter *f)
 	    && unix_show_netlink(f) == 0)
 		return 0;
 
-	if ((fp = net_unix_open()) == NULL)
+	fp = net_unix_open();
+	if (!fp)
 		return -1;
 	if (!fgets(buf, sizeof(buf), fp)) {
 		fclose(fp);
@@ -3884,7 +3910,8 @@ static int unix_show(struct filter *f)
 		struct sockstat *u, **insp;
 		int flags;
 
-		if (!(u = calloc(1, sizeof(*u))))
+		u = calloc(1, sizeof(*u));
+		if (!u)
 			break;
 
 		if (sscanf(buf, "%x: %x %x %x %x %x %d %s",
@@ -4226,7 +4253,8 @@ static int packet_show(struct filter *f)
 			packet_show_netlink(f) == 0)
 		return 0;
 
-	if ((fp = net_packet_open()) == NULL)
+	fp = net_packet_open();
+	if (!fp)
 		return -1;
 	if (generic_record_read(fp, packet_show_line, f, AF_PACKET))
 		rc = -1;
@@ -4420,7 +4448,8 @@ static int netlink_show_one(struct filter *f,
 
 			snprintf(procname, sizeof(procname), "%s/%d/stat",
 				getenv("PROC_ROOT") ? : "/proc", pid);
-			if ((fp = fopen(procname, "r")) != NULL) {
+			fp = fopen(procname, "r");
+			if (fp) {
 				if (fscanf(fp, "%*d (%[^)])", procname) == 1) {
 					snprintf(procname+strlen(procname),
 						sizeof(procname)-strlen(procname),
@@ -4466,9 +4495,8 @@ static int netlink_show_one(struct filter *f,
 		free(pid_context);
 	}
 
-	if (show_details) {
+	if (show_details)
 		out(" sk=%llx cb=%llx groups=0x%08x", sk, cb, groups);
-	}
 
 	return 0;
 }
@@ -4537,7 +4565,8 @@ static int netlink_show(struct filter *f)
 		netlink_show_netlink(f) == 0)
 		return 0;
 
-	if ((fp = net_netlink_open()) == NULL)
+	fp = net_netlink_open();
+	if (!fp)
 		return -1;
 	if (!fgets(buf, sizeof(buf), fp)) {
 		fclose(fp);
@@ -4826,7 +4855,8 @@ static int get_snmp_int(char *proto, char *key, int *result)
 
 	*result = 0;
 
-	if ((fp = net_snmp_open()) == NULL)
+	fp = net_snmp_open();
+	if (fp == NULL)
 		return -1;
 
 	while (fgets(buf, sizeof(buf), fp) != NULL) {
@@ -4919,13 +4949,15 @@ static int get_sockstat(struct ssummary *s)
 
 	memset(s, 0, sizeof(*s));
 
-	if ((fp = net_sockstat_open()) == NULL)
+	fp = net_sockstat_open();
+	if (!fp)
 		return -1;
 	while (fgets(buf, sizeof(buf), fp) != NULL)
 		get_sockstat_line(buf, s);
 	fclose(fp);
 
-	if ((fp = net_sockstat6_open()) == NULL)
+	fp = net_sockstat6_open();
+	if (fp == NULL)
 		return 0;
 	while (fgets(buf, sizeof(buf), fp) != NULL)
 		get_sockstat_line(buf, s);
@@ -5265,7 +5297,8 @@ int main(int argc, char *argv[])
 			}
 			p = p1 = optarg;
 			do {
-				if ((p1 = strchr(p, ',')) != NULL)
+				p1 = strchr(p, ',');
+				if (p1 != NULL)
 					*p1 = 0;
 				if (filter_db_parse(&current_filter, p)) {
 					fprintf(stderr, "ss: \"%s\" is illegal socket table id\n", p);
-- 
2.20.1

