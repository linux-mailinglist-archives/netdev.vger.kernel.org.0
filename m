Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D39112B08C
	for <lists+netdev@lfdr.de>; Fri, 27 Dec 2019 03:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727015AbfL0CUq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Dec 2019 21:20:46 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:38227 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726115AbfL0CUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Dec 2019 21:20:46 -0500
Received: by mail-pj1-f67.google.com with SMTP id l35so4261264pje.3
        for <netdev@vger.kernel.org>; Thu, 26 Dec 2019 18:20:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0gplh9EerQkAOh5iOGpHL/yLPKqmSnETCKQQ/kk+y1E=;
        b=karTrEe/nDKPW3zs5TnRutbbMlAyCDVKLSgX8q1iWhOJf5MyRYSBIdvdUiXLX8QM3e
         SnROrqL/hZXLf8z1IWwV0A+gKG7rus43F744fczLG/k39yaFLi8iPdZzkRrhRlYlUE9T
         ucqTuvSUjJUH3YWnz2Gc/GpBjXIlFTVXTEr85bXuj0zYcDNLlzAJtPM1GUA0YlwbFzZA
         h7vSfE8Al6qm1qbYbYnnyWNrpuIFvLDPG5cTaBJC7LFOf1EAyJdAN9Vws4kmfvAuuiX4
         gt+IxrimDbHfwHStT8ZLsbm0iMoNyLKlRw7yqQy6rlIm+0HSPUOqolYkzhAXRDyB2n+c
         u6kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0gplh9EerQkAOh5iOGpHL/yLPKqmSnETCKQQ/kk+y1E=;
        b=grOrjWk/FDKYwcBwkSTwGhdFjerYwm5ApJevKkNaBhzvSMvbvzIRzGgvks/HHpaStu
         +5ddDhJBt3eR6xvAC5zoGEcKAaP3TkbrP6pOmrZtopI8/gM/W72YAt/PpzB3M8sg/apA
         jZcoAFVHSVuHYzQJtZ7QOT38LZxutrrxsr/b+5F835QTmoCBe1uVOdTv9zj4b5HOZrs8
         LwviQyVrJ/WT55Gr7723xLDCgH5LGYvh3zJB5Al9efT0iIB1X8kjTQ+iLb/FKqHTbWsJ
         +czfAdImNT8nXX6iUyfXR4/lV/1bvPYNuqEsLvnGGGsS3U3UTx8c04DIS7fzzp+HcWjw
         OvtQ==
X-Gm-Message-State: APjAAAUMxB9R2zZyxtemcHzSxN+NecELYqZAsAPDgYF4tx/eHRMp493B
        Cobr4ENKdLjvzi+077TEc5PIRA==
X-Google-Smtp-Source: APXvYqwQyKj8IYYRhzFT2jeS9lHvIQ2d4MKaK4iBg1JGSsAJGy2iyrwLPvhVICMdz7koOeaXwFoz/w==
X-Received: by 2002:a17:902:700b:: with SMTP id y11mr50410945plk.304.1577413245428;
        Thu, 26 Dec 2019 18:20:45 -0800 (PST)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id j18sm35613847pgk.1.2019.12.26.18.20.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Dec 2019 18:20:45 -0800 (PST)
Date:   Thu, 26 Dec 2019 18:20:42 -0800
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Andy Roulin <aroulin@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andy@greyhouse.net
Subject: Re: [PATCH net-next v2] bonding: rename AD_STATE_* to LACP_STATE_*
Message-ID: <20191226182042.3ca9cd94@hermes.lan>
In-Reply-To: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
References: <1577367717-3971-1-git-send-email-aroulin@cumulusnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 26 Dec 2019 05:41:57 -0800
Andy Roulin <aroulin@cumulusnetworks.com> wrote:

> diff --git a/include/uapi/linux/if_bonding.h b/include/uapi/linux/if_bonding.h
> index 6829213a54c5..45f3750aa861 100644
> --- a/include/uapi/linux/if_bonding.h
> +++ b/include/uapi/linux/if_bonding.h
> @@ -96,14 +96,14 @@
>  #define BOND_XMIT_POLICY_ENCAP34	4 /* encapsulated layer 3+4 */
>  
>  /* 802.3ad port state definitions (43.4.2.2 in the 802.3ad standard) */
> -#define AD_STATE_LACP_ACTIVITY   0x1
> -#define AD_STATE_LACP_TIMEOUT    0x2
> -#define AD_STATE_AGGREGATION     0x4
> -#define AD_STATE_SYNCHRONIZATION 0x8
> -#define AD_STATE_COLLECTING      0x10
> -#define AD_STATE_DISTRIBUTING    0x20
> -#define AD_STATE_DEFAULTED       0x40
> -#define AD_STATE_EXPIRED         0x80
> +#define LACP_STATE_LACP_ACTIVITY   0x1
> +#define LACP_STATE_LACP_TIMEOUT    0x2
> +#define LACP_STATE_AGGREGATION     0x4
> +#define LACP_STATE_SYNCHRONIZATION 0x8
> +#define LACP_STATE_COLLECTING      0x10
> +#define LACP_STATE_DISTRIBUTING    0x20
> +#define LACP_STATE_DEFAULTED       0x40
> +#define LACP_STATE_EXPIRED         0x80

You can't change definitions of headers in userspace api
without breaking compatibility.
