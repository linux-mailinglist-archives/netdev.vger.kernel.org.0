Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAD2E19FB9C
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 19:30:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728488AbgDFRas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 13:30:48 -0400
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37427 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726852AbgDFRar (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 13:30:47 -0400
Received: by mail-pj1-f67.google.com with SMTP id k3so120710pjj.2
        for <netdev@vger.kernel.org>; Mon, 06 Apr 2020 10:30:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ztb+Pw0KQ2bqKmxtrOtPbhkkYG/T3WFBiYg+yYAiv8I=;
        b=OJi/Jq7Zx63dPRY6UwFLmasrv6DQRVD3TE+Bowm59nJqIMYnMzrcXbg9RjoZHf6HiK
         rtnglZjgQKQIYbe/bhKSRs1qXBGFpd4QihFsEzQUZShz4o1pWiwUnoqgTZRL8SRqgWPg
         ugsT0GUgT5PwtOctR5f7IhYeeSNuOIO9ng3ZRMWN9RG4kM3eBrZDO5Vmga1/qARhXIoe
         eAP+v0/u23JbmR0HX8rIZ9nshTiGY6XiRDE8gqVZDKdbviaDpoqVSbhCTtk4d+IdLmSI
         jhD4hUu6DW37xJBn8/cIDRd5d2dBCxPRCiAD+mZhXMpXK09s3Nj4OaZAIHWMTB12K0N/
         U/jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ztb+Pw0KQ2bqKmxtrOtPbhkkYG/T3WFBiYg+yYAiv8I=;
        b=MvcY2LK9pdwGdtC1R534GjFSURKQh/nWMgMaBbCymo3ArN6RpfXH5IEATE5G6UPWou
         XCWoH6LQogFsQ6rQnAXPsmCSXz+/sjfrm9F0fmVjvdLSYmZfhvzL05xaBRYNoLZqNt1b
         QCUkpTx+37YX8QXaZvgt5lz+TEOdgKMFLcFEsn0knFnN0nL2KPOC0esILOBL07or1/Xe
         uYIVV2pjBbPFZqnc36csCr4IvgaXZQFmEmcca3svYIP3CZANjEf8o6YD/LdJvJ607uH5
         ONBvYYW2N99qrEibQx4Vf1iRYmKTD1PpLZXYS3KGyjbXw5wxOCbgAoM1lLvj7LGti0xw
         CY8w==
X-Gm-Message-State: AGi0Pubv21OBRQPZxcAJIACmC2VH3BbAW8r1ptM2TpJsMH94xBIH7Ykg
        3xbcP0UCJX5tVhgFTtn+QhAi/A==
X-Google-Smtp-Source: APiQypIxYJOTQpo/vSA19GTULttZXMyWVafysRntseRs2LSVMw27bka8vCf4+TG3TvuLCIuwAsv1fA==
X-Received: by 2002:a17:902:7603:: with SMTP id k3mr21826946pll.100.1586194245055;
        Mon, 06 Apr 2020 10:30:45 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id t66sm153762pjb.45.2020.04.06.10.30.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 10:30:44 -0700 (PDT)
Date:   Mon, 6 Apr 2020 10:30:36 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com, mlxsw@mellanox.com
Subject: Re: [patch iproute2/net-next 8/8] man: add man page for devlink
 dpipe
Message-ID: <20200406103036.2ac9c665@hermes.lan>
In-Reply-To: <20200404161621.3452-9-jiri@resnulli.us>
References: <20200404161621.3452-1-jiri@resnulli.us>
        <20200404161621.3452-9-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  4 Apr 2020 18:16:21 +0200
Jiri Pirko <jiri@resnulli.us> wrote:

> From: Jiri Pirko <jiri@mellanox.com>
> 
> Add simple man page for devlink dpipe.
> 
> Signed-off-by: Jiri Pirko <jiri@mellanox.com>
> ---
>  man/man8/devlink-dpipe.8 | 100 +++++++++++++++++++++++++++++++++++++++
>  1 file changed, 100 insertions(+)
>  create mode 100644 man/man8/devlink-dpipe.8
> 
> diff --git a/man/man8/devlink-dpipe.8 b/man/man8/devlink-dpipe.8
> new file mode 100644
> index 000000000000..00379401208e
> --- /dev/null
> +++ b/man/man8/devlink-dpipe.8
> @@ -0,0 +1,100 @@
> +.TH DEVLINK\-DPIPE 8 "4 Apr 2020" "iproute2" "Linux"
> +.SH NAME
> +devlink-dpipe \- devlink dataplane pipeline visualization 
> +.SH SYNOPSIS
> +.sp
> +.ad l
> +.in +8
> +.ti -8
> +.B devlink
> +.RI "[ " OPTIONS " ]"
> +.B dpipe
> +.RB "{ " table " | " header " }"
> +.RI "{ " COMMAND " | "
> +.BR help " }"
> +.sp
> +
> +.ti -8
> +.IR OPTIONS " := { "
> +\fB\-V\fR[\fIersion\fR] }
> +
> +.ti -8
> +.BI "devlink dpipe table show " DEV
> +.R [
> +.BI name " TABLE_NAME "
> +.R ]

I applied the whole set, but fixed some issues on the man page.
You had some trailing white space, and the .R macro is not the right
way to do this. Make check runs a script from Debian and it spots that.

