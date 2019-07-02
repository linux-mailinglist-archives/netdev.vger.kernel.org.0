Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD7FE5D548
	for <lists+netdev@lfdr.de>; Tue,  2 Jul 2019 19:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726434AbfGBRbu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Jul 2019 13:31:50 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:36508 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726150AbfGBRbt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Jul 2019 13:31:49 -0400
Received: by mail-qk1-f193.google.com with SMTP id g18so14896829qkl.3
        for <netdev@vger.kernel.org>; Tue, 02 Jul 2019 10:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=w+hNGQvAbrzT98UIYf3/WS/xsiTLW0vUbF490MgRjvo=;
        b=wFbxUtAnur4Fl4sqvfbGAc8FdAA1Dm9B/NknOyoEi2qHvaFHYVl9uA7UUqWlo1kfv/
         OueB/3cPhqKCnyI/xCpIVd5Y1jJImx6V9BSpf75yAy2QyKmtyD21eoCDsIWrv2QyNi3F
         Az/Y4d09XHvECr9/3jzv0CV7vu2vH5JwPYC3ZwtrjFL744tXSxvZN0ArsuKD8vhFpoJY
         rDHGPgBIpmMfRKx08kU88/w1r0GGewVlPZK9jMrhgYt972Wgcx1lVZDQQYVoIlTCXFcA
         6xNTYI8ud81nWSJmreQPl/ZfW0cSKexl+5Ua5v63f8f+486v/O19nCABXn/9gawXg9O3
         KnSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=w+hNGQvAbrzT98UIYf3/WS/xsiTLW0vUbF490MgRjvo=;
        b=BKsTqwtxCL8UROKYIam/U0jaRhSH13dxhsGD5lauuNFtjA5qhjmCRp5z+f8Werh3rL
         XznbqOeIdwErWfpw2IBEh7bfhh+1eEXRcHkqxE8t13WIvx/LBMvrBp+kamdsLG1dhvQa
         iRjDroQ6G9paKRClXjUP9nhp9qt1S+bNf0LDBYXRLlfZ9G1+evU/Ch1UujaIihqkoq96
         ltBLpdj8ZXVRVQaJFPFd8+kG/QGI3byZxGzj+TmCHzJ6Y0Ss77x5nUr0YyWQans/EF4U
         e9XnTeVnx7LSxtzrWlYj/EvUD/kdTpzQ6bKFDVviUlfBC5yZ3mSrzkR8fvaNRoZfYYB3
         CZeg==
X-Gm-Message-State: APjAAAXxKhsccBVQpLy09z4LTmoIx58GVPsZVKgRdQA7EV18SmAZb88K
        KZVM48LCqReKjIvQRf0ys6Ax7Lds7tI=
X-Google-Smtp-Source: APXvYqwZqlT1poo0PCQcrfWccPaMcq5fs/1A71FVcFsJv7ZEj4tCt/xyS+GKfqcG6mFQBcUkHLWjZA==
X-Received: by 2002:a37:4e0d:: with SMTP id c13mr25682360qkb.116.1562088709124;
        Tue, 02 Jul 2019 10:31:49 -0700 (PDT)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id i17sm6280378qkl.71.2019.07.02.10.31.48
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 02 Jul 2019 10:31:48 -0700 (PDT)
Date:   Tue, 2 Jul 2019 10:31:44 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Takshak Chahande <ctakshak@fb.com>
Cc:     <netdev@vger.kernel.org>, <ast@kernel.org>, <daniel@iogearbox.net>,
        <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next v2] bpftool: Add BPF_F_QUERY_EFFECTIVE support
 in bpftool cgroup [show|tree]
Message-ID: <20190702103144.3765df1e@cakuba.netronome.com>
In-Reply-To: <20190702164843.3662715-1-ctakshak@fb.com>
References: <20190702164843.3662715-1-ctakshak@fb.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 2 Jul 2019 09:48:43 -0700, Takshak Chahande wrote:
> +	cgroup_fd = open(cgroup_path, O_RDONLY);
>  	if (cgroup_fd < 0) {
> -		p_err("can't open cgroup %s", argv[1]);
> +		p_err("can't open cgroup %s", cgroup_path);

AFAICS the bpf tree has not been merged into bpf-next yet, and there
will be a conflict here.  For no good reason.  Please wait, I will 
post my patch for inclusion when the time is right.

>  		goto exit;
>  	}
