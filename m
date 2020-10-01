Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43A727F916
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 07:35:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730646AbgJAFfG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 01:35:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730498AbgJAFfF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Oct 2020 01:35:05 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80012C061755;
        Wed, 30 Sep 2020 22:35:05 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id z19so3411000pfn.8;
        Wed, 30 Sep 2020 22:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=DfUtsVY5uGKctGL+S7ta06B1XiFGlOXfUbyJ3vzZxWk=;
        b=dPax8AlWgJfpD6NpIQ/2Weyv7IJyXz21M/jOUl2iLukssIIlMt5hb3Nsvt7gqczT7l
         DZpFBSQJ4WE4tOU9rnygNl3mW/NAPJF3AnDoiUhsLcWr2DxaHGQ4wBiqQLXqUHuG2Yhu
         cp4hmuLx2F7OmaC2jZ/RuWqKEI8Rik7kkfWEnH3G61cf2x4lDVBs93YbStuGHLuot0+z
         pzisJ592GbJ7ml/Et/tTw3SGfHdcvX3eaG1E21tfstRqIe1gVUv0oIp6NenGSmcrNmjU
         CSfpZj67lFw4bbkJ0a8rStet1a1FkFk3+HsL4K2T0d/aN285C3EShlxpOaDVO8CXrn/i
         cqMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=DfUtsVY5uGKctGL+S7ta06B1XiFGlOXfUbyJ3vzZxWk=;
        b=G2Fm5f2WblvfnUJRK8J0S6MrKbcmzbxLmg6U4UtfeGncDGCgaagkACqe2cyJ1n/e3/
         3SwHdc+8lyBOIf2kt6Vb0dz2wjXqmZD7Q2lbrKv8Cv/NlPwFUPVkYoi9XIlFtFFRF9yW
         ZhdqzM2KRVOu5M//8PGn5lrOJfnahdvXRwCOxHkgjNLH8sG1YxUWAgoj06DaMVXl/cHB
         7LSsdDNYmvKJ1Qsmpbqve5kHWnXFCLQlePyxlnP4MQgCUeHynKzaXzA5osoYhReoiN5z
         5ISBjoVOjTO/g0VbTyXNivY4Yhc03N2TDSjtJP87/lS6iqi1zquAUzxLwlqTQyGY+uUp
         eMGw==
X-Gm-Message-State: AOAM531FtWjmDTK8gtlWFQ6jdXfnsOehz+Rz3KC5k95RyvevjnVPaX/g
        RSpj6BAw/kyuxaogwJeSsqk=
X-Google-Smtp-Source: ABdhPJzgcZ2xqXJkPysWdKKM2mhlRCFHR9ly/BiCyqOOkx2p0WKgEOMaOetFZ6HIMgT+5/W3fHQgSQ==
X-Received: by 2002:a63:a70d:: with SMTP id d13mr4774413pgf.65.1601530505067;
        Wed, 30 Sep 2020 22:35:05 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:76d9])
        by smtp.gmail.com with ESMTPSA id e14sm3976138pgu.47.2020.09.30.22.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 22:35:04 -0700 (PDT)
Date:   Wed, 30 Sep 2020 22:35:01 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     bimmy.pujari@intel.com
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, mchehab@kernel.org,
        ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        maze@google.com, ashkan.nikravesh@intel.com,
        Daniel.A.Alvarez@intel.com
Subject: Re: [PATCH bpf-next v7 2/2] selftests/bpf: Selftest for real time
 helper
Message-ID: <20201001053501.mp6uqtan2bkhdgck@ast-mbp.dhcp.thefacebook.com>
References: <20201001020504.18151-1-bimmy.pujari@intel.com>
 <20201001020504.18151-2-bimmy.pujari@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201001020504.18151-2-bimmy.pujari@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 07:05:04PM -0700, bimmy.pujari@intel.com wrote:
> +SEC("realtime_helper")
> +int realtime_helper_test(struct __sk_buff *skb)
> +{
> +	unsigned long long *lasttime;
> +	unsigned long long curtime;
> +	int key = 0;
> +	int err = 0;
> +
> +	lasttime = bpf_map_lookup_elem(&time_map, &key);
> +	if (!lasttime)
> +		goto err;
> +
> +	curtime = bpf_ktime_get_real_ns();
> +	if (curtime <= *lasttime) {
> +		err = 1;
> +		goto err;
> +	}
> +	*lasttime = curtime;

so the test is doing exactly what comment in patch 1 is saying not to do.
I'm sorry but Andrii's comments are correct. If the authors of the patch
cannot make it right we should not add this helper to general audience.
Just because POSIX allows it it doesn't mean that it did the good choice.
