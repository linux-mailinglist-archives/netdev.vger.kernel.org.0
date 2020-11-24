Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAE452C352B
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726718AbgKXX7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:59:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725868AbgKXX7L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Nov 2020 18:59:11 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9991FC0613D6;
        Tue, 24 Nov 2020 15:59:11 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 18so146594pli.13;
        Tue, 24 Nov 2020 15:59:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=nS9jd/mrs9MANJ2dhJ0iSNpa7XNy6i71AQudliWRJZs=;
        b=LExSxRx8TVfjgyGXal3rtgrWM44StwuPTNQiCVcmURvHxBm40B70wdMMcbm37X5pPt
         43OCNOmxjMPIk8lGxrw8rbt+sdCjGkoRbOxnwuWdgs0ER64dijCQDUGS9E0EONM2eQQg
         hF1Iz/5IvfG2nqzBb89iGfwtjLT2MS2ije71MC/FM8voq4swAhbg53RsUPH/eE0GYCQ0
         nxpFK8o/Ab6+zTeByqjMNQDtZ1yeI8OAnECWgvoUxdD0bqZlF4jLVpFw6LDSqabd6bL6
         y5HlYHSiipkdBycN0IErhjb98BQPVIrWMBjAIYXMNaFR4nZLkl4q9w+tHRbp465DXikt
         1XlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=nS9jd/mrs9MANJ2dhJ0iSNpa7XNy6i71AQudliWRJZs=;
        b=ccprlBdBpUvR89ya7f34E9Hd6DjyQC9jMbI0lylb/PdulEUUO+EP9jiw6SuSYcZrXi
         q0Z/zrM5SsmV6Qh4bBsUmj8JbDV8bpgtFIwC+UCodh4aqw2atdLzjWEqhEy5klLL4HI0
         LEBkvJrtAydQUjiPTfRiBfZd84QtxL2+jKOt3cQ/PgHWu1Anl9K0J1IAt9sOOsSXogYx
         yflPPmzvKilBQqYiy4cKPxgDoinnBQURRgTDRm8+6rPHenAkDUq+9tbDLkwThLLDuvr8
         9lB6O/y0O/UnfYryNlhUAcNNZYpJeAu+Pqpr32sLYL52a5smvFDoPa7hbwR0ojE3GdCT
         ZnoA==
X-Gm-Message-State: AOAM531yJczw/W/AiroJTUuwmynQ9c8Yfgmx1mgM5vXjVCejXO//N2UU
        lMyPInU+uH2SxYmyBCSjLTdCZc6o4CQ=
X-Google-Smtp-Source: ABdhPJxswtE7pW/hB1P2nB8d4Bmmr58dbtRs53uE9Fo26gn6rry66Dxb3se2Vr8aUR/XK9wzLHI4bg==
X-Received: by 2002:a17:902:9a84:b029:d9:d5ad:a669 with SMTP id w4-20020a1709029a84b02900d9d5ada669mr783347plp.53.1606262351169;
        Tue, 24 Nov 2020 15:59:11 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id f18sm136532pfa.167.2020.11.24.15.59.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2020 15:59:10 -0800 (PST)
Date:   Tue, 24 Nov 2020 15:59:08 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     min.li.xe@renesas.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net] ptp: clockmatrix: bug fix for idtcm_strverscmp
Message-ID: <20201124235908.GA28743@hoboy.vegasvil.org>
References: <1606233686-22785-1-git-send-email-min.li.xe@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1606233686-22785-1-git-send-email-min.li.xe@renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 11:01:26AM -0500, min.li.xe@renesas.com wrote:
> From: Min Li <min.li.xe@renesas.com>
> 
> Feed kstrtou8 with NULL terminated string.
> 
> Changes since v1:
> -Use sscanf to get rid of adhoc string parse.

This is much nicer.  Small issue remains...

> +	u8 ver1[3], ver2[3];
> +	int i;
> +
> +	if (sscanf(version1, "%hhu.%hhu.%hhu",
> +		   &ver1[0], &ver1[1], &ver1[2]) < 0)
> +		return -1;

The sscanf function returns the number of scanned items, and so you
should check that it returns 3 (three).

> +	if (sscanf(version2, "%hhu.%hhu.%hhu",
> +		   &ver2[0], &ver2[1], &ver2[2]) < 0)
> +		return -1;

Same here.

Thanks,
Richard
