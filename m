Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EC44DCB9D
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 18:38:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388854AbfJRQfM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 12:35:12 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:44614 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726707AbfJRQfM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Oct 2019 12:35:12 -0400
Received: by mail-pl1-f182.google.com with SMTP id q15so3089515pll.11
        for <netdev@vger.kernel.org>; Fri, 18 Oct 2019 09:35:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YQL4XMz1lEfOlk7kh27nPgRjwKCMkhfYKc+ZnZglVPE=;
        b=fCvWIKid7oT6z+Io7L1sA/GaofCO0he6aLTJT6elSQu+nj7YP58EKOV6nvM1lgxyWN
         X+xEsTArPEuxe19Bdl6cHC3QZd9h4GkKK9Vv7P1cxgti1Tgpdd60vz7m1hvg5ntr5V+U
         izS8I02WClNXqjqqqHJnLYgA8mkaECpgwZ/2fMxKMRQ7ULxymlNgKrvVLONcsB6zOw6x
         ymD8gHuR+MOGnsDoXEIvHxajGMXFFNGVE3pG3nkq1tnspNkQas7OqJa5bO5taZps3Puk
         WuYz5a6+lu7AO0R1R3K5WvIWgah06eg/NhdOKfFJ4whf0g4ux9oQCcjmKpirYZDw6TUG
         /nSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YQL4XMz1lEfOlk7kh27nPgRjwKCMkhfYKc+ZnZglVPE=;
        b=Lc4roz1polmoU1Kc6BXmzlXde3f6ozHgt+Cm4gqkQf/O0jgdWchxWs//6pMFAk+zMV
         vH92fiqVTosa8ZdnTLcvPvEhEBN5z5usyhiESER8nzj3LjxGtraksJPxET7iv8g59pIR
         Sj+9manvXYoSUQTv5b4OVvkzCuWLMskCQKycnSvKGh7Lv1ifK2t4lY/iW9mGsk2GC9tP
         RZjyRQezaMqtI+vynBBsLL8D2Ikn82aNE/Q+eZ4n5yud69tniBhaA9cGESScwgvjGL0R
         kSr9ykcPvgev4GRK6viL4pW3MUruSS4g2FZ80Vigb+SRPDG8TQreko0zWszO1JrsUxfk
         Q/pA==
X-Gm-Message-State: APjAAAUfJZleDIl2aB3/+sqq6ou/URKyFrnBSUyAyadUoZtYRMxin+nq
        rZ7P4wIN1yXtza9nevLOW2FHbg==
X-Google-Smtp-Source: APXvYqwj1644m+Fit2dZsCztXDeRyITwgZF56DCwcNFyHH/MvJDGx0ln6LEoIDz3QyIvvpyv9n72eA==
X-Received: by 2002:a17:902:a511:: with SMTP id s17mr10618013plq.141.1571416510631;
        Fri, 18 Oct 2019 09:35:10 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id w25sm6356677pfi.60.2019.10.18.09.35.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 18 Oct 2019 09:35:10 -0700 (PDT)
Date:   Fri, 18 Oct 2019 09:35:09 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, andrew@lunn.ch, mlxsw@mellanox.com
Subject: Re: [patch net-next] devlink: add format requirement for devlink
 param names
Message-ID: <20191018093509.112af620@hermes.lan>
In-Reply-To: <20191018160726.18901-1-jiri@resnulli.us>
References: <20191018160726.18901-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Oct 2019 18:07:26 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> +static bool devlink_param_valid_name(const char *name)
> +{
> +	int len = strlen(name);
> +	int i;
> +
> +	/* Name can contain lowercase characters or digits.
> +	 * Underscores are also allowed, but not at the beginning
> +	 * or end of the name and not more than one in a row.
> +	 */
> +
> +	for (i = 0; i < len; i++) {
> +		if (islower(name[i]) || isdigit(name[i]))
> +			continue;
> +		if (name[i] != '_')
> +			return false;
> +		if (i == 0 || i + 1 == len)
> +			return false;
> +		if (name[i - 1] == '_')
> +			return false;
> +	}
> +	return true;
> +}

You might want to also impose a maximum length on name,
and not allow slash in name (if you ever plan to use sysfs).
