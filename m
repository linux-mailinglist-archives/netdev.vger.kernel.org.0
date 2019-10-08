Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07E0CFE49
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 18:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbfJHQAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 12:00:12 -0400
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45800 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725908AbfJHQAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 12:00:12 -0400
Received: by mail-pf1-f196.google.com with SMTP id y72so10983040pfb.12
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 09:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kmaleHcADfeNrgrIaJqgXz0MuPWrRbnV500Be6ZH/08=;
        b=mAkplfczFRshafPkjTJuZY9AcXOnJudyuwfQU8Ae0gmH2EElbI1vWdoBo7EJaWiqVy
         89LUG8suoatmhE1+91n8jVsaYgq+ZrgMgwcx22StjCIPiykWnqgyS5oweNxYqu6f3fFH
         SJg3uIxNvdN5PHr0rwQUoVbWKRQkP/FqeO+ND74Snv5QeMhEcurhMiyTQAEN5PhKp+4w
         4MtyGoaDaQ0P7yqfNZoXPh2Daw/5Icw5ZKfUL3ugFodCykQjZt4d7V8GpN9W24XBT5PQ
         eOWMdP2x4P6ICQCcwkq9rTyIUvzV66ZdDNlRUXbOMKhaE61Q824AhBblVXH7ERImDMc5
         T//g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kmaleHcADfeNrgrIaJqgXz0MuPWrRbnV500Be6ZH/08=;
        b=OLnxK1V0EIhoiZYET2rOhA1rrkRi5/br4VfvcvxI1uSralJEjY/ohrisq+zktUohrX
         4EdygfwBi0HkXA0rQJ9OQXo9OSh5DllhwP/x6BCM3e3MNzNOo3aNLGZyFSjrHBvhDr0+
         BhYyeac0eN4RRe+8TyxNDQVcp10iV+ScIzsht/GxcH7ruEyELF8D/O5Faa9IgGHV5YTT
         0RyM7YJPblBfz+o8BmNbhbhoWmei45gIaAnk56A40tKQAgvsPzPFRMN02xJgPel7xir3
         F+Sqb+1Jt1gDMmzQCsNv6uuXCjxI/buGKlGYjv/LypDx6yqq48juVIxl0mwFA26D1xF3
         n54A==
X-Gm-Message-State: APjAAAX11+CA5THESd7tyj0utBbx7FyjynsE8CIFT/j2Y5BAY2n0zNXO
        GRNl0iYZ7y0nyeOTpQSIFEsE6Q==
X-Google-Smtp-Source: APXvYqy4aODBZhgA2sdbIqJkNnxoieHEZmubQmgxuRcAKps9YmYCsRNpzokFcYM+IL46nTRJYRMuiQ==
X-Received: by 2002:a62:170b:: with SMTP id 11mr38470543pfx.243.1570550411411;
        Tue, 08 Oct 2019 09:00:11 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q33sm20023871pgm.50.2019.10.08.09.00.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 09:00:11 -0700 (PDT)
Date:   Tue, 8 Oct 2019 09:00:03 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Martin Varghese <martinvarghesenokia@gmail.com>
Cc:     netdev@vger.kernel.org, scott.drennan@nokia.com, jbenc@redhat.com,
        martin.varghese@nokia.com
Subject: Re: [PATCH iproute2] Bareudp device support
Message-ID: <20191008090003.59a347eb@hermes.lan>
In-Reply-To: <1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com>
References: <1570532361-15163-1-git-send-email-martinvarghesenokia@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 16:29:21 +0530
Martin Varghese <martinvarghesenokia@gmail.com> wrote:

Overall ok, but where is man page?

> +
> +	if (tb[IFLA_BAREUDP_PORT])
> +		print_uint(PRINT_ANY,
> +				"port",
> +				"dstport %u ",
> +				rta_getattr_be16(tb[IFLA_BAREUDP_PORT]));

nit. these can be combined to be less lines.

> +	if (tb[IFLA_BAREUDP_EXTMODE]) {
> +		print_bool(PRINT_ANY, "extmode", "extmode ", true);
> +		return;
> +	}

One of the unwritten rules of ip commands is that the show format
should match the command line arguments.  In this case extmode is
really a presence flag not a boolean. best to print that with
json null command.

Also why the short circuit return.
