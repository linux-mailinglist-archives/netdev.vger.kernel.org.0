Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0091A23AA5E
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 18:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728335AbgHCQUJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 12:20:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726239AbgHCQUI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 12:20:08 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C24C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 09:20:08 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id a5so24811143wrm.6
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 09:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ksgg+tMZFTuQ5G722MUtO6W4D9Sc6j/9SNDhFMh5on4=;
        b=i8YhnO6PZwESxmIGionQd/VS50YUzbVXkCPOTbcEfSQmDIP5LNrCb7vWsNW7+6nkN1
         VZtdAxjOHBYys2CkI+/UEx7L5/7MiPVu8d+FWrmWZTRm398+SbZNelN0NtoI9QXmdzpl
         xRileGzcpTo8tlOpgHANMPqkah/qQ76fL1nFGPGlhJVm26hFpl0FvWbE4uPSE93Wpi6s
         ZPo3mr9/rxV6YTejXAtVz+/rXsD7eCTdiuGJayylcLTSmqTFUDBNL0Vt1enCXyUNqW4G
         lOp0W8olDAlKDvbBlWJBTj81Ae5c7epaPL196lVKpbiYQsWfx7mp31E5AJVD/8Fhk5eH
         8xWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ksgg+tMZFTuQ5G722MUtO6W4D9Sc6j/9SNDhFMh5on4=;
        b=cMLuVbpoOM5U//U+jlBgcj2ErvZ+4Njvn8a2CwybEVV+VCAzoppjPvWvXHKUpwQFic
         Ss8wiobs2+HefZ+xA2PTJ1C6MH+I4p1228qtCvgpk7b2mdcr/xNuFraN6O2eh5RqtyZi
         rxn2hJ91s9hAKESJ4xAZIweF97adifh/yt6rE58zXzmVmG7UVe16tBViy24X3Yio7qsO
         x3A64gjZVAdXItdea3e2oakpo99OZ7MSlJhlujx95xa4RkM2pjptpbJrw4suNKvzg4e/
         yDbig3+xoTwAwhyo9kOuIdny8df/rDKbbRKZIAHE6pFz6NQGlvFYtEpIhR8ZDozMUWkU
         RlVw==
X-Gm-Message-State: AOAM533OTwmVGh493x4VCcDmQRVXDmhLg+cEJavt7aMPI6DBniN21FF0
        UNx2FQppl05iB7twL5zk6mZnZtvWc1M=
X-Google-Smtp-Source: ABdhPJyZjbBI1tqNML4YXYKaUpSC/PBDfQRG8vWGTwPQBIpJkCSfCY5xA/WoZeqCEcBLkJ3/gAsz/w==
X-Received: by 2002:adf:bbc1:: with SMTP id z1mr15598898wrg.173.1596471607252;
        Mon, 03 Aug 2020 09:20:07 -0700 (PDT)
Received: from localhost (ip-89-176-225-97.net.upcbroadband.cz. [89.176.225.97])
        by smtp.gmail.com with ESMTPSA id f63sm124047wmf.9.2020.08.03.09.20.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 09:20:06 -0700 (PDT)
Date:   Mon, 3 Aug 2020 18:20:06 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     David Ahern <dsahern@gmail.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org
Subject: Re: [iproute2-next v2 5/5] devlink: support setting the overwrite
 mask
Message-ID: <20200803162006.GF2290@nanopsycho>
References: <20200801002159.3300425-1-jacob.e.keller@intel.com>
 <20200801002159.3300425-6-jacob.e.keller@intel.com>
 <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0bb895a2-e233-0426-3e48-d8422fa5b7cf@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Mon, Aug 03, 2020 at 05:53:16PM CEST, dsahern@gmail.com wrote:
>On 7/31/20 6:21 PM, Jacob Keller wrote:
>> Add support for specifying the overwrite sections to allow in the flash
>> update command. This is done by adding a new "overwrite" option which
>> can take either "settings" or "identifiers" passing the overwrite mode
>> multiple times will combine the fields using bitwise-OR.
>> 
>> Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
>> ---
>>  devlink/devlink.c | 37 +++++++++++++++++++++++++++++++++++--
>>  1 file changed, 35 insertions(+), 2 deletions(-)
>> 
>
>5/5? I only see 2 - 4/5 and 5/5. Please re-send against latest
>iproute2-next.

1-3 are kernel.

>
