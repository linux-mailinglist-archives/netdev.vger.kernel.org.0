Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 699A92E2ECD
	for <lists+netdev@lfdr.de>; Sat, 26 Dec 2020 18:50:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgLZRtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Dec 2020 12:49:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbgLZRtX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Dec 2020 12:49:23 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AA66C061757
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 09:48:43 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id t6so3673328plq.1
        for <netdev@vger.kernel.org>; Sat, 26 Dec 2020 09:48:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=foWfOdT04uv80XGPsJhiNm17byd6glhsFz3LEKspRTo=;
        b=WfOfQn969frH+2XAgoqF9e4MdbPoaDhUBWLZAeMtmn3oU48v6Gs+D8WAJWPpEvpzXO
         nFCrpukOU4r53Hss9NIgShvF7rDIdHVbcSlTjoFlo900Y4Zg/J43RfCLyjrICQZS7NyT
         PvrM0Smr7Syr/9rmOch2nZg/hCf7E/+TItZBCe3x0x66cqKwdfIBqcRDS7YN1c10x3xU
         8LcGmvD2twGwtT0VhAV+C0SgkNl980h+gA5qPlJfrYnR1vBYC9SBL592kxBtvnlHbcXA
         jEV9I66dL88sra8dp2c9NWH5HL40Sdcovs7Ck5xe0IfdQWnJqoqjPZTdWaG9jzUX0MX3
         CqZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=foWfOdT04uv80XGPsJhiNm17byd6glhsFz3LEKspRTo=;
        b=XGjpXf4Qr6K2r7UuiosgnfyZu7nYto7IS2NSEXelXUa3ZsfYZne4/Q6OcPHzLJwwJy
         H4CP/kGJjbpkhirgbhKB4DFwcvlVE3NEqQ9dSR53vEGq0SrqiRlKlWsCff3fzC+C04xH
         kCQJX5UVcAK9QS1KMwmfc6EZADzLACSWbzmPwDgT5EBJ0Z64ExUXa5UmGa5LWS0O8Y6g
         SFe8a/aJqqWmMR5LeZxJPiOJbnsabx4efsQlPTjg8BiRr60QdbgNGwHjOZ+RMU0vkwFZ
         oc4IJA7EAHge98GG7qCMjLoJnAcFoFizxjv4NGLas41NzRo1ucReANSnyCErZKNDDFgU
         pmkw==
X-Gm-Message-State: AOAM530TCET2lSS0gSDgNJVmpH1M4BtBqatAAz2IutAoqgqqSiC8RV7A
        b+khihMW8KIw+3KBcP3xdSysfn+M+nrHFg==
X-Google-Smtp-Source: ABdhPJwbGaiBbpek67Ai+NSo33SQHnfvIk3Mo9v6pt+Wh54Hh8aFEqjlCZLXgEPF/PFkYNPYN5vJSw==
X-Received: by 2002:a17:902:6a83:b029:dc:2a2c:6b91 with SMTP id n3-20020a1709026a83b02900dc2a2c6b91mr14864645plk.8.1609004923236;
        Sat, 26 Dec 2020 09:48:43 -0800 (PST)
Received: from hermes.local (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id a31sm33748528pgb.93.2020.12.26.09.48.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Dec 2020 09:48:42 -0800 (PST)
Date:   Sat, 26 Dec 2020 09:48:32 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Oliver Hartkopp <socketcan@hartkopp.net>
Cc:     netdev@vger.kernel.org, linux-can@vger.kernel.org
Subject: Re: [PATCH iproute2 5.11 2/2] iplink_can: fix format output for
 details with statistics
Message-ID: <20201226094832.2b12a20e@hermes.local>
In-Reply-To: <20201225191015.3584-2-socketcan@hartkopp.net>
References: <20201225191015.3584-1-socketcan@hartkopp.net>
        <20201225191015.3584-2-socketcan@hartkopp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 25 Dec 2020 20:10:15 +0100
Oliver Hartkopp <socketcan@hartkopp.net> wrote:

> @@ -315,10 +320,12 @@ static void can_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
>  			  "restart_ms",
>  			  "restart-ms %d ",
>  			  *restart_ms);
>  	}
>  
> +	fprintf(f, "\n        ");
> +
That will print in both JSON and non-JSON mode. You don't want to do that.
It also will break in single-line mode.

The iplink_can code has way too many if (is_json_context()) ...
which can lead to differences in output.

Ideally it should have no instances of "fprintf(f, ..."
