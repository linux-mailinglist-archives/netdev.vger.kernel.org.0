Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5EDAE6E22E
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 10:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726663AbfGSIBI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 04:01:08 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:45694 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726076AbfGSIBI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 04:01:08 -0400
Received: by mail-wr1-f66.google.com with SMTP id f9so31242203wre.12
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 01:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w1ekx0Whjc70X9EHRUdvyi9C9KHDsQu98PqfbPr/bGs=;
        b=Qhjw7ZJSPvdObZzE4cD0oK2pXS3jEIQwC/omTVErYrZD99fqTaIua/H9QAR1vQUntp
         uBK0/M/4clutNBHN6+76MDaOrhz/rllLhZ4BCgWUEB2XExxfUwC009lXtTjjwhmQLoOV
         HhWcXLJ254XnPloic9LGfOEHWvtwX+R8smQ+96SvGB8hOwidu32QfeiVT2KyYpadJVGZ
         WLtulBhuF1AtUmL8vLqFz/lhvSo+2eDmnv49sMvTw+Iq5NvPgLHAYy8Z2nq6L1+jTGk/
         Xe9Zl+I2ByK7qKCKqk1DNZiLi7yRxma+55TP323hd82UiBc89ryD2x5WU3+INPdgLyKg
         ZVOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w1ekx0Whjc70X9EHRUdvyi9C9KHDsQu98PqfbPr/bGs=;
        b=gzEqXpEEKzo1OsjLBMr14qzNOryhUb3vx5AyJS2dudJeET4t1BYM6PJ9L3hQRC0Pas
         mA5HQcrIpcw16laIm/FPMRzwx8oirjdfpNUD4mGqjZK45/wYPG9ndBW6V1YLlnqZmnik
         j9HU7+dZZNDl2Jt0Uo/gmeES36SC96XF5SBLaPur4H1+IiPhfBhmVLo6GPv452xfJsq1
         symF4PSmjeUSgs+IuMrNATCgdqTlXPaQZmKsg8GA6Yc8W7WIeV6QtbS4fSJV1X51WASQ
         QkzjGWvT3F3H0uqwP7lOBBwbwFe5B2KesY5e4OPRUt30ehgqAHdjZh33PUDcSZW+ipaJ
         EkwA==
X-Gm-Message-State: APjAAAU/EYlgRomcfMr/hJCn4McUcbqwbr8adtTtCuEQpfYR8fHCe94E
        FozccQCPU3VAIPoNUxCagm8=
X-Google-Smtp-Source: APXvYqzIZ+37rAy8w3si0PC2zjPhhQUX7DvNsEY4Bw4zHwOqQzM2Qx84n3WVlbPn254RIws++WCHkw==
X-Received: by 2002:a5d:5348:: with SMTP id t8mr52942933wrv.159.1563523266469;
        Fri, 19 Jul 2019 01:01:06 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id g12sm38848990wrv.9.2019.07.19.01.01.05
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 01:01:06 -0700 (PDT)
Date:   Fri, 19 Jul 2019 10:01:05 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        pshelar@ovn.org
Subject: Re: [PATCH net,v4 4/4] net: flow_offload: add flow_block structure
 and use it
Message-ID: <20190719080105.GC2230@nanopsycho>
References: <20190718175931.13529-1-pablo@netfilter.org>
 <20190718175931.13529-5-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718175931.13529-5-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 18, 2019 at 07:59:31PM CEST, pablo@netfilter.org wrote:
>This object stores the flow block callbacks that are attached to this
>block. Update flow_block_cb_lookup() to take this new object.
>
>This patch restores the block sharing feature.
>
>Fixes: da3eeb904ff4 ("net: flow_offload: add list handling functions")
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
