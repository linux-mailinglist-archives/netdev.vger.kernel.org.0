Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E84EE12AD97
	for <lists+netdev@lfdr.de>; Thu, 26 Dec 2019 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbfLZREQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 12:04:16 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44109 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726450AbfLZREP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 12:04:15 -0500
Received: by mail-pf1-f195.google.com with SMTP id 195so12557828pfw.11
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 09:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XdP4iQaFsf97jEYFWbNH8hTfo9kmsSijDusmf1cV9G4=;
        b=YeJw2yv2rZDaUDBI8x34lFH6Pqoj8GzO0dZF0f9yy27ekONpeEx9iYpKQPFFivqYsM
         wDyLc+bGak8hoYjXfHWOSxQi+Mnuc/m+43mj/Ikrf/vwR6ScC5IRPxQEBVlaFHzV7I4N
         8p7D8lYn+a3z1rHfN4MF136Ize7yGVuznrIpxS7NUQhql5thEK9ExBY6qewnnFhFShI+
         zwrNY2z6thvbaJHZ94P9MB+iQUfGEaMfbo9Z6MAYE81CvVIX5+b64wgDUf8MqzC4K7S9
         EUEyuUgjG5oi5C7MpCzj+HqikZ2oI+31yelaELC9RfEHpJwOAJyZrVGDoT9aNfkJlBNg
         v3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XdP4iQaFsf97jEYFWbNH8hTfo9kmsSijDusmf1cV9G4=;
        b=XVS8ppiVYG4e2NkmXZ9hhtMf2JL0nhNMjVN8Un6hSYcLf31W3clcbUJ6Dq2tDyo3Yt
         IYeoyaA04eX7VGh2noL/Y3MtQOaBp5hsCOlxwG/CNgX34xio7T3RGNcUHFKeaXd45Irv
         XKOWbeuin1mncOlhEPTTgPVqNBEY9HHdRZV3qoMUE5iLTIqWQ4uQpqesrtfGSYfWEqw3
         efVPdBNX90NJCWbSOSeRjhK6SKBszvw7JfYTrvsys4blD3M1+o/zspKoW8Dc4ZvpQpmm
         9eX6yI87+GKHyZzuItjTOSKhVlvYEKyrhaXiQW5Gf4YlYg9MhHoH1tEomSKjSZM3WSbb
         h+Qw==
X-Gm-Message-State: APjAAAWH+k5MfFP4K2KU7Q0TsGoYi29JDJ27X+kMzwwj0Vvl3rZEcAZc
        8+p2KLJr90EAqB6tJHNojMG2eg==
X-Google-Smtp-Source: APXvYqyZ7qkdYnKRbbKhWU1NEsJGTgLAKIFcGs+eNddQDiDIqbQ8RR4KO0/zZzmL5pSQcaSLS3OmSQ==
X-Received: by 2002:a63:551a:: with SMTP id j26mr49080267pgb.370.1577379855236;
        Thu, 26 Dec 2019 09:04:15 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id z26sm33608987pgu.80.2019.12.26.09.04.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 09:04:15 -0800 (PST)
Date:   Thu, 26 Dec 2019 09:04:06 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Julien Fortin <julien@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        dsahern@gmail.com
Subject: Re: [PATCH iproute2-next] ip: ipneigh: json: print ndm_flags as
 boolean attributes
Message-ID: <20191226090406.00aebbcf@hermes.lan>
In-Reply-To: <20191226144415.50682-1-julien@cumulusnetworks.com>
References: <20191226144415.50682-1-julien@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 15:44:15 +0100
Julien Fortin <julien@cumulusnetworks.com> wrote:

> From: Julien Fortin <julien@cumulusnetworks.com>
> 
> Today the following attributes are printed as json "null" attributes
> NTF_ROUTER
> NTF_PROXY
> NTF_EXT_LEARNED
> NTF_OFFLOADED
> 
> $ ip -j neigh show
> [
>   {
>     "dst": "10.0.2.2",
>     "dev": "enp0s3",
>     "lladdr": "52:54:00:12:35:02",
>     "router": null,
>     "proxy": null,
>     "extern_learn": null,
>     "offload": null,
>     "state": [
>       "REACHABLE"
>     ]
>   }
> ]


No, this was intentional. Null is a standard method in JSON
to encode an option being present.
