Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3C83455778
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 20:58:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733041AbfFYS6O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 14:58:14 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42714 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730991AbfFYS6N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 14:58:13 -0400
Received: by mail-pl1-f193.google.com with SMTP id ay6so9283251plb.9
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 11:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=OTxHp8ZwwpRePYsOtjKpbEv8oKNUHQRiwNgYrFyeH3I=;
        b=diBr0wG89fVhmYbe3iCcPoJCwXD6br4ztWDNO6IomXW89ngyfVsDezKXE8S91J2OIb
         3Cr7Cv/BRsJOnZKK9F79V3vFp4+SIGpfMuG0O05J1EyqQzVLrZYVHkk926zpICR0+1AP
         MfWcPy8XoKNEnM+A7nRZv0fYsPBfiyjAly3xAMGjFAyBhHVoY99CRK7E4LNGilkjo9OJ
         M2rUWER/Rk26LZvn4up3seRBEMVToXuYDQ4eeKGmA+YgjR0E+x929Ov3+6AEXamhZ4Es
         I5F8KfqfIKgZ3fB1+IWvTBg4TovcrjWEibkZuoUlDmiE99nQUbHXRcPvzwqMfj2BOg52
         kYQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OTxHp8ZwwpRePYsOtjKpbEv8oKNUHQRiwNgYrFyeH3I=;
        b=g58z/y58+QJD/l9DSKqOHbUBCRFXNbA/dVbuI4/O6DVHcl7ivSWgXd4hqheP4qucuo
         i66vKKKVk3Stw7cuVE0AWqZgB9+K2MfzdxpkQKWPxM3pCVyfK0sTABfcyDIPaXnxQhWd
         yveD1fhI4QtdkH0dBV4UdsYTotiA9w6fJ+5fNSlAIEs35uHbnuNJF2xZz3+QoEx8eLil
         Nr2qpYc2ISygJle9u+41DdOuo5+NX45aNAeWw3vDTtZg1z2BNFicIYIrYDAQ6s9aKb5W
         yJoZjkxnsssxG3mkDSqpXgAozoR5TUJlojXU2Q4nfbB3n213iNr2Gr+TIDv/SePaA7Gd
         GZ5Q==
X-Gm-Message-State: APjAAAWcEJKJiGw0WRLdX3fwzwUdjSDRnExYDYrYURbpEC6Rxj94OxwC
        JqAbfUBoTHGXU/54OnGRPRwolA==
X-Google-Smtp-Source: APXvYqxYIb9VZQAzbs2w03Mjx0vu00KN3Euvbq829k0IXWzqtdS+9A+4VVDx5e0WJ7nh1aEUQiNkQw==
X-Received: by 2002:a17:902:2aa8:: with SMTP id j37mr215553plb.316.1561489092997;
        Tue, 25 Jun 2019 11:58:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id e20sm16109147pfi.35.2019.06.25.11.58.12
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 11:58:12 -0700 (PDT)
Date:   Tue, 25 Jun 2019 11:58:06 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        Aya Levin <ayal@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>
Subject: Re: [PATCH iproute2 1/2] devlink: fix format string warning for
 32bit targets
Message-ID: <20190625115806.01e29659@hermes.lan>
In-Reply-To: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
References: <016aabe2639668b4710b73157ea39e8f97f7d726.1561463345.git.baruch@tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Jun 2019 14:49:04 +0300
Baruch Siach <baruch@tkos.co.il> wrote:

> diff --git a/devlink/devlink.c b/devlink/devlink.c
> index 436935f88bda..b400fab17578 100644
> --- a/devlink/devlink.c
> +++ b/devlink/devlink.c
> @@ -1726,9 +1726,9 @@ static void pr_out_u64(struct dl *dl, const char *name, uint64_t val)
>  		jsonw_u64_field(dl->jw, name, val);
>  	} else {
>  		if (g_indent_newline)
> -			pr_out("%s %lu", name, val);
> +			pr_out("%s %llu", name, val);
>  		else
> -			pr_out(" %s %lu", name, val);
> +			pr_out(" %s %llu", name, val);

But on 64 bit target %llu expects unsigned long long which is 128bit.

The better way to fix this is to use:
#include <inttypes.h>

And the use the macro PRIu64
			pr_out(" %s %"PRIu64, name, val);

