Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65F50C4B8
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:45:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229446AbiDVXcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 19:32:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229609AbiDVXb7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 19:31:59 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F64B1E5F50
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:10:58 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id q1so12770695plx.13
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 16:10:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=z4w39TRtx7RK1b/gol6KhX5Cgz65EvsjNCyFHDmxaVI=;
        b=oFLr3jV+F5Xj4LkcOA/RdLnJedjfwkLIXbxYhmHKG75vgk/A5y42/Puab3r8MA99u7
         LhSwTHIM0nWdNxte5O1m5Auycy/87iKCy9jT8QUYOk7+u5Le87ojkbwlZYvxbbOOlf9x
         SRSlIFgz96IWWUY75dQI9qxMcA5ZoE+jeiXRjcEBEEUfBj2VZK78q9xiNVzbbzDec33m
         ugyh5nVIV6Gda/XWqFwYiIqggJ2l29r9SYMSBL77cEiJJ5Juwko+QYgRkR2v6T/MZ22b
         PUtMRsjVCP92u0UN28hCzYdhPy7au1ar5/ng3Q+CBqsTkCw2mfL73TKe5X5RzPoFGZd5
         0Ntw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=z4w39TRtx7RK1b/gol6KhX5Cgz65EvsjNCyFHDmxaVI=;
        b=Ca2GyCfXq/4a/ultWAiDsScsQiqqeub28Z+VxTmXzT+2yNV7ZxPY3H4qiXQcOu5vG8
         3+p1RWJpF1/W+ZLmYEllRHTHFKKuKUVApwni9b/XanEInZ4HCMeDCcBfqGI/JDUS3Yan
         LuC/BtsK3eGMLD4a20BFJzTOibgvI5Wftl8BQ0E4oYmcSCKeqLT8NQE/OZTkysWRtdMn
         aw7Ax5ToarfFM7hxvizxOwa4m4+WRtNbc0gTOrP2tcNyP8sdQDG7QgYF8CjKu9eLn8vv
         m0jhAnmr1vjCyR360Dh4rs3Qu9c+4k2JQp3sqxAnBs0W7O9EB1RF/bQhDuIJXt5fqcmU
         brPw==
X-Gm-Message-State: AOAM530MxjFxY2xZ/QYahK8XydILMc9gQuC1/BNjLLvQ1wOemSlMdA9q
        UIIWRbF5dQKI7726xd73bgczpYyt1f7Rww==
X-Google-Smtp-Source: ABdhPJwBU2QiwQUpDinYtI+WeyHz+QzkvaOeYuKj3+2ENh2ht6pkHX06JmCO2PsoSVDXE5dd3nd2gA==
X-Received: by 2002:a17:902:bb90:b0:156:2c05:b34f with SMTP id m16-20020a170902bb9000b001562c05b34fmr6973166pls.53.1650669056991;
        Fri, 22 Apr 2022 16:10:56 -0700 (PDT)
Received: from hermes.local (204-195-112-199.wavecable.com. [204.195.112.199])
        by smtp.gmail.com with ESMTPSA id l5-20020a056a0016c500b004f768db4c94sm3709321pfc.212.2022.04.22.16.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Apr 2022 16:10:56 -0700 (PDT)
Date:   Fri, 22 Apr 2022 16:10:54 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        sthemmin@microsoft.com, dsahern@gmail.com
Subject: Re: [patch iproute2-next] devlink: introduce -h[ex] cmdline option
 to allow dumping numbers in hex format
Message-ID: <20220422161054.1db3c836@hermes.local>
In-Reply-To: <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
References: <20220419171637.1147925-1-jiri@resnulli.us>
        <56b4d3e4-0274-10d8-0746-954750eac085@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 22 Apr 2022 14:36:21 -0700
Shannon Nelson <snelson@pensando.io> wrote:

> >   static int fmsg_value_show(struct dl *dl, int type, struct nlattr *nl_data)
> >   {
> > +	const char *num_fmt = dl->hex ? "%x" : "%u";
> > +	const char *num64_fmt = dl->hex ? "%"PRIx64 : "%"PRIu64;  
> 
> Can we get a leading "0x" on these to help identify that they are hex 
> digits?

Yes use %#x
