Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D07842A0AAC
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 17:05:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgJ3QFt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 12:05:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725844AbgJ3QFt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Oct 2020 12:05:49 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92825C0613CF
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:05:47 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id 13so5692073pfy.4
        for <netdev@vger.kernel.org>; Fri, 30 Oct 2020 09:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=5VBPmEGJVHt2vWWf6XSvMqRDoTtn5GPNasxtFSKZhmw=;
        b=VroOMPxAxBi4IE8/AB8r9tfyk+U4p3lrNnjs6lKUA7bdRqLe+A8LKE4rb1q4cwnYtI
         35VD9T9vSzMDJ2jwqq7yNGf+Cg5cTQQQN1z69RG6nppI1UUhhYqnqwrk7zpvSbTjmfo4
         6InanzsRvhYnm0DoEM1K5HpgHN6p9QCNiQKzM8NWyUtKDGYdOnfuWnLKPy3LMHHYR0UX
         Z2xAGNQ3prpHFs6sPlkxiUIj4ai4Sqgqa5yKdYPCd3im/u/b8hAQTFhwlw8zOq8JO0tU
         DAM6GSIqEDn2ACltsR7DqoBtIIS8/q4uG0LKIlv73xvSkHGXuaMhEvcilTunhoDCgK1u
         rsRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5VBPmEGJVHt2vWWf6XSvMqRDoTtn5GPNasxtFSKZhmw=;
        b=DJVkuYNjq4baWNR+kPDqYG876vfynecSVFw7h7LvLcmzSVuPUtwZ9AbZoH+fr4lo1i
         5jAarePYpQsL0ZP9o76qwIhGuXJtVwtbJIk6+k3PtGy3NrsBuGJM42aiMstvjaw90i0V
         9u3n2lK7bXDRxaR1/fkG/oXrDEZUZoF39O1jmWLSpOBDx2g/o6G4ABO2699r1QKznrWJ
         JtM8Nb/rOTg4lKWNwz2q4J0na1wj/v9NL1FHgddOu5HuqstNBAYlp2g4V8S30k3/Krev
         haKF57lpPlXIE6rb+oa02IcaxE7h/LgIQJ7tW4PFQc/guOgei3C2vYPu6s2ORRdOTxBp
         9+Cg==
X-Gm-Message-State: AOAM530qAyhGtxLO/ePJ/m99qE/G/54wQIeQUTd6XVHVY4TUutc1rGeb
        ZEZCfERbMpw6czUo3UyhUzGoQA==
X-Google-Smtp-Source: ABdhPJzYCWm5sWIbqQHJYTjvBUrAOgJEcY4zo6yMx3jP/7wgZtgXkmWiah6YuIKXzf8ImFNoPxQijA==
X-Received: by 2002:a65:4804:: with SMTP id h4mr2743409pgs.187.1604073947098;
        Fri, 30 Oct 2020 09:05:47 -0700 (PDT)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id v24sm3279389pjh.19.2020.10.30.09.05.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2020 09:05:46 -0700 (PDT)
Date:   Fri, 30 Oct 2020 09:05:32 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Petr Machata <me@pmachata.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        john.fastabend@gmail.com, jiri@nvidia.com, idosch@nvidia.com,
        Jakub Kicinski <kuba@kernel.org>,
        Roman Mashak <mrv@mojatatu.com>
Subject: Re: [PATCH iproute2-next v2 03/11] lib: utils: Add
 print_on_off_bool()
Message-ID: <20201030090532.33af6a3f@hermes.local>
In-Reply-To: <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
References: <cover.1604059429.git.me@pmachata.org>
        <5ed9e2e7cdf9326e8f7ec80f33f0f11eafc3a425.1604059429.git.me@pmachata.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 30 Oct 2020 13:29:50 +0100
Petr Machata <me@pmachata.org> wrote:

> +void print_on_off_bool(FILE *fp, const char *flag, bool val)
> +{
> +	if (is_json_context())
> +		print_bool(PRINT_JSON, flag, NULL, val);
> +	else
> +		fprintf(fp, "%s %s ", flag, val ? "on" : "off");
> +}

Please use print_string(PRINT_FP for non json case.
I am use fprintf(fp as indicator for code that has not been already
converted to JSON.

And passing the FILE *fp is also indication of old code.
Original iproute2 passed it around but it was always stdout.
