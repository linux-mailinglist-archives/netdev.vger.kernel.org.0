Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40189438C9C
	for <lists+netdev@lfdr.de>; Mon, 25 Oct 2021 01:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231922AbhJXXtF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 19:49:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbhJXXtF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 24 Oct 2021 19:49:05 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A1DBC061745
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:46:44 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id n11so6692391plf.4
        for <netdev@vger.kernel.org>; Sun, 24 Oct 2021 16:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+Dz8E7RcqQqsc9fD5a+Hu1EI19CatqFVLpkpqCatrMc=;
        b=tduWdIWIv4vkabw8T3uzOvuRTBaUUOi30H5Oo7JVZMbC0s02s1y4ajch2ZExVa1biv
         JtcAXnI1h/iGgxXiAQKM3GJ8sYLeDAQVJYKuLQceRmaf5UyXTmni9VT0AWb+xar/ySCZ
         4yz6pncwNx+v9tHuvOKE5y6RpfVHXSebGbKqVP+9wlanES8GXFGIm3qnttG/XXEQjWhG
         zQdZJ8e4YRAHXd0/bo73g7Yz/0SAUzKH3g74iJ7npZT4rbdwN1QxBaiPysgSquSZsbjf
         vpvuask01UZN7xByt7r2iIlkNBfRStFpQ30aFsqUt06SgjvFGCTr3cuhJEOCUybQh4Hg
         utEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+Dz8E7RcqQqsc9fD5a+Hu1EI19CatqFVLpkpqCatrMc=;
        b=YwGnHpZVw4qPhtsT6F6xMSV4S9c1fyYyfj6D8m5KnF6BNoNtqw9mie2srG9eCsHUZ9
         hIBXxcP/FKEPai9O+hrRu5dVCdmO6Twz7Z5qmUp0qauMzBk3lgnrcbAbbpocJ4ejn3r9
         twz8Cs2AYEnWEAFHkyXie8Mr2OoYbfQssDdZfwMBZx29j32U7paTB6RVBJbtsKh+PtfJ
         8Hq+zrbRVdyS5oSI1srxKZc+Y99EB+sKRhvxqesnOZYODW4rv5dzja9d/804ehw5fpRG
         7hgbSpIHy98U87wE4jh429g5LaQ1kZNYY7cmeLM4gH+zpAUC5CHt628fl4yyV/p6B2e7
         KAyg==
X-Gm-Message-State: AOAM533ZASyqcb2ACNt94qUS4SfEOTlmcpAwt3Br7tD9kMz9lWvpvTek
        gk6L+lRG+QxIA2mm0bOoy+U3WQ==
X-Google-Smtp-Source: ABdhPJzY9lhMy3iEgNZ0PKlnNejj+3MzmjYOTm77np3a3cIe2i0ZemGYLwhioHAdbk9kKRR13pvCtA==
X-Received: by 2002:a17:90b:1646:: with SMTP id il6mr15981271pjb.129.1635119203739;
        Sun, 24 Oct 2021 16:46:43 -0700 (PDT)
Received: from hermes.local (204-195-33-123.wavecable.com. [204.195.33.123])
        by smtp.gmail.com with ESMTPSA id bx1sm4558514pjb.41.2021.10.24.16.46.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 Oct 2021 16:46:43 -0700 (PDT)
Date:   Sun, 24 Oct 2021 16:46:41 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     dsahern@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2-next] ip: add AMT support
Message-ID: <20211024164641.3e14e35d@hermes.local>
In-Reply-To: <20211023193611.11540-1-ap420073@gmail.com>
References: <20211023193611.11540-1-ap420073@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 23 Oct 2021 19:36:11 +0000
Taehee Yoo <ap420073@gmail.com> wrote:

> +	if (tb[IFLA_AMT_MODE] && RTA_PAYLOAD(tb[IFLA_AMT_MODE]) < sizeof(__u32))
> +		return;

What is this check here for? Is there a case where kernel returns
data without valid mode?

> +
> +	if (tb[IFLA_AMT_MODE]) {
> +		print_string(PRINT_ANY,
> +			     "mode",
> +			     "%s ",
> +			     modename[rta_getattr_u32(tb[IFLA_AMT_MODE])]);
> +	}
