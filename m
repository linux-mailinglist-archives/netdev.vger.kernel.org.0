Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EB4524CCD2
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 06:37:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgHUEhB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 00:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725270AbgHUEhA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 00:37:00 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20188C061385
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 21:37:00 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id s15so413662pgc.8
        for <netdev@vger.kernel.org>; Thu, 20 Aug 2020 21:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=//qldumoROV73xs7/nhZn823NZh16aGu8UHNR0UDS/U=;
        b=YleiaW5L9U3N3eWVnEMJURalZhgoKI4MmTvqJgrdotgT+8HVW8kt1KucMOV3r4zSXZ
         dQpqXQizIPIzU1bq9Wzo5z/74p2DqmPo+PT2PqUFVPg7zPxhccBH7qOuRYhvEKebqCrE
         jI7V+8ngItl0wfYaVQ25evtAEpr+/msX516xf/gXoEJU1ctbXqbM+QP1N6w4uc08oykV
         gSL1NcJfBRa/nvnLV4plhch8Md/zIjchqOLx86PXtc9HPPLA+ngJKj8ufKF1l2C35vyW
         6mQYWvp+dHmXxJ31lAMqPP6RFaSxMXTZ9Mi+z2Nf5cWsq5Iwelit53ffwgI5ciL2tEn0
         ihZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=//qldumoROV73xs7/nhZn823NZh16aGu8UHNR0UDS/U=;
        b=iNwtBFum8qE/gcuqhQqAsvF/oF7unDvRwmv5S9inazjLyRDPuPeSv7GG02Lzm+oBTn
         ViDMWcuSAm58kZcllYwn9FPEI3D6SqBB8fGkuGPxP6zKQaAl8nnPM60aVwFjPvI8ippP
         gEyPjUabFTBAs4fepIICjMdF6NzXjhNnGjAiIu0QbRP65zHwjK8bQZX8bgZgIg9yzzF9
         5UuxqURCTZhfW4F/KqkrZshEflcYyNqs/1nKMoFbIJAQCJxJdyoACkL4IwgYR1NRojSI
         pCXSnup+eEMeMB32pnYBUivmDgpimOSTHR1wqZcNhC4ufcptZIhjdahXvkCnUVRONIQ2
         v8Pw==
X-Gm-Message-State: AOAM530f7p8GgUx5C8BT8J/YAjljZGkacSMLT4J26HlezKvqNkpw709f
        X4gRl1yGKIisZsxG7BkGbo0uVw==
X-Google-Smtp-Source: ABdhPJwLz9BiTRQ1/O75rCnH3PHeAbMHIk1O/MInWRmOkfO3ZMuWmgV8lwXTVdaQdXjyxxoCbverfw==
X-Received: by 2002:a63:615:: with SMTP id 21mr1024635pgg.383.1597984619427;
        Thu, 20 Aug 2020 21:36:59 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id x18sm747719pfc.93.2020.08.20.21.36.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Aug 2020 21:36:58 -0700 (PDT)
Date:   Thu, 20 Aug 2020 21:36:49 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 net-next] iplink: add support for protodown
 reason
Message-ID: <20200820213649.7cd6aa3f@hermes.lan>
In-Reply-To: <20200821035202.15612-1-roopa@cumulusnetworks.com>
References: <20200821035202.15612-1-roopa@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 20 Aug 2020 20:52:02 -0700
Roopa Prabhu <roopa@cumulusnetworks.com> wrote:

> +	if (tb[IFLA_PROTO_DOWN]) {
> +		if (rta_getattr_u8(tb[IFLA_PROTO_DOWN]))
> +			print_bool(PRINT_ANY,
> +				   "proto_down", " protodown on ", true);

In general my preference is to use print_null() for presence flags.
Otherwise you have to handle the false case in JSON as a special case.
