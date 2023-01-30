Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 399056813DB
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236587AbjA3OzV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:55:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbjA3OzU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:55:20 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E45D2ED75
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:55:12 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id f7so3959543edw.5
        for <netdev@vger.kernel.org>; Mon, 30 Jan 2023 06:55:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cUFNSHT58sfD+ju2WZCYaQZYJ90zhYTbnD18geeFktY=;
        b=ALK4GjXCxrh1lAOEo8KTtBr2byHp/PcVoqxLsU7ujdfRGOEQzkSEgfNl61IJTyO9mX
         co+JQfRqWxhxENCjHdgC0n984jNVEd8RRTl5r0Rm4OZbghpWhqOMH65Dh8C9XQ0iw67H
         VVY20Xtduo1NhbJSGebOSH2XTOuSySNhfc6lsQeKlsM507lFN+9Bqcm/NnEmtKNQiY2C
         Ip8G/mJyiKg9C13edCDaIix/kmI+Qe6mGdkUCcOF6A0nRzucV3ToPvCGlEF3MZcK7nk1
         GXYXt05/6F/okHRTGZFxuy5MMOJY7YQLshAIBjSjgWqds+7VOhmig+kAPvg7Vs5sAw0M
         3IoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cUFNSHT58sfD+ju2WZCYaQZYJ90zhYTbnD18geeFktY=;
        b=Pov0j3romt91F82OhAEuKZyUrrMmfdjmuG4/97yUjwkzx6070jYWPYI2wl8ofSdT67
         TtMK6bSNo9tk8FPgD7G7oa2AXyKiin7MCCU/+9wk/ihpXFUXfVuR/2oq5kEamDQnOG+y
         yKJTXJWUusx1N1aH2+FZTIytji9emxdwvgmMB3GvlBIemHzcvpxKbcRJAWyABF/m85L7
         QwstFIlxAG93pXkqKppxztUl7ddEA/fP4New3KKxTuzcf3WLcqPP3sLQKeTmbyCeA9nt
         jV8zjdKVMWMAv9zt6g4GFqbnuy3BL6Lc2QDfQIcvDzwg9vIa8S4hBPcdfK3bTsKtGMc3
         2+vw==
X-Gm-Message-State: AFqh2kr30X5zeHFcd0TRVSqYd2Ctg6jYgsYGLNuKtS38bmRmEeK21ZRr
        L89lOdgeWlCjg7ShMWud3itnnQ==
X-Google-Smtp-Source: AMrXdXu6ZVjQGgAN4UEO2FWcMcbLMNNCTpfEntdbkNZPyofd80Qp7oUVHdaNae/Rck0qXY//LhEm1w==
X-Received: by 2002:a05:6402:197:b0:481:420e:206d with SMTP id r23-20020a056402019700b00481420e206dmr49977701edv.42.1675090510724;
        Mon, 30 Jan 2023 06:55:10 -0800 (PST)
Received: from localhost (host-213-179-129-39.customer.m-online.net. [213.179.129.39])
        by smtp.gmail.com with ESMTPSA id m15-20020a056402510f00b0049f2109e4ffsm6926926edd.50.2023.01.30.06.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 06:55:09 -0800 (PST)
Date:   Mon, 30 Jan 2023 15:55:08 +0100
From:   Jiri Pirko <jiri@resnulli.us>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 1/5] batman-adv: Start new development cycle
Message-ID: <Y9faTA0rNSXg/sLD@nanopsycho>
References: <20230127102133.700173-1-sw@simonwunderlich.de>
 <20230127102133.700173-2-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230127102133.700173-2-sw@simonwunderlich.de>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fri, Jan 27, 2023 at 11:21:29AM CET, sw@simonwunderlich.de wrote:
>This version will contain all the (major or even only minor) changes for
>Linux 6.3.
>
>The version number isn't a semantic version number with major and minor
>information. It is just encoding the year of the expected publishing as
>Linux -rc1 and the number of published versions this year (starting at 0).

I wonder, what is this versioning good for?
