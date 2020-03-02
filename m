Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32669176152
	for <lists+netdev@lfdr.de>; Mon,  2 Mar 2020 18:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727226AbgCBRmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 12:42:39 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39735 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727075AbgCBRmj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Mar 2020 12:42:39 -0500
Received: by mail-wm1-f67.google.com with SMTP id c24so176758wml.4
        for <netdev@vger.kernel.org>; Mon, 02 Mar 2020 09:42:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6gDExbChZA2Xr7RhZciM0W8qUlSPXgEhUSyA7WeIm5E=;
        b=l4I7UEAVzRWjPnLl8yYOsRXZU7WhQ0l/LsuG/xJ/Treb9OYXD4KW4jSK2YIMVNJjOe
         BcCamiAvao27uDswQOF4guLkveQwY2axf08/Kqv0u0JYd7qMhZAv2jyv60dvrUorpSUH
         WyG21mdeCwkl362CyoQfESmDEaPARDEYPvSqXrTSk9dP73/EKTXfrwvait7hxQJNL3LX
         UdjoOjblOVDdlDGNStSlhuYqcFJzK6y8WQmb2CamRHXe/6b+MynLW6G2Ds+5gFlsTF5q
         F/J75d5U1WFAY9hF94XDBOxD3n6sRNRCPWGNIvs+tdPE8ZH96VjTmBVO3w3gZu8zuIQz
         deDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6gDExbChZA2Xr7RhZciM0W8qUlSPXgEhUSyA7WeIm5E=;
        b=BCr6hFuMiaPX+bVzPKA6NLFOIPH6MTjQTuMUbvSn0cUhS4w9tj0BISJaVcpNOcKdMd
         V0LXXMiGD/xusZwcn/7NxEKvB01YFdMRe+eKDgwPc4YkWbXItEFtBMivcHPDnZ5aDjKr
         lLfxiXEUWhcKCRu6bTyvtQLoWmNeAiyOoRAV1Y3Htgm912AseSM0p7DLdHpPPGot0/wX
         x7gkGFqFgO9pJ3GzX+OitowOqKu9InIcHxWi0r69k8AdbRGMCHFhVQrQjC3QNBvHAq0e
         QLHFQtYudNBdOLHtmIK0wWRMBbj5vJcfOBDR7Wq8EVYok+cXeedcZV/ElDCxcKhfxLVs
         nQaQ==
X-Gm-Message-State: ANhLgQ3py+fdzLYckt8fXW5f8f+P7pwI0BxxoGh5iP6svojFqV73bSpr
        LHq2ln/+t65SXINRyBr8+yvc6A==
X-Google-Smtp-Source: ADFU+vuT+95l4FQkT8+056h4/SoczqZCFZYKOy4VlFczh4mtDA3y/7YtiEx3YTB5w6Y6x6d+hcGXtA==
X-Received: by 2002:a7b:c847:: with SMTP id c7mr175134wml.3.1583170958085;
        Mon, 02 Mar 2020 09:42:38 -0800 (PST)
Received: from localhost (78-136-133-133.client.nordic.tel. [78.136.133.133])
        by smtp.gmail.com with ESMTPSA id j5sm29532457wrx.56.2020.03.02.09.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2020 09:42:37 -0800 (PST)
Date:   Mon, 2 Mar 2020 18:42:36 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jacob Keller <jacob.e.keller@intel.com>
Cc:     netdev@vger.kernel.org, valex@mellanox.com, linyunsheng@huawei.com,
        lihong.yang@intel.com, kuba@kernel.org
Subject: Re: [RFC PATCH v2 09/22] devlink: convert snapshot destructor
 callback to region op
Message-ID: <20200302174236.GE2168@nanopsycho>
References: <20200214232223.3442651-1-jacob.e.keller@intel.com>
 <20200214232223.3442651-10-jacob.e.keller@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200214232223.3442651-10-jacob.e.keller@intel.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sat, Feb 15, 2020 at 12:22:08AM CET, jacob.e.keller@intel.com wrote:
>It does not makes sense that two snapshots for a given region would use
>different destructors. Simplify snapshot creation by adding
>a .destructor op for regions.
>
>This operation will replace the data_destructor for the snapshot
>creation, and makes snapshot creation easier.
>
>Noticed-by: Jakub Kicinski <kuba@kernel.org>
>Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>

Reviewed-by: Jiri Pirko <jiri@mellanox.com>
