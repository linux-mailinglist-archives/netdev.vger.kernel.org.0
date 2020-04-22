Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 811C21B4EEF
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 23:13:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726589AbgDVVNV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 17:13:21 -0400
Received: from pb-smtp21.pobox.com ([173.228.157.53]:63763 "EHLO
        pb-smtp21.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726161AbgDVVNU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Apr 2020 17:13:20 -0400
Received: from pb-smtp21.pobox.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id B53CDC1DDB;
        Wed, 22 Apr 2020 17:13:14 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=pobox.com; h=date:from:to
        :cc:subject:in-reply-to:message-id:references:mime-version
        :content-type; s=sasl; bh=KCqFDkcnN7N1Y7R0KRCvFAr8MLI=; b=KIbKWh
        AbdIWaBaebAgLwoh2ThPlltYCc2foyVfx3t5RGx23zPbfk5ZygFMQ6V+xFMTq1kE
        9293hckV2hM9HE8YnviV92teAo25sN5Pn1+gMhJAW8tmTdxqo874AP+U+IHEAe1v
        Jb3C1C3k7xq53FLrbl57aYbe547PHqFcI8j8o=
Received: from pb-smtp21.sea.icgroup.com (unknown [127.0.0.1])
        by pb-smtp21.pobox.com (Postfix) with ESMTP id 9F526C1DDA;
        Wed, 22 Apr 2020 17:13:14 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed; d=fluxnic.net;
 h=date:from:to:cc:subject:in-reply-to:message-id:references:mime-version:content-type; s=2016-12.pbsmtp; bh=nfzC0aNp5HVyqlWKusrH+9gqQGBzO85jDBBTE4zv1kI=; b=dSk4dlZT9yKZv4bLmdcgCoTwO5y1setDry4GEaS+RjW57zBXRzcW7Lw2o6AV/+F/HGYODms0BJU7IykvnTc2LG84CJToIzhXgGVw9UPFmhaiBrWUb/nGnT5E+1aAaIeVtyzTKAkQZguQLF20DzrON2J7R3/wvmDwZ9szXZb53ME=
Received: from yoda.home (unknown [24.203.50.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by pb-smtp21.pobox.com (Postfix) with ESMTPSA id 5AD9CC1DD9;
        Wed, 22 Apr 2020 17:13:11 -0400 (EDT)
        (envelope-from nico@fluxnic.net)
Received: from xanadu.home (xanadu.home [192.168.2.2])
        by yoda.home (Postfix) with ESMTPSA id 6C2822DA0D31;
        Wed, 22 Apr 2020 17:13:09 -0400 (EDT)
Date:   Wed, 22 Apr 2020 17:13:09 -0400 (EDT)
From:   Nicolas Pitre <nico@fluxnic.net>
To:     Jani Nikula <jani.nikula@linux.intel.com>
cc:     Saeed Mahameed <saeedm@mellanox.com>,
        "masahiroy@kernel.org" <masahiroy@kernel.org>,
        "Laurent.pinchart@ideasonboard.com" 
        <Laurent.pinchart@ideasonboard.com>,
        "airlied@linux.ie" <airlied@linux.ie>,
        "jgg@ziepe.ca" <jgg@ziepe.ca>,
        "linux-kbuild@vger.kernel.org" <linux-kbuild@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jernej.skrabec@siol.net" <jernej.skrabec@siol.net>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "jonas@kwiboo.se" <jonas@kwiboo.se>,
        "kieran.bingham+renesas@ideasonboard.com" 
        <kieran.bingham+renesas@ideasonboard.com>,
        "narmstrong@baylibre.com" <narmstrong@baylibre.com>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [RFC PATCH 1/2] Kconfig: Introduce "uses" keyword
In-Reply-To: <871rofdhtg.fsf@intel.com>
Message-ID: <nycvar.YSQ.7.76.2004221649480.2671@knanqh.ubzr>
References: <20200417011146.83973-1-saeedm@mellanox.com> <CAK7LNAQZd_LUyA2V_pCvMTr_201nSX1Nm0TDw5kOeNV64rOfpA@mail.gmail.com> <nycvar.YSQ.7.76.2004181509030.2671@knanqh.ubzr> <CAK7LNATmPD1R+Ranis2u3yohx8b0+dGKAvFpjg8Eo9yEHRT6zQ@mail.gmail.com>
 <87v9lu1ra6.fsf@intel.com> <45b9efec57b2e250e8e39b3b203eb8cee10cb6e8.camel@mellanox.com> <nycvar.YSQ.7.76.2004210951160.2671@knanqh.ubzr> <62a51b2e5425a3cca4f7a66e2795b957f237b2da.camel@mellanox.com> <nycvar.YSQ.7.76.2004211411500.2671@knanqh.ubzr>
 <871rofdhtg.fsf@intel.com>
User-Agent: Alpine 2.21 (LFD 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Pobox-Relay-ID: 125CCF72-84DE-11EA-B4E7-8D86F504CC47-78420484!pb-smtp21.pobox.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Apr 2020, Jani Nikula wrote:

> On Tue, 21 Apr 2020, Nicolas Pitre <nico@fluxnic.net> wrote:
> > This is really a conditional dependency. That's all this is about.
> > So why not simply making it so rather than fooling ourselves? All that 
> > is required is an extension that would allow:
> >
> > 	depends on (expression) if (expression)
> >
> > This construct should be obvious even without reading the doc, is 
> > already used extensively for other things already, and is flexible 
> > enough to cover all sort of cases in addition to this particular one.
> 
> Okay, you convinced me. Now you only need to convince whoever is doing
> the actual work of implementing this stuff. ;)

What about this:

----- >8
Subject: [PATCH] kconfig: allow for conditional dependencies

This might appear to be a strange concept, but sometimes we want
a dependency to be conditionally applied. One such case is currently
expressed with:

	depends on FOO || !FOO

This pattern is strange enough to give one's pause. Given that it is
also frequent, let's make the intent more obvious with some syntaxic 
sugar by effectively making dependencies optionally conditional.
This also makes the kconfig language more uniform.

Signed-off-by: Nicolas Pitre <nico@fluxnic.net>

diff --git a/Documentation/kbuild/kconfig-language.rst b/Documentation/kbuild/kconfig-language.rst
index d0111dd264..0f841e0037 100644
--- a/Documentation/kbuild/kconfig-language.rst
+++ b/Documentation/kbuild/kconfig-language.rst
@@ -114,7 +114,7 @@ applicable everywhere (see syntax).
   This is a shorthand notation for a type definition plus a value.
   Optionally dependencies for this default value can be added with "if".
 
-- dependencies: "depends on" <expr>
+- dependencies: "depends on" <expr> ["if" <expr>]
 
   This defines a dependency for this menu entry. If multiple
   dependencies are defined, they are connected with '&&'. Dependencies
@@ -130,6 +130,16 @@ applicable everywhere (see syntax).
 	bool "foo"
 	default y
 
+  The dependency definition itself may be conditional by appending "if"
+  followed by an expression. If such expression is false (n) then this
+  dependency is ignored. One possible use case is:
+
+    config FOO
+	tristate
+	depends on BAZ if BAZ != n
+
+  meaning that FOO is constrained by the value of BAZ only when it is set.
+
 - reverse dependencies: "select" <symbol> ["if" <expr>]
 
   While normal dependencies reduce the upper limit of a symbol (see
diff --git a/scripts/kconfig/lkc.h b/scripts/kconfig/lkc.h
index d4ca829736..1a9337d1b9 100644
--- a/scripts/kconfig/lkc.h
+++ b/scripts/kconfig/lkc.h
@@ -72,7 +72,7 @@ void menu_warn(struct menu *menu, const char *fmt, ...);
 struct menu *menu_add_menu(void);
 void menu_end_menu(void);
 void menu_add_entry(struct symbol *sym);
-void menu_add_dep(struct expr *dep);
+void menu_add_dep(struct expr *dep, struct expr *cond);
 void menu_add_visibility(struct expr *dep);
 struct property *menu_add_prompt(enum prop_type type, char *prompt, struct expr *dep);
 void menu_add_expr(enum prop_type type, struct expr *expr, struct expr *dep);
diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index e436ba44c9..e6b204225e 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -103,8 +103,22 @@ static struct expr *rewrite_m(struct expr *e)
 	return e;
 }
 
-void menu_add_dep(struct expr *dep)
+void menu_add_dep(struct expr *dep, struct expr *cond)
 {
+	if (cond) {
+		struct expr *cond2, *left, *right;
+		/*
+		 * We have "depends on X if Y" and we want:
+		 *	Y != n --> X
+		 *	Y == n --> y
+		 * Meaning: ((Y != n) && X) || (Y == n)
+		 */
+		cond2 = expr_copy(cond);
+		left = expr_trans_compare(cond2, E_UNEQUAL, &symbol_no);
+		left = expr_alloc_and(dep, left);
+		right = expr_trans_compare(cond, E_EQUAL, &symbol_no);
+		dep = expr_alloc_or(left, right);
+	}
 	current_entry->dep = expr_alloc_and(current_entry->dep, dep);
 }
 
diff --git a/scripts/kconfig/parser.y b/scripts/kconfig/parser.y
index 708b6c4b13..4161207da2 100644
--- a/scripts/kconfig/parser.y
+++ b/scripts/kconfig/parser.y
@@ -316,7 +316,7 @@ if_entry: T_IF expr T_EOL
 {
 	printd(DEBUG_PARSE, "%s:%d:if\n", zconf_curname(), zconf_lineno());
 	menu_add_entry(NULL);
-	menu_add_dep($2);
+	menu_add_dep($2, NULL);
 	$$ = menu_add_menu();
 };
 
@@ -412,9 +412,9 @@ help: help_start T_HELPTEXT
 
 /* depends option */
 
-depends: T_DEPENDS T_ON expr T_EOL
+depends: T_DEPENDS T_ON expr if_expr T_EOL
 {
-	menu_add_dep($3);
+	menu_add_dep($3, $4);
 	printd(DEBUG_PARSE, "%s:%d:depends on\n", zconf_curname(), zconf_lineno());
 };
 
