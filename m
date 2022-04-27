Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEF4A51118A
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 08:46:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244222AbiD0Gt1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 02:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243581AbiD0GtZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 02:49:25 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56AA114C3F3
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 23:46:14 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id u3so1085421wrg.3
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 23:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3/D+QgKEFsBMR82p2RR7cNY1E/SLLYTeAIRlhtiDYMs=;
        b=I1c5RNmAGEQjZdWencRGnFmUNiAVQweGdGr08hbWB4V/ccS1LiILs8RyHnJFxGqM+T
         8/s/k5lgZ/R8OBy9aW6xCwKgO5WtB+XiOj6ANUm7dNZo2p+MYx2lsleC5H6XY2b8tfyM
         60E/CdOnhnvDfJYNXNX7tFBU2es7LLkgmB/jp5fNIjKTjQCvj2PZ6ZJVtsY0GVrXQVXX
         4ITFyEACDHSSANbAuLVvwWXFcYfazrmq1s2ef8/H9G0UY0ZoSw+iZ06XekcKppsdKABC
         3sCMk36RhRLvOW99Q79GruqEqcsdk6RgyKky8lNEoBduMTd8aNvVNZQAclDOSh4E5kHP
         4IwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3/D+QgKEFsBMR82p2RR7cNY1E/SLLYTeAIRlhtiDYMs=;
        b=njWs+EcdLiIX2AnceEPvA+ldZS22l03JyjrgAk7BkVAJgSGAxMmWxBgx9wRGUisXJr
         JJjCc5dlas+oRDLBWlGOdFz5xwfYuro/7ovr8JkNGw8/Bhb0TYZdRssX188ISJjfyBbN
         v9iB6ELD0/98lsLSccaIJ8scMeuyO7QI/nK5F12ntDSI2dHn7k+wqx0iG/aXjOaME0Q8
         wI4Pr1vfx0Wk/y5FaF5NWegEElo28zvHMBzOSgvv+C1aMsWSeHroU3dM0ErjG7tEMnsz
         E9mfpi9pCnBe0vItOo749gfXMhkejOdfvM/axfT4AjZ9MGk38SlR9jKHi2XB8xzl46Pu
         2PPw==
X-Gm-Message-State: AOAM531CYRDqgeEthNGgwSzvns5OA1VhiNiaVGHkJtKTNqFTI/8GsBDe
        xF+w7es21Oi1Ozcezts4Vy/P0DGg36joy1zp2zY=
X-Google-Smtp-Source: ABdhPJy94CfIG0Q1Q1XTJFEE8ABI6Df8oxqoysGkCWNDPhpzpm2pNllsz4Iz4ijsOGgy47KEqcflfA==
X-Received: by 2002:a5d:4348:0:b0:206:1c79:fd57 with SMTP id u8-20020a5d4348000000b002061c79fd57mr21594935wrr.344.1651041972804;
        Tue, 26 Apr 2022 23:46:12 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id j24-20020adfa558000000b0020ae9eafef9sm2156734wrb.92.2022.04.26.23.46.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Apr 2022 23:46:12 -0700 (PDT)
Date:   Wed, 27 Apr 2022 08:45:54 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     kernel test robot <lkp@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        netdev@vger.kernel.org, Ido Schimmel <idosch@idosch.org>
Subject: Re: [linux-next:master] BUILD REGRESSION
 e7d6987e09a328d4a949701db40ef63fbb970670
Message-ID: <YmjmogCkTqEMbHiY@nanopsycho>
References: <6267862c.xuehJN2IUHn8WMof%lkp@intel.com>
 <20220426051716.7fc4b9c1@kernel.org>
 <Ymfol/Cf66KCYKA1@nanopsycho>
 <YmgIu4L6f4WfrIte@nanopsycho>
 <20220426103537.4d0f43b7@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426103537.4d0f43b7@kernel.org>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Apr 26, 2022 at 07:35:37PM CEST, kuba@kernel.org wrote:
>On Tue, 26 Apr 2022 16:59:07 +0200 Jiri Pirko wrote:
>> >>is this one on your radar?  
>> >
>> >Will send a fix for this, thanks.  
>> 
>> Can't find the line. I don't see
>> e7d6987e09a328d4a949701db40ef63fbb970670 in linux-next :/
>
>Eh, no idea which tree it came from, but FWIW I do have that one in my
>local tree. So here it is:
>
>   844		devlink_linecard = devlink_linecard_create(priv_to_devlink(mlxsw_core),
>   845							   slot_index, &mlxsw_linecard_ops,
>   846							   linecard);
>   847		if (IS_ERR(devlink_linecard)) {
>   848			err = PTR_ERR(devlink_linecard);
>   849			goto err_devlink_linecard_create;
>   850		}
>   851		linecard->devlink_linecard = devlink_linecard;
>   852		INIT_DELAYED_WORK(&linecard->status_event_to_dw,
>   853				  &mlxsw_linecard_status_event_to_work);
>
>Unless I'm missing something looks like a false positive :S

Yeah, that is where I ended up as well, came into conclusion I have to
be looking at a different code.
