Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6CA31F10D3
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 09:12:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730139AbfKFIM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 03:12:29 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46215 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729896AbfKFIM3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Nov 2019 03:12:29 -0500
Received: by mail-wr1-f67.google.com with SMTP id b3so18809178wrs.13
        for <netdev@vger.kernel.org>; Wed, 06 Nov 2019 00:12:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=I8NwzYdCA6Ah+4Ubo1wejohymvJWkUgJtBqZIag+nLU=;
        b=uTesWkMpcySnXRoGDIYPSEwncSGzmrXVmyAQjq33bcUfReHctpo/759/sVJyuFjTbC
         3Kvxz8RH8D1sJhSnWHK1BZ18m5gfak+Zzz/raX/HYp2P+F1zTFpslL7nBqwWoyn3/gx+
         cC78BwiWQVWMbYw+Zz1C2aoVNUgcObR/f6NvrMeisCSph76dmCaAYaWc/mX6191qN3/A
         Cr85Hq822oS2DLg3PkltN9wD9NuStxudPigK6BIVfgNUCo2KH5ralWV/Y4VuJUtpb8ba
         oJl2Mu/2uLzyQC1kYLfi60eKgn3gyl+Wgj0uGhkaX+aOV0Ht+o4nQjTfzQsQX7F5lUSP
         CX+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=I8NwzYdCA6Ah+4Ubo1wejohymvJWkUgJtBqZIag+nLU=;
        b=Wmja4GiLP6andP4poGLCLczMKgC+NQzkjFC+dwRD24x4OKq4s1F5ycqDBlxTrgf87P
         jmZCdiCaay/PQPHgwzu5Nup4FPXmPdC9RnYzizNwalbuczdqG0N0oAdl+qDryn5rzoGD
         yDlR8J1Po5H/zBkF+wQohj/3TYwf9QDP2hsodC+F0JvOYsD87R9pxMjqOcV825uHyKFl
         47rBshHB8furfIBT+6Z7KpL7QXZkRxIzjL4I7Ny0Md9NuDRK6g3bxA5VVAm9wcjDNb4f
         BnsrGfHYS8RecV1X8C3QrbKhvcI3yTbgL6P5ovUEbj7AekXkE10Nl0quFXQYBzxgtscm
         5mfQ==
X-Gm-Message-State: APjAAAVVpS24nuVXnJcaPs/0aDMA9I/oBr/Gyk9uAgz0fnm0IOo/u+Av
        0tD62Ooh3nduUQZA3sYSaSpcmQ==
X-Google-Smtp-Source: APXvYqxe1DCUaMIuicY063Dc1VBwv6j7CPUBbzFFZ+epIuYf+ZN0BCPmuAKt2gYf8sKdqw38vU24wA==
X-Received: by 2002:a5d:674d:: with SMTP id l13mr1424690wrw.170.1573027947681;
        Wed, 06 Nov 2019 00:12:27 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id x205sm2799194wmb.5.2019.11.06.00.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Nov 2019 00:12:27 -0800 (PST)
Date:   Wed, 6 Nov 2019 09:12:26 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     stephen@networkplumber.org, dsahern@gmail.com,
        oss-drivers@netronome.com, netdev@vger.kernel.org,
        Jiri Pirko <jiri@mellanox.com>,
        Arkadi Sharshevsky <arkadis@mellanox.com>
Subject: Re: [PATCH iproute2] devlink: require resource parameters
Message-ID: <20191106081226.GA2112@nanopsycho>
References: <20191105211336.10075-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191105211336.10075-1-jakub.kicinski@netronome.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Nov 05, 2019 at 10:13:36PM CET, jakub.kicinski@netronome.com wrote:
>If devlink resource set parameters are not provided it crashes:
>$ devlink resource set netdevsim/netdevsim0
>Segmentation fault (core dumped)
>
>This is because even though DL_OPT_RESOURCE_PATH and
>DL_OPT_RESOURCE_SIZE are passed as o_required, the validation
>table doesn't contain a relevant string.
>
>Fixes: 8cd644095842 ("devlink: Add support for devlink resource abstraction")
>Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>--
>CC: Jiri Pirko <jiri@mellanox.com>
>CC: Arkadi Sharshevsky <arkadis@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
