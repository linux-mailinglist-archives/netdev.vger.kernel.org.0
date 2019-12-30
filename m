Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CDE4712CC4E
	for <lists+netdev@lfdr.de>; Mon, 30 Dec 2019 05:44:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727109AbfL3Eo1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Dec 2019 23:44:27 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:38445 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727069AbfL3Eo0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Dec 2019 23:44:26 -0500
Received: by mail-pl1-f195.google.com with SMTP id f20so14173437plj.5;
        Sun, 29 Dec 2019 20:44:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=+C7p7tKjwh3r3Si8xU3JpxpVtO3MaH+O6+ULlEMKIq8=;
        b=ZNOAebhJ3GFNTV/NAYN43Y6rbo5NFGxj6cF6magpBfgG/jDwlTG9W6AcGBJFiY1H9C
         SZGK8WmGd5FYRX/S/JalZZprpCUlLAy2cUi1s/xmziwkgvprX445HsJXxr4yRDhe4zsj
         jAjht24cpDO2ZD4GRdxsTAwqQaYnIdG8RydNxe7AXyigk04DybZq35PDUwxIPA/2MCOJ
         rkspV0uU5+XalpJ6p2RYn2In02mNXzYszZKb+FW+3SvqeBGJLUyL2PWpl/iX+8xV0kEJ
         9Sk/qqmzMh4j/dFr80q61ej+CDQN1xvF2ihGIAfhawlwru3QFuLHzx9xjnErubY3GX1w
         wghg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+C7p7tKjwh3r3Si8xU3JpxpVtO3MaH+O6+ULlEMKIq8=;
        b=YfEBr3m9TC4D6QEwL8AZ4B1Vf1/Or6m6xFr09SkxsanFwCpvKP7m0d3+hEK5efh/qM
         6K3BuspZMIW+qvW76svxFfbZEQ2n9L4qb0gPyZcUlt2HSThsDN21gyhAZuroFUJakURO
         CdyAb0Bgh4DgQwLW7mgRlYeDRb4V17+jlaSDPfyRYCans+wl4/MBBpabhYn0Tw6YdaIC
         p3cES9k/YpQWpBgdhSqrtmzGfOt2Q+fnIB3o1/I+OwbtwBNpJfl9iBPEUC19DZAR5BMC
         A3YTqYtA+/IUM7Eg18uWeV1dGE2i1Si/Wl91YxsBMjz82G133xK7/ChbKkvT/zPgUDH9
         qBAA==
X-Gm-Message-State: APjAAAV8U3HjPCAHx8otFYH2VD01iXrQZqTK+XSv3r/+2mAJbxaf0ouo
        qFWBp481zj2m0KJV8no2UowLWP21
X-Google-Smtp-Source: APXvYqxraJDgv8En8xtOIs0QbcR3LyjHjKSlHMXiDml1uJ4T33topV9ITGZN40qV/0Jy2CzxSaKLuw==
X-Received: by 2002:a17:90a:8c05:: with SMTP id a5mr44664630pjo.86.1577681066119;
        Sun, 29 Dec 2019 20:44:26 -0800 (PST)
Received: from f3 (ag061063.dynamic.ppp.asahi-net.or.jp. [157.107.61.63])
        by smtp.gmail.com with ESMTPSA id 18sm42176496pfj.3.2019.12.29.20.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Dec 2019 20:44:24 -0800 (PST)
Date:   Mon, 30 Dec 2019 13:44:20 +0900
From:   Benjamin Poirier <benjamin.poirier@gmail.com>
To:     Matthew Hanzelik <mrhanzelik@gmail.com>
Cc:     manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: qlge: qlge: Fix SPDX License Identifier style
 issue
Message-ID: <20191230044420.GA13113@f3>
References: <20191227055138.erzmqrahz2xksfda@mandalore.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191227055138.erzmqrahz2xksfda@mandalore.localdomain>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2019/12/27 00:51, Matthew Hanzelik wrote:
> Fixed a style issue with the SPDX License Identifier style.
> 
> Signed-off-by: Matthew Hanzelik <mrhanzelik@gmail.com>
> ---
>  drivers/staging/qlge/qlge.h | 1 +
>  1 file changed, 1 insertion(+)

Should it also be added to qlge_main.c?

You can remove the outdated comment about LICENSE.qlge at the same time.
