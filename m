Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54D6BCD224
	for <lists+netdev@lfdr.de>; Sun,  6 Oct 2019 15:25:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbfJFNZx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Oct 2019 09:25:53 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:35012 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbfJFNZx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Oct 2019 09:25:53 -0400
Received: by mail-ed1-f66.google.com with SMTP id v8so9996097eds.2
        for <netdev@vger.kernel.org>; Sun, 06 Oct 2019 06:25:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6XU/Fyht5dqKF8sYt3rQ5h7V6a8ZmKEgncX/K+N4IgE=;
        b=A/daRYWwz7ilJ0iXuI1XZGrQqmk7Vypl7GHc2jxSa5Ch0ZP5UPVHmwhdyEC5nHQuez
         o9J/WibbP7DSiKsmnVI9z1QMwb5ppLE9+F3w9EtmbLBhy7ARMG5CqI9dmLWBvrwph+uu
         /ErsWKE/9iTXbrhkBKQGNoM9QgdxxugOUw7+QE+loaPzE9Vi38NTP76TbEKIctkdRI4m
         nfhcI4RVouu/dmZrP1ytQV4j13j89j7ZR2DMVCxpLjIE3ScPq/5yuoev32SDS9oWq7UK
         JZzZD68C5biEt/o96OFPo8nPt9pAQnz6ewAfoxwEDnzhqBgjzm6GNyPDWyjCQv4cq+ka
         GAIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6XU/Fyht5dqKF8sYt3rQ5h7V6a8ZmKEgncX/K+N4IgE=;
        b=Im9TGPpBjFWu6K3a3udTKNS51zMyyR7tPEuuCIWM6AjKx9CHLBjZ0jzGL6GSfQzZ/g
         GipQWEHb5uqa0JALtU2NLC0rDPcHutRNz8DnXg9WABxlHTCnJutcv5u99NVP5uOig4Rm
         6eVE1scOYnyRdbMddCCMQBFOrX0cLyVl3WpQrkeSeBg6s1o+tlxIeW/+p3MiYeOSgtUu
         mJRqTsh9TpKkbht7HYp9EedRlbclawqJYT0pbMUvv+nX9g+uOAwqt6zeuQ8P1zv1jQ4d
         DsTLHf8j2I8A0cZn5mNlN82g3U73VuGF4tPaZMYNlDac/ITA3IzRD2TMlHHPtMh6Zm/Q
         YsdQ==
X-Gm-Message-State: APjAAAU0DLoeWoNYetoPQddgGmTWDF4YE5l40QuzLr2wz55UbHYxwWyS
        4jdxsNoKAQR+NqEz0YjSoYS2dA==
X-Google-Smtp-Source: APXvYqzTQ92YfXIZ023S60iYQcR7xRSTlUJFmVsWvKiCYyjbjpPo3WBHhna5Qen3UkSNafcDnoiXBQ==
X-Received: by 2002:a17:906:a2c9:: with SMTP id by9mr19757566ejb.29.1570368350310;
        Sun, 06 Oct 2019 06:25:50 -0700 (PDT)
Received: from netronome.com (penelope-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:c685:8ff:fe7c:9971])
        by smtp.gmail.com with ESMTPSA id j9sm2671415edt.15.2019.10.06.06.25.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sun, 06 Oct 2019 06:25:49 -0700 (PDT)
Date:   Sun, 6 Oct 2019 15:25:48 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Tom Herbert <tom@herbertland.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        Tom Herbert <tom@quantonium.net>
Subject: Re: [PATCH v5 net-next 5/7] ip6tlvs: Add TX parameters
Message-ID: <20191006132547.stdd4hhj3y4dckqf@netronome.com>
References: <1570139884-20183-1-git-send-email-tom@herbertland.com>
 <1570139884-20183-6-git-send-email-tom@herbertland.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570139884-20183-6-git-send-email-tom@herbertland.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 02:58:02PM -0700, Tom Herbert wrote:
> From: Tom Herbert <tom@quantonium.net>
> 
> Define a number of transmit parameters for TLV Parameter table
> definitions. These will be used for validating TLVs that are set
> on a socket.
> 
> Signed-off-by: Tom Herbert <tom@herbertland.com>
> ---
>  include/net/ipeh.h         | 18 ++++++++++++++++
>  include/uapi/linux/ipeh.h  |  8 +++++++
>  net/ipv6/exthdrs_common.c  | 53 +++++++++++++++++++++++++++++++++++++++++++++-
>  net/ipv6/exthdrs_options.c | 45 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 123 insertions(+), 1 deletion(-)
> 
> diff --git a/include/net/ipeh.h b/include/net/ipeh.h
> index aaa2910..de6d9d0 100644
> --- a/include/net/ipeh.h
> +++ b/include/net/ipeh.h

...

> @@ -54,6 +65,13 @@ struct tlv_param_table {
>  
>  extern struct tlv_param_table ipv6_tlv_param_table;
>  
> +/* Preferred TLV ordering for HBH and Dest options (placed by increasing order)
> + */
> +#define IPEH_TLV_PREF_ORDER_HAO			10
> +#define IPEH_TLV_PREF_ORDER_ROUTERALERT		20
> +#define IPEH_TLV_PREF_ORDER_JUMBO		30
> +#define IPEH_TLV_PREF_ORDER_CALIPSO		40
> +

Hi Tom,

Could you expand on why thse values were chosen?

I can see that this patch implements a specific use of
the 255 indexes available. But its not at all clear to me that
this use fits expected use-cases (because I don't know what they are).

...
