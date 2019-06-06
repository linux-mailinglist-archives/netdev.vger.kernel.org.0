Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E51C437D72
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 21:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbfFFTnw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 15:43:52 -0400
Received: from mail-pf1-f178.google.com ([209.85.210.178]:42036 "EHLO
        mail-pf1-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726723AbfFFTnw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 15:43:52 -0400
Received: by mail-pf1-f178.google.com with SMTP id q10so2114673pff.9
        for <netdev@vger.kernel.org>; Thu, 06 Jun 2019 12:43:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//V+YyK8z6M6avrR2A5RT+ZiuOLjbaenlwECx+48/Vs=;
        b=QTQ0ANmcMdDkeqdLhnfs1OCF4eCOz2zLxwxz4UTqEmR+K956OhpfB9K6EHjytG9U76
         Z3LK4Fvn5VdaqWE5nbNEvcPmn73+KG9RMOgd5hg2XFW/R8oGZScvR5K5jnNUMI4SIyvq
         swqK86mWxDvA4ptkysVKMWYfFb/+wT1XKQ1yRNBCF6DNZMlKL6bohbOSO8IVmhSv3X9r
         LzuUoHqAzsLy1ut2F0KdCJhQFlV2s5aMguk/0EGWvemSx/ExL+vNav894Sh84DtkMgC+
         0Szwup1lnw+6jyoXkJdFUT0RJGrXxxAGsse/Xy7M2wafOrDZqM0CoJ1XfhEc2FyEWle3
         xQRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//V+YyK8z6M6avrR2A5RT+ZiuOLjbaenlwECx+48/Vs=;
        b=krZmN3lZ2K0WL0bdrIjCuVPfF6FfuwzsTHLPpaMRryFL+aUvhY5PObFntYUs+Sb0Cn
         T+0oxOg9iDZrdOt/PFL8706FVhVON0dAKOZODkXldEE0AKn3qSGa2RUuWGQeq0OyvVPw
         ocOc0QdjWvcp54N9MPs2IDMkKtFroJwZar6OXDlXsp9sBOV5tfWfESpRuv2pL64eqIxY
         mkhyMueu6ztzVyEinDBbHeaoHrFdZZOQRwzWDK+7aY1C1a4ea74Im+CogjJHQshIWC0l
         Ibc7yfW2h3cf199hKWRxf6kldtO6ZInh8QYHNScyrbjWid2V5iIQBO3Wk+5mUAZZtJWd
         /HbQ==
X-Gm-Message-State: APjAAAWcAGjF67j2nobNJr40VorW1tj7YkcuCe5aHJkM8ZoWSUwA7Xo4
        IvCRfpBYa0TnU4kaeZdSHTBmYA==
X-Google-Smtp-Source: APXvYqyECNQNzbvhd8Ga+V9rChewPEOGG4a8vfRz2jBiGg3b1AwYf39OozX1RBmFK+s33RMegk1jbQ==
X-Received: by 2002:a63:225b:: with SMTP id t27mr199452pgm.25.1559850231227;
        Thu, 06 Jun 2019 12:43:51 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id y4sm2285487pgc.85.2019.06.06.12.43.50
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 06 Jun 2019 12:43:51 -0700 (PDT)
Date:   Thu, 6 Jun 2019 12:43:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Vedang Patel <vedang.patel@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, vinicius.gomes@intel.com,
        leandro.maciel.dorileo@intel.com, jakub.kicinski@netronome.com,
        m-karicheri2@ti.com
Subject: Re: [PATCH iproute2 net-next v1 3/6] taprio: Add support for
 enabling offload mode
Message-ID: <20190606124349.653454ab@hermes.lan>
In-Reply-To: <1559843541-12695-3-git-send-email-vedang.patel@intel.com>
References: <1559843541-12695-1-git-send-email-vedang.patel@intel.com>
        <1559843541-12695-3-git-send-email-vedang.patel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  6 Jun 2019 10:52:18 -0700
Vedang Patel <vedang.patel@intel.com> wrote:

> @@ -405,6 +420,7 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  	struct rtattr *tb[TCA_TAPRIO_ATTR_MAX + 1];
>  	struct tc_mqprio_qopt *qopt = 0;
>  	__s32 clockid = CLOCKID_INVALID;
> +	__u32 offload_flags = 0;
>  	int i;
>  
>  	if (opt == NULL)
> @@ -442,6 +458,11 @@ static int taprio_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
>  
>  	print_string(PRINT_ANY, "clockid", "clockid %s", get_clock_name(clockid));
>  
> +	if (tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS])
> +		offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);
> +
> +	print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);

I don't think offload flags should be  printed at all if not present.

Why not?
	if (tb[TCA_TAPRIO_ATTR_OFFLOLAD_FLAGS]) {
		__u32 offload_flags = rta_getattr_u32(tb[TCA_TAPRIO_ATTR_OFFLOAD_FLAGS]);

		print_uint(PRINT_ANY, "offload", " offload %x", offload_flags);
	}
