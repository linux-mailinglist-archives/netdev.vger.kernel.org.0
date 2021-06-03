Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E73C39A635
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 18:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhFCQuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 12:50:11 -0400
Received: from mail-lj1-f178.google.com ([209.85.208.178]:34766 "EHLO
        mail-lj1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230169AbhFCQuK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Jun 2021 12:50:10 -0400
Received: by mail-lj1-f178.google.com with SMTP id bn21so8003317ljb.1
        for <netdev@vger.kernel.org>; Thu, 03 Jun 2021 09:48:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=u4stFmqeGwZ9jPeKxRWKxo1lUkYnsefh819yFVSAOZ0=;
        b=jtYZCgjaHcE1QTxr2zefyG+W5oQ1vy29/ehy8hb+z3pvmp1T1RgEg9czj5anlt91EA
         esnwQRo45XrH4IGhbJu43o71pEzJjSXMGfMto3o97pqk46OfbwGkXR/C3tjVQadoH43K
         Fs1qfbjNQcZJV+dZ5ZqYdPEMB1SIhHMExdYYTArIDhk/2VQEt5pMgfXHzFUqgdzORgws
         Dpeg3wmAZBNVEqLLvGyXgNmP5ElIg5v6gj8o0o3FtsLrNX1+3RUF4/cB2Si1z6s7geXl
         YDHoWs7o/pMK7z3lwUvi7ESWvdhU0vFyqhVVoHWjOiGDyD7r6NpEd+pPEQfDV2v/Ubt+
         hJog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=u4stFmqeGwZ9jPeKxRWKxo1lUkYnsefh819yFVSAOZ0=;
        b=aqg1k1y0zX0oGQvADMQI7qz3h9gip/7ViGQsc92tpz17qyGfACRVO3LITEdMt6d/Nq
         lL1PRA76eSIsDrIKkpoaruwrNHXjI9F3idqXV1qrJ1h4PV/QIbX3S/yHhYaPVoiBbpW/
         8S+hOAzvFbVUOBsxLDVmB0LLEexJLaugLTGV9j3GCDOIuZxz4et9jigS+toDwls7Jabx
         xcT5QLCXX8bBLGCAW0wms6KJNpt23eMw1DygLQDUhINymtiTzyOAUVGK/291bpCJ9njO
         RWw7pAs+jyUi0F/W9nqnQfGPD+XJxP4jmmff//bL9gsqRe4aTRL73RdTIL+15JDHdNPK
         XIGg==
X-Gm-Message-State: AOAM531zVEIMaF67FTu4mdf5RYKXKN8xrr1pzcL+yWFwaj8vzojNcJV4
        D+FWziYJUf0O3CBioCIqqT/0zg==
X-Google-Smtp-Source: ABdhPJzQ32jC1s6nfYd/PsAzPZ5lS/5In22ckWZUd7Q+WWmnBq+89IFtxdQEBOkWXYh2wM1mbpPOFQ==
X-Received: by 2002:a2e:95cb:: with SMTP id y11mr198772ljh.461.1622738844934;
        Thu, 03 Jun 2021 09:47:24 -0700 (PDT)
Received: from localhost ([178.252.72.51])
        by smtp.gmail.com with ESMTPSA id m12sm366359lfb.72.2021.06.03.09.47.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Jun 2021 09:47:24 -0700 (PDT)
Date:   Thu, 3 Jun 2021 20:47:20 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     bpf@vger.kernel.org
Cc:     ast@kernel.org, davem@davemloft.net, daniel@iogearbox.net,
        andrii@kernel.org, kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, rdna@fb.com
Subject: Re: [PATCH bpf-next v1 06/10] bpfilter: Add struct target
Message-ID: <20210603164720.jrazocxcytvcuqgp@amnesia>
References: <20210603101425.560384-1-me@ubique.spb.ru>
 <20210603101425.560384-7-me@ubique.spb.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210603101425.560384-7-me@ubique.spb.ru>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 03, 2021 at 02:14:21PM +0400, Dmitrii Banshchikov wrote:
> struct target_ops defines polymorphic interface for targets. A target
> consists of pointers to struct target_ops and struct xt_entry_target
> which contains a payload for the target's type.
> 
> All target_ops are kept in a map by their name.
> 
> Signed-off-by: Dmitrii Banshchikov <me@ubique.spb.ru>
> ---
>  .clang-format                                 |   2 +-
>  net/bpfilter/Makefile                         |   2 +-
>  net/bpfilter/context.c                        |  36 +++++-
>  net/bpfilter/context.h                        |   1 +
>  net/bpfilter/target.c                         | 118 ++++++++++++++++++
>  net/bpfilter/target.h                         |  49 ++++++++
>  .../testing/selftests/bpf/bpfilter/.gitignore |   1 +
>  tools/testing/selftests/bpf/bpfilter/Makefile |   7 +-
>  .../selftests/bpf/bpfilter/bpfilter_util.h    |  31 +++++
>  .../selftests/bpf/bpfilter/test_target.c      |  85 +++++++++++++
>  10 files changed, 327 insertions(+), 5 deletions(-)
>  create mode 100644 net/bpfilter/target.c
>  create mode 100644 net/bpfilter/target.h
>  create mode 100644 tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
>  create mode 100644 tools/testing/selftests/bpf/bpfilter/test_target.c
> 
> diff --git a/.clang-format b/.clang-format
> index c24b147cac01..3212542df113 100644
> --- a/.clang-format
> +++ b/.clang-format
> @@ -52,7 +52,7 @@ BreakConstructorInitializersBeforeComma: false
>  #BreakConstructorInitializers: BeforeComma # Unknown to clang-format-4.0
>  BreakAfterJavaFieldAnnotations: false
>  BreakStringLiterals: false
> -ColumnLimit: 80
> +ColumnLimit: 100

Obviously this is not intended to be here.


>  CommentPragmas: '^ IWYU pragma:'
>  #CompactNamespaces: false # Unknown to clang-format-4.0
>  ConstructorInitializerAllOnOneLineOrOnePerLine: false
> diff --git a/net/bpfilter/Makefile b/net/bpfilter/Makefile
> index 59f2d35c1627..031c9dd40d2d 100644
> --- a/net/bpfilter/Makefile
> +++ b/net/bpfilter/Makefile
> @@ -4,7 +4,7 @@
>  #
>  
>  userprogs := bpfilter_umh
> -bpfilter_umh-objs := main.o map-common.o match.o context.o
> +bpfilter_umh-objs := main.o map-common.o context.o match.o target.o
>  bpfilter_umh-objs += xt_udp.o
>  userccflags += -I $(srctree)/tools/include/ -I $(srctree)/tools/include/uapi
>  
> diff --git a/net/bpfilter/context.c b/net/bpfilter/context.c
> index 6b6203dd22a7..6e186399609e 100644
> --- a/net/bpfilter/context.c
> +++ b/net/bpfilter/context.c
> @@ -12,6 +12,7 @@
>  
>  #include "map-common.h"
>  #include "match.h"
> +#include "target.h"
>  
>  static int init_match_ops_map(struct context *ctx)
>  {
> @@ -33,12 +34,45 @@ static int init_match_ops_map(struct context *ctx)
>  	return 0;
>  }
>  
> +static int init_target_ops_map(struct context *ctx)
> +{
> +	const struct target_ops *target_ops[] = { &standard_target_ops, &error_target_ops };
> +	int i, err;
> +
> +	err = create_map(&ctx->target_ops_map, ARRAY_SIZE(target_ops));
> +	if (err)
> +		return err;
> +
> +	for (i = 0; i < ARRAY_SIZE(target_ops); ++i) {
> +		const struct target_ops *t = target_ops[i];
> +
> +		err = map_insert(&ctx->target_ops_map, t->name, (void *)t);
> +		if (err)
> +			return err;
> +	}
> +
> +	return 0;
> +}
> +
>  int create_context(struct context *ctx)
>  {
> -	return init_match_ops_map(ctx);
> +	int err;
> +
> +	err = init_match_ops_map(ctx);
> +	if (err)
> +		return err;
> +
> +	err = init_target_ops_map(ctx);
> +	if (err) {
> +		free_map(&ctx->match_ops_map);
> +		return err;
> +	}
> +
> +	return 0;
>  }
>  
>  void free_context(struct context *ctx)
>  {
>  	free_map(&ctx->match_ops_map);
> +	free_map(&ctx->target_ops_map);
>  }
> diff --git a/net/bpfilter/context.h b/net/bpfilter/context.h
> index 60bb525843b0..ed268259adcc 100644
> --- a/net/bpfilter/context.h
> +++ b/net/bpfilter/context.h
> @@ -15,6 +15,7 @@
>  struct context {
>  	FILE *log_file;
>  	struct hsearch_data match_ops_map;
> +	struct hsearch_data target_ops_map;
>  };
>  
>  #define BFLOG_IMPL(ctx, level, fmt, ...)                                                           \
> diff --git a/net/bpfilter/target.c b/net/bpfilter/target.c
> new file mode 100644
> index 000000000000..f87ef719ea4d
> --- /dev/null
> +++ b/net/bpfilter/target.c
> @@ -0,0 +1,118 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#define _GNU_SOURCE
> +
> +#include "target.h"
> +
> +#include <linux/err.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +#include <errno.h>
> +#include <string.h>
> +
> +#include "context.h"
> +#include "map-common.h"
> +
> +static const struct target_ops *target_ops_map_find(struct hsearch_data *map, const char *name)
> +{
> +	const size_t namelen = strnlen(name, BPFILTER_EXTENSION_MAXNAMELEN);
> +
> +	if (namelen < BPFILTER_EXTENSION_MAXNAMELEN)
> +		return map_find(map, name);
> +
> +	return ERR_PTR(-EINVAL);
> +}
> +
> +static int standard_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
> +{
> +	const struct bpfilter_ipt_standard_target *standard_target;
> +
> +	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
> +
> +	// Positive values of verdict denote a jump offset into a blob.
> +	if (standard_target->verdict > 0)
> +		return 0;
> +
> +	// Special values like ACCEPT, DROP, RETURN are encoded as negative values.
> +	if (standard_target->verdict < 0) {
> +		if (standard_target->verdict == BPFILTER_RETURN)
> +			return 0;
> +
> +		switch (convert_verdict(standard_target->verdict)) {
> +		case BPFILTER_NF_ACCEPT:
> +		case BPFILTER_NF_DROP:
> +		case BPFILTER_NF_QUEUE:
> +			return 0;
> +		}
> +	}
> +
> +	BFLOG_DEBUG(ctx, "invalid verdict: %d\n", standard_target->verdict);
> +
> +	return -EINVAL;
> +}
> +
> +const struct target_ops standard_target_ops = {
> +	.name = "",
> +	.revision = 0,
> +	.size = sizeof(struct xt_standard_target),
> +	.check = standard_target_check,
> +};
> +
> +static int error_target_check(struct context *ctx, const struct bpfilter_ipt_target *ipt_target)
> +{
> +	const struct bpfilter_ipt_error_target *error_target;
> +	size_t maxlen;
> +
> +	error_target = (const struct bpfilter_ipt_error_target *)&ipt_target;
> +	maxlen = sizeof(error_target->error_name);
> +	if (strnlen(error_target->error_name, maxlen) == maxlen) {
> +		BFLOG_DEBUG(ctx, "cannot check error target: too long errorname\n");
> +		return -EINVAL;
> +	}
> +
> +	return 0;
> +}
> +
> +const struct target_ops error_target_ops = {
> +	.name = "ERROR",
> +	.revision = 0,
> +	.size = sizeof(struct xt_error_target),
> +	.check = error_target_check,
> +};
> +
> +int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
> +		struct target *target)
> +{
> +	const size_t maxlen = sizeof(ipt_target->u.user.name);
> +	const struct target_ops *found;
> +	int err;
> +
> +	if (strnlen(ipt_target->u.user.name, maxlen) == maxlen) {
> +		BFLOG_DEBUG(ctx, "cannot init target: too long target name\n");
> +		return -EINVAL;
> +	}
> +
> +	found = target_ops_map_find(&ctx->target_ops_map, ipt_target->u.user.name);
> +	if (IS_ERR(found)) {
> +		BFLOG_DEBUG(ctx, "cannot find target by name: '%s'\n", ipt_target->u.user.name);
> +		return PTR_ERR(found);
> +	}
> +
> +	if (found->size != ipt_target->u.target_size ||
> +	    found->revision != ipt_target->u.user.revision) {
> +		BFLOG_DEBUG(ctx, "invalid target: '%s'\n", ipt_target->u.user.name);
> +		return -EINVAL;
> +	}
> +
> +	err = found->check(ctx, ipt_target);
> +	if (err)
> +		return err;
> +
> +	target->target_ops = found;
> +	target->ipt_target = ipt_target;
> +
> +	return 0;
> +}
> diff --git a/net/bpfilter/target.h b/net/bpfilter/target.h
> new file mode 100644
> index 000000000000..e27816d73cc2
> --- /dev/null
> +++ b/net/bpfilter/target.h
> @@ -0,0 +1,49 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (c) 2021 Telegram FZ-LLC
> + */
> +
> +#ifndef NET_BPFILTER_TARGET_H
> +#define NET_BPFILTER_TARGET_H
> +
> +#include "../../include/uapi/linux/bpfilter.h"
> +
> +#include <stdint.h>
> +
> +struct context;
> +struct target_ops_map;
> +
> +struct target_ops {
> +	char name[BPFILTER_EXTENSION_MAXNAMELEN];
> +	uint8_t revision;
> +	uint16_t size;
> +	int (*check)(struct context *ctx, const struct bpfilter_ipt_target *ipt_target);
> +};
> +
> +struct target {
> +	const struct target_ops *target_ops;
> +	const struct bpfilter_ipt_target *ipt_target;
> +};
> +
> +extern const struct target_ops standard_target_ops;
> +extern const struct target_ops error_target_ops;
> +
> +/* Restore verdict's special value(ACCEPT, DROP, etc.) from its negative representation. */
> +static inline int convert_verdict(int verdict)
> +{
> +	return -verdict - 1;
> +}
> +
> +static inline int standard_target_verdict(const struct bpfilter_ipt_target *ipt_target)
> +{
> +	const struct bpfilter_ipt_standard_target *standard_target;
> +
> +	standard_target = (const struct bpfilter_ipt_standard_target *)ipt_target;
> +
> +	return standard_target->verdict;
> +}
> +
> +int init_target(struct context *ctx, const struct bpfilter_ipt_target *ipt_target,
> +		struct target *target);
> +
> +#endif // NET_BPFILTER_TARGET_H
> diff --git a/tools/testing/selftests/bpf/bpfilter/.gitignore b/tools/testing/selftests/bpf/bpfilter/.gitignore
> index 9250411fa7aa..7e077f506af1 100644
> --- a/tools/testing/selftests/bpf/bpfilter/.gitignore
> +++ b/tools/testing/selftests/bpf/bpfilter/.gitignore
> @@ -1,3 +1,4 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  test_map
>  test_match
> +test_target
> diff --git a/tools/testing/selftests/bpf/bpfilter/Makefile b/tools/testing/selftests/bpf/bpfilter/Makefile
> index 0ef156cdb198..a11775e8b5af 100644
> --- a/tools/testing/selftests/bpf/bpfilter/Makefile
> +++ b/tools/testing/selftests/bpf/bpfilter/Makefile
> @@ -10,15 +10,18 @@ CFLAGS += -Wall -g -pthread -I$(TOOLSINCDIR) -I$(APIDIR) -I$(BPFILTERSRCDIR)
>  
>  TEST_GEN_PROGS += test_map
>  TEST_GEN_PROGS += test_match
> +TEST_GEN_PROGS += test_target
>  
>  KSFT_KHDR_INSTALL := 1
>  
>  include ../../lib.mk
>  
>  BPFILTER_MATCH_SRCS := $(BPFILTERSRCDIR)/match.c $(BPFILTERSRCDIR)/xt_udp.c
> +BPFILTER_TARGET_SRCS := $(BPFILTERSRCDIR)/target.c
>  
>  BPFILTER_COMMON_SRCS := $(BPFILTERSRCDIR)/map-common.c $(BPFILTERSRCDIR)/context.c
> -BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS)
> +BPFILTER_COMMON_SRCS += $(BPFILTER_MATCH_SRCS) $(BPFILTER_TARGET_SRCS)
>  
>  $(OUTPUT)/test_map: test_map.c $(BPFILTERSRCDIR)/map-common.c
> -$(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS) $(BPFILTER_MATCH_SRCS)
> +$(OUTPUT)/test_match: test_match.c $(BPFILTER_COMMON_SRCS)
> +$(OUTPUT)/test_target: test_target.c $(BPFILTER_COMMON_SRCS)
> diff --git a/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> new file mode 100644
> index 000000000000..d82ff86f280e
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpfilter/bpfilter_util.h
> @@ -0,0 +1,31 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef BPFILTER_UTIL_H
> +#define BPFILTER_UTIL_H
> +
> +#include <linux/bpfilter.h>
> +#include <linux/netfilter/x_tables.h>
> +
> +#include <stdio.h>
> +
> +static inline void init_standard_target(struct xt_standard_target *ipt_target, int revision,
> +					int verdict)
> +{
> +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
> +		 BPFILTER_STANDARD_TARGET);
> +	ipt_target->target.u.user.revision = revision;
> +	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
> +	ipt_target->verdict = verdict;
> +}
> +
> +static inline void init_error_target(struct xt_error_target *ipt_target, int revision,
> +				     const char *error_name)
> +{
> +	snprintf(ipt_target->target.u.user.name, sizeof(ipt_target->target.u.user.name), "%s",
> +		 BPFILTER_ERROR_TARGET);
> +	ipt_target->target.u.user.revision = revision;
> +	ipt_target->target.u.user.target_size = sizeof(*ipt_target);
> +	snprintf(ipt_target->errorname, sizeof(ipt_target->errorname), "%s", error_name);
> +}
> +
> +#endif // BPFILTER_UTIL_H
> diff --git a/tools/testing/selftests/bpf/bpfilter/test_target.c b/tools/testing/selftests/bpf/bpfilter/test_target.c
> new file mode 100644
> index 000000000000..6765497b53c4
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/bpfilter/test_target.c
> @@ -0,0 +1,85 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define _GNU_SOURCE
> +
> +#include "context.h"
> +#include "target.h"
> +
> +#include <linux/bpfilter.h>
> +#include <linux/err.h>
> +
> +#include <linux/netfilter/x_tables.h>
> +#include <linux/netfilter_ipv4/ip_tables.h>
> +
> +#include "../../kselftest_harness.h"
> +
> +#include "bpfilter_util.h"
> +
> +FIXTURE(test_standard_target)
> +{
> +	struct context ctx;
> +	struct xt_standard_target ipt_target;
> +	struct target target;
> +};
> +
> +FIXTURE_VARIANT(test_standard_target)
> +{
> +	int verdict;
> +};
> +
> +FIXTURE_VARIANT_ADD(test_standard_target, accept) {
> +	.verdict = -BPFILTER_NF_ACCEPT - 1,
> +};
> +
> +FIXTURE_VARIANT_ADD(test_standard_target, drop) {
> +	.verdict = -BPFILTER_NF_DROP - 1,
> +};
> +
> +FIXTURE_SETUP(test_standard_target)
> +{
> +	ASSERT_EQ(0, create_context(&self->ctx));
> +	self->ctx.log_file = stderr;
> +
> +	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
> +	init_standard_target(&self->ipt_target, 0, variant->verdict);
> +}
> +
> +FIXTURE_TEARDOWN(test_standard_target)
> +{
> +	free_context(&self->ctx);
> +}
> +
> +TEST_F(test_standard_target, init)
> +{
> +	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
> +				 &self->target));
> +}
> +
> +FIXTURE(test_error_target)
> +{
> +	struct context ctx;
> +	struct xt_error_target ipt_target;
> +	struct target target;
> +};
> +
> +FIXTURE_SETUP(test_error_target)
> +{
> +	ASSERT_EQ(0, create_context(&self->ctx));
> +	self->ctx.log_file = stderr;
> +
> +	memset(&self->ipt_target, 0, sizeof(self->ipt_target));
> +	init_error_target(&self->ipt_target, 0, "x");
> +}
> +
> +FIXTURE_TEARDOWN(test_error_target)
> +{
> +	free_context(&self->ctx);
> +}
> +
> +TEST_F(test_error_target, init)
> +{
> +	ASSERT_EQ(0, init_target(&self->ctx, (const struct bpfilter_ipt_target *)&self->ipt_target,
> +				 &self->target));
> +}
> +
> +TEST_HARNESS_MAIN
> -- 
> 2.25.1
> 

-- 

Dmitrii Banshchikov
