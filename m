Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93237C00DE
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfI0INh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:13:37 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45936 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbfI0INh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:13:37 -0400
Received: by mail-wr1-f66.google.com with SMTP id r5so1598986wrm.12
        for <netdev@vger.kernel.org>; Fri, 27 Sep 2019 01:13:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=MnnLVjXSKGX+rNMCV3wMh1443aU2bEDE/s5MTT2/O+g=;
        b=aKmvfFAkHU8hB0VjjoFNjVl17Ob7OajBizBLCD8Jrr6Y71qvG2rxX0UHfGxUwpQ1JF
         nI2U6T189a3t1ruqT6mbPc/lZD0WKgBr3BgdrGSO6jbphpq4p1oOTiotyClKSEFQXiCA
         55RHKIwx1DkEf3HucOm8OT3YrDXwrHdLVhxIWGIAe/3Pl+G6z9OyLw/PZWgmxYJPi1F5
         VFljmYTxyAUM4qRhbo6Pla/uZ8G4MYi+ZYRwMiHC3Fc/5b/BRaxnqsf5zuKSX97CVrYF
         hlYVmlHIZhqiuOSNicZF1G/rpV9TAh31rp/Sm+o3Thmwjo/HIOwHlBgsJ4Qn8HZIc4il
         ZHFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=MnnLVjXSKGX+rNMCV3wMh1443aU2bEDE/s5MTT2/O+g=;
        b=HDEXOOP8AbtQS5p1lr0yqt81ChWjHRTIN2PvwyrhMYk+6Ti5AZ1PZEUDEeqNJ37e/Y
         qG1p+WFg2VCosGMXNO7JqVmkEEf6sa6APb5XddMgralCtQSEojbYUNSM3ZSaYNKHK/aQ
         MiADTm8AwpH1j/8RNRC+G9WrHE6mwSUilNffNmb+AFbfP1l2JC4/5g7igEFKhvnATo2E
         h84YumJbdCLjz2AMjz6S0YWxHwEFSGx1MKYdfWYoCfJ40+H3jkmjunoviN3+dU3xRQFR
         3pa1nT9Gft35WozkGGScpriii1X8NFYfydoK1GiVXWj564sizbVxe6naDskXTvnEAdNZ
         5a0Q==
X-Gm-Message-State: APjAAAU3tdEGdWvGwvqJIclRD44GwrwsaufViLgo5YPSYQXKZaeGLGoP
        v003yjhKxfx6XY2O5ZrRZyrUcA==
X-Google-Smtp-Source: APXvYqz6NGVe9mZFDa0OOkFftNd28vBgixsgyqbSgCDaFhZF3cZMA8+CUpbe/Xu9ntQdCVC7oqnU8A==
X-Received: by 2002:a5d:4a43:: with SMTP id v3mr1998384wrs.146.1569572014805;
        Fri, 27 Sep 2019 01:13:34 -0700 (PDT)
Received: from localhost (ip-78-45-160-180.net.upcbroadband.cz. [78.45.160.180])
        by smtp.gmail.com with ESMTPSA id q124sm7696722wma.5.2019.09.27.01.13.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Sep 2019 01:13:33 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:13:33 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     jiri@mellanox.com, valex@mellanox.com, davem@davemloft.net,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>
Subject: Re: [question] About triggering a region snapshot through the
 devlink cmd
Message-ID: <20190927081333.GF3742@nanopsycho>
References: <f1436c35-e8be-7b9d-c2f5-b6403348f87a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f1436c35-e8be-7b9d-c2f5-b6403348f87a@huawei.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Sep 27, 2019 at 09:40:47AM CEST, linyunsheng@huawei.com wrote:
>Hi, Jiri & Alex
>
>    It seems that a region' snapshot is only created through the
>driver when some error is detected, for example:
>mlx4_crdump_collect_fw_health() -> devlink_region_snapshot_create()
>
>    We want to trigger a region' snapshot creation through devlink
>cmd, maybe by adding the "devlink region triger", because we want
>to check some hardware register/state when the driver or the hardware
>does not detect the error sometimes.
>
>Does about "devlink region triger" make sense?
>
>If yes, is there plan to implement it? or any suggestion to implement
>it?

Actually, the plan is co convert mlx4 to "devlink health" api. Mlx5
already uses that.

You should look into "devlink health".

>
