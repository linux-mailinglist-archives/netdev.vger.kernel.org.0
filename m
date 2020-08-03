Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC91823A8A3
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 16:38:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726622AbgHCOiY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 10:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726358AbgHCOiY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 10:38:24 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6B4C06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 07:38:23 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id l64so28481133qkb.8
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 07:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eLsoD3nOKroZjTDpbVBx61noxn5TAWz7GUQ4chzXjtA=;
        b=Bza/QnhIDpTpyDMcJn3ErMwchYpiz90CAF5292YqYnQnTnAKmjrzn2OAhPeLXfXYUs
         nifiPsG5hX8MnqlAOIPK+ODV9UEryBOp3AxY//SsN8dS8gBdvpAAOZ9EUgulCKj8myar
         lVbJMONmwIFRXPBnb99ZGuehK4M/uiQ2drQ4V/BdDyoW/alMVCUBeLcoTLso/P0nH9ZK
         n41g+Aydt3xJYhQY6xpR0gfXV3eRjuGZMkb4LzHkbHg7+SdFahqWMLdfoG7+6curgMKS
         lMgp9UCBdvGKLcbYU2XP/YySyRemoRSpsU1SNlTWKaszOJqE47u7F0YOpgJEVC5WC7DA
         Pz7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eLsoD3nOKroZjTDpbVBx61noxn5TAWz7GUQ4chzXjtA=;
        b=pqHF93IDowFsxkUHQW/igNnRF4wefW70/TY0WVaOU89At4VyDg/9gZKm7xgWDxpzO4
         ++LZ+9PV8cHD3Nnv+cJ3pQo47fE/I9uHCwpPQ6x4i4UFm10XlYQk7a5ZzBQYP1N4GCDB
         Lqq4qt+Fr5EzKesr0zi1CCkIUFO6z5DpqLM2HgvIaghxrircM6HU54gZQA8XrsKcZycB
         wJwGOS5l1pvSzaKOmmYvefahileZu++kqm/wmeHk6POrazV31NOArIgtSEcFEBWZD0YT
         VwbZ0BwG/oKzls8MJ1MX2LROaE7G1Q/W1mNj9+FVIDGnvF7daQjn4HaDrIY6ICBH99Dr
         YuZA==
X-Gm-Message-State: AOAM531gcUqVi49AEgGnIslpVxA934bTTwEV2Hp6JgKH6eJNKxojLK51
        8xUaLoam8vs9lenUYtb+Pvc=
X-Google-Smtp-Source: ABdhPJy+EbsHRKl4wv21kFcbno3Rg+VWmZBsHbudA8Sctx10S6fb3q0pKutPOmAuK1bM5uaDR8bw5g==
X-Received: by 2002:a05:620a:164b:: with SMTP id c11mr15973714qko.91.1596465503131;
        Mon, 03 Aug 2020 07:38:23 -0700 (PDT)
Received: from ?IPv6:2601:284:8202:10b0:989f:23de:f9a0:6da? ([2601:284:8202:10b0:989f:23de:f9a0:6da])
        by smtp.googlemail.com with ESMTPSA id r6sm21302831qtu.93.2020.08.03.07.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 07:38:21 -0700 (PDT)
Subject: Re: [PATCH iproute2-next v2 0/2] Expose port attributes
To:     Danielle Ratson <danieller@mellanox.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@mellanox.com
References: <20200730143318.1203-1-danieller@mellanox.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <8e5fd6b1-33e6-2f04-d256-1dabf83b6d4c@gmail.com>
Date:   Mon, 3 Aug 2020 08:38:20 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200730143318.1203-1-danieller@mellanox.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/30/20 8:33 AM, Danielle Ratson wrote:
> Add two new devlink port attributes:
> - Lanes: indicates the number of port lanes.
> - Splittable: indicates the port split ability.
> 
> Patch 1: Update kernel headers
> Patch 2: Expose number of lanes
> 
> v2: *Update 'devlink_policy' with the new attributes
> 
> Danielle Ratson (2):
>   devlink: Expose number of port lanes
>   devlink: Expose port split ability
> 
>  devlink/devlink.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

applied to iproute2-next. Thanks,
