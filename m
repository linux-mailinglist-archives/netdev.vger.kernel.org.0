Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D20C0FB634
	for <lists+netdev@lfdr.de>; Wed, 13 Nov 2019 18:18:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728386AbfKMRSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Nov 2019 12:18:30 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:41154 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727558AbfKMRS3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Nov 2019 12:18:29 -0500
Received: by mail-pf1-f193.google.com with SMTP id p26so2083890pfq.8
        for <netdev@vger.kernel.org>; Wed, 13 Nov 2019 09:18:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=D/k4iQ7hTehadzmyhhYf2C+XkDkYrR8DBPNCHB0qNgo=;
        b=KrQvglyD8CcoX0LndIMpzVjdkLyLvp7jJFQQsCr3bf1NCJxskS9za5o8TeKtpx9Y9L
         HFsninho4mUyvs1zLFYei07JZej9XVU5AQX4ciVW0H7z+qkaiqrSv5e95WmAk/Sx50UT
         M7bdS907ONCjESOxpPlmvvq2BjokkHblyG07ZaFLDJBAmaSKBHGwFyIcHaOvTmoNZcL+
         PepFnvnoIKCSCZAXGiD+HFscDpED17lsgnwpzGKVaxbZk5C55jWA+VvUIlduAsBRXGf+
         X3bpiycVoVfW6hB1Or2tIyvJNnASGZ+lnvgnsXeA7DI/toNrqy48KEgrSPiR1yUGDAPC
         3cSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=D/k4iQ7hTehadzmyhhYf2C+XkDkYrR8DBPNCHB0qNgo=;
        b=j4eRTHfDAd6MGHEGA5GJytbR884SrBEPF3D1zFmJgdM10udogRudFxhQu6O5+M1TBw
         XSMDJDUenGn/tALe9zSvNt3uYdM12KXzbitfJGPZSqWYOU3XbA7Ky0AcDb7GTv6zdqFw
         LJnbUL9zp3rJtpn9m2V2iOAt6ruMjwZD/7byzPfp1NCAPb0MXMjBulzbXZKw4uYcHAaB
         yxTIE4oS4rMGvdOfkW9StvW1XvGkUWd0RIkdKSokuGqK2Emx0tilnpy9qxAzyx2MAcAb
         uyA0EeIGJ8P4aViqdHiL3B9PAFUvRBAoCWMUZTZiYcVym2bjGWipgzaDmjCE6LkfffDN
         JhTA==
X-Gm-Message-State: APjAAAW21W5ui3pF1nM4CT9hGwlTzDi68qFxPXqWLgWF1RSSBuqVDHKp
        PUmj5v1wWT3lttSBvAqj8oLqKQ==
X-Google-Smtp-Source: APXvYqyOaDOcawdS4d3MDiCKUOEUmvwu4BsJQFSD9QciPvCOh3/Z97npj+djjM5hWtHSJ17auZENXQ==
X-Received: by 2002:a17:90a:270f:: with SMTP id o15mr6548413pje.130.1573665508910;
        Wed, 13 Nov 2019 09:18:28 -0800 (PST)
Received: from shemminger-XPS-13-9360 (67-207-105-98.static.wiline.com. [67.207.105.98])
        by smtp.gmail.com with ESMTPSA id i2sm3885819pgt.34.2019.11.13.09.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Nov 2019 09:18:28 -0800 (PST)
Date:   Wed, 13 Nov 2019 09:18:25 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Roi Dayan <roid@mellanox.com>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Eli Britstein <elibr@mellanox.com>
Subject: Re: [PATCH iproute2 1/5] tc_util: introduce a function to print
 JSON/non-JSON masked numbers
Message-ID: <20191113091825.5cfba26e@shemminger-XPS-13-9360>
In-Reply-To: <20191113101245.182025-2-roid@mellanox.com>
References: <20191113101245.182025-1-roid@mellanox.com>
        <20191113101245.182025-2-roid@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 Nov 2019 12:12:41 +0200
Roi Dayan <roid@mellanox.com> wrote:

> +static void print_masked_type(__u32 type_max,
> +			      __u32 (*rta_getattr_type)(const struct rtattr *),
> +			      const char *name, struct rtattr *attr,
> +			      struct rtattr *mask_attr)
> +{
> +	SPRINT_BUF(namefrm);
> +	__u32 value, mask;
> +	SPRINT_BUF(out);
> +	size_t done;
> +
> +	if (attr) {

code is cleaner if you use short circuit return here. i.e

	if (!attr)
		return;

...
