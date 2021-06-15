Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF123A747E
	for <lists+netdev@lfdr.de>; Tue, 15 Jun 2021 04:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230332AbhFOC7I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Jun 2021 22:59:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhFOC7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Jun 2021 22:59:07 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E712C061574
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 19:57:04 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id i34so10245216pgl.9
        for <netdev@vger.kernel.org>; Mon, 14 Jun 2021 19:57:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=PIBUs0+8txOAViHScEthowcrmgSwaqzgJkOT6RfdKGw=;
        b=lW2YyQNvvP+Y6w5f3ew4gpH5w/M2rt13HqarsH5MXKipW0/gHNQVArIoicMJIcBgZl
         J/PIHG+QjnYhXEmVrrFqW90hN/MgMekJOwpmSNdQU42DkzL5nn7P39DmXyYvG9C2gOkX
         jEO9XfpHPWxf9mSq4GAIFKrGArCBjMi27Pe5sxmJxAxOBsU118iznuyHz+Ux2rXAbDeP
         6t1zdNetdu/+RpQ/dLQnZt6PWW+Arn8mKb8rtEMdC2BOOuvCHWN8IOful4+Cp0XrBaXh
         Eo1WMzcaT2ILLLD6f31CkjYjsj5R1cp580LPyPAB6K/k6VH+ROFUHLq07B7W1kczHEBl
         nfwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PIBUs0+8txOAViHScEthowcrmgSwaqzgJkOT6RfdKGw=;
        b=qmCUmvoRrLDZ5jdlyaTrXDfg57a2Tw4FFnjTv3BzjvZMfBAgafD0kZB3C/BXcaNJ4A
         fzDP/IyX1Bcgd+Nk6RCN/iVrGlFYHzFMebb2In5jIPIEqMhdiyaVhRmaWeJHSwMqJEyD
         rzstxRhtCL4v0QDWjp8t+n6RY03M6KFJQnq6EpT3koRxdrkPcJHbdo3W8jCuXYTtzSRH
         n2MGsfN+ExdaBcN4wLPzG76aE43gj3MIZIOZzVsa2Abpd1SdoRr2RWAXHRl0IjEBcyC7
         QXXZkxsmrl7JwuAHyCVRbr821+BqscmWyY2jiIyFfao68DPyr1yBAps72Do3aq4n6TUj
         xwWA==
X-Gm-Message-State: AOAM532/4R62+UMgk+WwWK6IDPGLpM06oX3jEOTyVPr6nAjVQq3EOrWO
        nqgE6NeP/A56VsrwKXxGjDoBQw==
X-Google-Smtp-Source: ABdhPJz+s2GT5CohFVvio9AOPNYYUtvbBctu6YAcX6EUGm3bPmbnSEiIXOPEWjYWSPkN+gOQ3ASVOg==
X-Received: by 2002:a63:2f05:: with SMTP id v5mr19844929pgv.449.1623725823694;
        Mon, 14 Jun 2021 19:57:03 -0700 (PDT)
Received: from hermes.local (76-14-218-44.or.wavecable.com. [76.14.218.44])
        by smtp.gmail.com with ESMTPSA id u2sm13375338pfg.67.2021.06.14.19.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Jun 2021 19:57:03 -0700 (PDT)
Date:   Mon, 14 Jun 2021 19:57:00 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [RFC 2/3] [RFC iproute2-next] tc: f_u32: Fix the ipv6 pretty
 printing.
Message-ID: <20210614195700.260c8933@hermes.local>
In-Reply-To: <20210608153309.4019-2-littlesmilingcloud@gmail.com>
References: <20210608153309.4019-1-littlesmilingcloud@gmail.com>
        <20210608153309.4019-2-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Jun 2021 18:33:08 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> -			fprintf(f, "\n  match IP protocol %d",
> +			return fprintf(f, "\n  match IP protocol %d",
>  				ntohl(key->val) >> 16);

Ok, but better yet, upgrade f_u32 to do proper JSON output.

> +			// The ipv6 pretty printing requires an additional call at the end.
> +			// Call the show_keys with the NULL value after call with last key.
> +			for (i = 0; i <= sel->nkeys; i++) {

iproute2 uses kernel style C so no C++ style comments please
