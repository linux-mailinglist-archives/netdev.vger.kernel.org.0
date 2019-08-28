Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90811A0C6D
	for <lists+netdev@lfdr.de>; Wed, 28 Aug 2019 23:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726837AbfH1Vdp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Aug 2019 17:33:45 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45045 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726764AbfH1Vdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Aug 2019 17:33:45 -0400
Received: by mail-pl1-f195.google.com with SMTP id t14so540392plr.11;
        Wed, 28 Aug 2019 14:33:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=H/T62WymqibAzBybIU6SUVM2xwVqngTN7XIUBl9RNJY=;
        b=DpZq1hI8hoSZMAIvIKWuAwAwDsAUnLgjeh2j+TjrB1SsTc7bDlHtwkcjGBHhMNrpSa
         0ftLnVhblEm8eYwLkQBwBv3aUiVC8sQddcMvkVg23Z7KYL3jSZQQ2LioBdjh1Nq6bzAR
         +iA510Cyusj+fk2PdO/X66G2VJ0wjvjPHRDEGFXP+KO+vQUVybYxqO2yL2jEbAH37ZTC
         WOHrrDl2m6dA709A5HmVbzUYh8JIoO6UX0WV2ibeM74U0uWG4ruseiRfaAUZOjqdBOGv
         LXP7E/Ewr1PsJEc1Y1HeAF28kYVODUsl5mN4S4be964aADo+LmtbPRjDcs0lqkE6AWa/
         c99Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=H/T62WymqibAzBybIU6SUVM2xwVqngTN7XIUBl9RNJY=;
        b=KLXjJSrEoTCxocFIpMDBHDLfHA6z5KIRGpUnfBHCn1UD0tZnw2b+5EkESLDJTI6YDO
         YT5DygK0uXrLyfZnUJslBj0EaFIIFzvtPf+OGozBUx9viuASRQmFvU6rUclte4NP7tZN
         qx45bNz4g7UVAi8FIaC3FuMGLHXQz2hUi80/9hL/VUB+kfN/MsnX08Eibiu0m5tTz0S6
         FsmzKbWFAowVsaoLRJ8owWHF5f0TzHgIrmEjgl8P8ifodNdgiyeKBwiuvLkasaAFMC7K
         FTW20CHmdtzcCvWZHNXEv2YHHjqv0x1eMm+czTctrGHdxrWookCRm/QyBcEvGM3gKoOo
         GZrg==
X-Gm-Message-State: APjAAAXzXmzPxG5ds9RkAPvuCHdI6LfXCprnblKcUi53cKLT/na1y1F6
        NWYl0L0lBTzEjPGy3b0R1HE=
X-Google-Smtp-Source: APXvYqxV8rh8RoFIsPi0EjsCE3QE6b/+zZAO0va1dz9OD5UGMEIr78PFAz9v9sUoSY1sncswXiSTeA==
X-Received: by 2002:a17:902:302:: with SMTP id 2mr6423212pld.149.1567028024344;
        Wed, 28 Aug 2019 14:33:44 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:180::5983])
        by smtp.gmail.com with ESMTPSA id j18sm334330pfh.70.2019.08.28.14.33.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Aug 2019 14:33:43 -0700 (PDT)
Date:   Wed, 28 Aug 2019 14:33:41 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     rdna@fb.com, bpf@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH bpf-next 01/10] bpf: introduce __MAX_BPF_PROG_TYPE and
 __MAX_BPF_MAP_TYPE enum values
Message-ID: <20190828213339.5qie42ulkhyso7i5@ast-mbp.dhcp.thefacebook.com>
References: <cover.1567024943.git.hex@fb.com>
 <43989d37be938b7d284028481e63df0a0471e29f.1567024943.git.hex@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43989d37be938b7d284028481e63df0a0471e29f.1567024943.git.hex@fb.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 02:03:04PM -0700, Julia Kartseva wrote:
> Similar to __MAX_BPF_ATTACH_TYPE identifying the number of elements in
> bpf_attach_type enum, add tailing enum values __MAX_BPF_PROG_TYPE
> and __MAX_BPF_MAP_TYPE to simplify e.g. iteration over enums values in
> the case when new values are added.
> 
> Signed-off-by: Julia Kartseva <hex@fb.com>
> ---
>  include/uapi/linux/bpf.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/include/uapi/linux/bpf.h b/include/uapi/linux/bpf.h
> index 5d2fb183ee2d..9b681bb82211 100644
> --- a/include/uapi/linux/bpf.h
> +++ b/include/uapi/linux/bpf.h
> @@ -136,8 +136,11 @@ enum bpf_map_type {
>  	BPF_MAP_TYPE_STACK,
>  	BPF_MAP_TYPE_SK_STORAGE,
>  	BPF_MAP_TYPE_DEVMAP_HASH,
> +	__MAX_BPF_MAP_TYPE
>  };
>  
> +#define MAX_BPF_MAP_TYPE __MAX_BPF_MAP_TYPE
> +
>  /* Note that tracing related programs such as
>   * BPF_PROG_TYPE_{KPROBE,TRACEPOINT,PERF_EVENT,RAW_TRACEPOINT}
>   * are not subject to a stable API since kernel internal data
> @@ -173,8 +176,11 @@ enum bpf_prog_type {
>  	BPF_PROG_TYPE_CGROUP_SYSCTL,
>  	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
>  	BPF_PROG_TYPE_CGROUP_SOCKOPT,
> +	__MAX_BPF_PROG_TYPE
>  };
>  
> +#define MAX_BPF_PROG_TYPE __MAX_BPF_PROG_TYPE
> +

This came up before and my position is still the same.
I'm against this type of band-aid in uapi.
'bpftool feature probe' can easily discover all supported
prog and map types already.

