Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 233468B531
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 12:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727959AbfHMKPS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 06:15:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35780 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727297AbfHMKPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 06:15:18 -0400
Received: by mail-wr1-f67.google.com with SMTP id k2so21370447wrq.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 03:15:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=dOINUI+NHtkPS8+FD3cM+0DjVKn97a3YUzVPE348foI=;
        b=yXXaXLbsxFa5dli8uMFhZcHWbrvBhOFT1bm9LYcyFnAvSk2KPxL0VLtscao3jBspU2
         NsGfvithO7aBL935Osa0fY1dMdFYKBLJi3pKj/9pm9XBjdoKt6f5wxdoGPJnj59Q2Z8M
         pS3Lvu/6jADsbES+8SRUcP4GEQw+SI9MBYRSQqc1L1XPxzX8vzjwNVAuCHlCOkq5p3Y3
         uuW/5+KqilDpKzih+73hRy0hOSEyRhs1K9E98dr1LSEXAHprSBqSil+SrJqUwk401eTL
         OJMlFLkFG2GsSUl2v90lFgr9xKPdW0/vWYQ6W5ZqN9DlQqEJPEGUpEEUC1sHEZLeNgJ4
         jMrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=dOINUI+NHtkPS8+FD3cM+0DjVKn97a3YUzVPE348foI=;
        b=RLf03KSHUwF5Bfv7dejOQpelXvzadXYIkD5uOYhXC5Q1HEJNGt4yk+DWjrBGnj+2ua
         rjHRZDF+FS+C3igLTgeUwg8kY5gBowzBTnKyX8NZ16qIEHpFTSTFtkS6vqnWnIyYsq71
         KgUaiTHhppDqvMxvl6e+ROGYP9Gk8csqOu8SxlloH2xlR7bS7mGeNFR5WqedM71P3MBk
         8XdDZnXuHC/09T2Lpsj3/eIpQS4713D34bmoILMbAYrPHqsbwCCLAkKLc062ky4Iqdo/
         F5xDw+ZYbNj04U3VSY2DObrUzHtN8G7/m6Ooq+3UYb5RC/ydHjbQRou1/+Jr5joaZolj
         y7Zw==
X-Gm-Message-State: APjAAAWW1ocJznblmbrrzBMszFGzOiJXmV3V45EdSVcUoW0mCP3iazSu
        luwtrQRdfQq29vlhRn99jiDpiw3+RGE=
X-Google-Smtp-Source: APXvYqzlKUE64JOiEsQ6JnYtEFol3Ti5nqzmIjUrCfc09QpF6tvOIFYwxvsQVn6dOCgQOlMm8w8LBA==
X-Received: by 2002:a05:6000:1085:: with SMTP id y5mr37852395wrw.285.1565691315957;
        Tue, 13 Aug 2019 03:15:15 -0700 (PDT)
Received: from localhost (ip-78-45-163-186.net.upcbroadband.cz. [78.45.163.186])
        by smtp.gmail.com with ESMTPSA id n16sm811245wmk.12.2019.08.13.03.15.15
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 13 Aug 2019 03:15:15 -0700 (PDT)
Date:   Tue, 13 Aug 2019 12:15:15 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, jiri@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH iproute2-next v2 3/4] devlink: Add devlink trap group set
 and show commands
Message-ID: <20190813101515.GO2428@nanopsycho>
References: <20190813083143.13509-1-idosch@idosch.org>
 <20190813083143.13509-4-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190813083143.13509-4-idosch@idosch.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Aug 13, 2019 at 10:31:42AM CEST, idosch@idosch.org wrote:
>From: Ido Schimmel <idosch@mellanox.com>
>
>These commands are similar to the trap set and show commands, but
>operate on a trap group and not individual traps. Example:
>
># devlink trap group set netdevsim/netdevsim10 group l3_drops action trap
># devlink -jps trap group show netdevsim/netdevsim10 group l3_drops
>{
>    "trap_group": {
>        "netdevsim/netdevsim10": [ {
>                "name": "l3_drops",
>                "generic": true,
>                "stats": {
>                    "rx": {
>                        "bytes": 0,
>                        "packets": 0
>                    }
>                }
>            } ]
>    }
>}
>
>Signed-off-by: Ido Schimmel <idosch@mellanox.com>

Acked-by: Jiri Pirko <jiri@mellanox.com>
