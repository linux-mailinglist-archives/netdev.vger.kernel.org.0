Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD604AEECA
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 11:00:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiBIJ7U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 04:59:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231283AbiBIJ7H (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 04:59:07 -0500
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08418E022AED
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 01:58:59 -0800 (PST)
Received: by mail-ed1-x52c.google.com with SMTP id eg42so3905728edb.7
        for <netdev@vger.kernel.org>; Wed, 09 Feb 2022 01:58:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/D04XVPUs/5HR5eK+SG7yKk26D53w7R1O65LyTbVnhA=;
        b=qwScALETKFRV/s20Zvi2Sxab1LpermV3ZwMsBGBkqcgv7y8TjBOxstj817Px9r3ri6
         3znyzCwnHMgIP6UGdgAX0GzL1f8Ea79uEQrh+/z2uncx6cBfJGfBStkpnMWWNQz4mu1P
         LHgCllgSzz1rTaV8NQKQ+IrIb+eoB9cFSUww2S4R42/EknI436wjLv7FJpaxJV6CCXBc
         Q/7gg3bizeZCudmAmggc5pr51wJjT1FBOrhebmwZJzl2QvBSE1h5l+lCY+jCR3DZWO7H
         361AWTSrr9qklT6XOLqofWXljxL7Yl/M2PxVDltH4VayKtPS7cugApZilp9+f21kljSn
         GzMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/D04XVPUs/5HR5eK+SG7yKk26D53w7R1O65LyTbVnhA=;
        b=3IiW7Om47AubHL9dPCK4j2Ns1qCwlfwtenGFVab4u5gvEnjqg7XdkNVi0KClTG2fk2
         ili+wAf2my1RevmIP6BEawcnCA7PqnlxFMRwETDjfCFGyNTeEGzl1+vUULZ9Pel2Rcfc
         IYpwLFfgwapEu3Nj6k3tQLiwIgAYryqA4Zx9VmXuRWRQf8uOF5Rn2TYIc2w63KJoHoD3
         cE4GMHNaTFLRc3rED2ze7uBEJXkX0bZ7iSgdgp3f1cc57rNT7RQbMu0FmMybG5FGvqFP
         ZHeuW4Xcx0WDAysanAZ8QSXX6V7yIDzTlODvZ7o7ODVLjYxCjLlIQC51RL3i9C1poMbG
         3eFw==
X-Gm-Message-State: AOAM533YBfrZ3CgAzBdPRCeJJeM6uAkJu2SQ2rFrT9ghiTEm7YyROsDS
        T2vG+cbPxajyrNu6d5fcX5DSog==
X-Google-Smtp-Source: ABdhPJwf4VpG7Y4Q79qJuY4Hkah8ElZGEG7qRJxEJ0pnu595fxjaeUVGYFYRcR0meWnJGMfmTtmGjQ==
X-Received: by 2002:aa7:c746:: with SMTP id c6mr1549045eds.271.1644400643017;
        Wed, 09 Feb 2022 01:57:23 -0800 (PST)
Received: from localhost ([85.163.43.78])
        by smtp.gmail.com with ESMTPSA id i24sm1748263edt.86.2022.02.09.01.57.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 01:57:22 -0800 (PST)
Date:   Wed, 9 Feb 2022 10:57:21 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Moshe Shemesh <moshe@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 0/4] net/mlx5: Introduce devlink param to
 disable SF aux dev probe
Message-ID: <YgOQAZKnbm5IzbTy@nanopsycho>
References: <1644340446-125084-1-git-send-email-moshe@nvidia.com>
 <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220208212341.513e04bf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Wed, Feb 09, 2022 at 06:23:41AM CET, kuba@kernel.org wrote:
>On Tue, 8 Feb 2022 19:14:02 +0200 Moshe Shemesh wrote:
>> $ devlink dev param set pci/0000:08:00.0 name enable_sfs_aux_devs \
>>               value false cmode runtime
>> 
>> Create SF:
>> $ devlink port add pci/0000:08:00.0 flavour pcisf pfnum 0 sfnum 11
>> $ devlink port function set pci/0000:08:00.0/32768 \
>>                hw_addr 00:00:00:00:00:11 state active
>> 
>> Now depending on the use case, the user can enable specific auxiliary
>> device(s). For example:
>> 
>> $ devlink dev param set auxiliary/mlx5_core.sf.1 \
>>               name enable_vnet value true cmde driverinit
>> 
>> Afterwards, user needs to reload the SF in order for the SF to come up
>> with the specific configuration:
>> 
>> $ devlink dev reload auxiliary/mlx5_core.sf.1
>
>If the user just wants vnet why not add an API which tells the driver
>which functionality the user wants when the "port" is "spawned"?

It's a different user. One works with the eswitch and creates the port
function. The other one takes the created instance and works with it.
Note that it may be on a different host.
