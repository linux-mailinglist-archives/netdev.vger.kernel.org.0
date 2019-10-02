Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02BFAC8BC3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 16:48:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727003AbfJBOsM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 10:48:12 -0400
Received: from mail-pl1-f182.google.com ([209.85.214.182]:42939 "EHLO
        mail-pl1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726435AbfJBOsM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 10:48:12 -0400
Received: by mail-pl1-f182.google.com with SMTP id e5so7137356pls.9
        for <netdev@vger.kernel.org>; Wed, 02 Oct 2019 07:48:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ijtgGh1XNc1E24h63VMxbkaf5HKY3GYoIcRh9sh3EKA=;
        b=Rue3IaQci/Cwa5WAm7cZ5cGv7h1aHimVni8m5M37cqLkyG/kRTMo8zBaTjMUvUBs+G
         V5YWkNGe4k4H8rXRHTPFD1aUdzAF6g/+58SaHaDEonwRbRe65ll3RB24+QyBCVE5klfI
         i3+kiGSurAN8NurHPgAmm2qozT9un5aKmCjFpldJmkk/K6hdbiqRTBM1yyWQOh6TJ43B
         kp3BPKimB1X09S3y4oeZwCAfF2nMRAdGRC0KUsyMKH7lbPLYD0ZN0poIuhMgNte2YTNu
         NWvZ94QT+N8tsZn0tmE95fWCW2ob8zGGJ9iMtyH9EbB045x+FGyq+cCzRewlNlDu4PDs
         f44w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ijtgGh1XNc1E24h63VMxbkaf5HKY3GYoIcRh9sh3EKA=;
        b=b7wKdY2sIon6+aF6klGPBZ08VXfresVLgwcZIgc3GrB122cWbxH8n+WQVKrjAtZWFP
         Cnobo+FAS3NW6dNQ+29AWQ30aHARlmxu9VCxM8ObGSf2rJQ78bFuYwvDa4Sg6vJceMHB
         jLDS/LCvjjO63pfEUTDdEI8jXwjBC6B/HSIlF1EAbCv8Rob4gd5WAl8JgZNQ/+aGSENK
         9NdJQlSSZjGdVyTQ4CwVJOZnPaYFBcdNdk2ygqfFAfZ2P1XeUO6YWwtlMPZSpoRg6SKG
         TLcInEDI994oPc+Lq3zOOPVUEBcsqdvlpTAC2/9KDPMRhbFQTeXAeoeRxIZ6S6mqQsib
         5h3A==
X-Gm-Message-State: APjAAAX0unkTSBplYzhJjbPxqCcVy+ZMDLzQ97msJ2Zt0oOW+fh0TlI8
        ll8Sbk5lB3x6p7t2FQIYU7Xllg==
X-Google-Smtp-Source: APXvYqwQbbT1Pj/YuSSwlQktcMCHNhCLRCBQ3BaunY8YExKNSLTiC4b0GYQyZ9RkCdfegnfLPwVfSw==
X-Received: by 2002:a17:902:a987:: with SMTP id bh7mr4010422plb.159.1570027691092;
        Wed, 02 Oct 2019 07:48:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id f18sm20330468pgf.58.2019.10.02.07.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Oct 2019 07:48:10 -0700 (PDT)
Date:   Wed, 2 Oct 2019 07:48:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org,
        Moshe Shemesh <moshe@mellanox.com>,
        Aya Levin <ayal@mellanox.com>, Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH V2 iproute2 1/3] devlink: Add helper for left
 justification print
Message-ID: <20191002074804.3ad4e5e2@hermes.lan>
In-Reply-To: <1570026916-27592-2-git-send-email-tariqt@mellanox.com>
References: <1570026916-27592-1-git-send-email-tariqt@mellanox.com>
        <1570026916-27592-2-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Oct 2019 17:35:14 +0300
Tariq Toukan <tariqt@mellanox.com> wrote:

>  static void pr_out_str(struct dl *dl, const char *name, const char *val)
>  {
> -	if (dl->json_output) {
> +	__pr_out_indent_newline(dl);
> +	if (dl->json_output)
>  		jsonw_string_field(dl->jw, name, val);
> -	} else {
> -		if (g_indent_newline)
> -			pr_out("%s %s", name, val);
> -		else
> -			pr_out(" %s %s", name, val);
> -	}
> +	else
> +		pr_out("%s %s", name, val)

Overall this looks like an improvement.

Why doesn't devlink already use existing json_print infrastructure?
