Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4BD596E21A
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 09:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726984AbfGSH67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 03:58:59 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33119 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726067AbfGSH65 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jul 2019 03:58:57 -0400
Received: by mail-wr1-f67.google.com with SMTP id n9so31334899wru.0
        for <netdev@vger.kernel.org>; Fri, 19 Jul 2019 00:58:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hn8k2A65dilO4W6wC7myYDo4rFD7/Qcux+ME0/hjHjU=;
        b=g/s0V6BoWaNQDWOru0RFzNqFYCtYTjVd2ZoiSaCF+cVxsoaFEpDUoUky2Wft4czHmD
         N7fC6JBTDWfUQZD8bYzNIPc1wkn/gxx9ayl7dJte/IRM0j0kFwLc9jFZWGoit13jwhLX
         SNBI5QeuxqN8L41Bz9HfkSbPeEoZa3GhuO+BPPWVttXdosRKhfqISopzDepUidzM9A+B
         9sYwwTj4KoLy9KwPQ1O3kiO2u1tC8h/XQeFoktTk18vnWcCyeA5oSuxVVvHavAox4hD2
         teA64lDxclzY0OfNPU6vGqlnImuuK4xpzCofzgT9T8ukdtBRwC3ycOkNaqVo9dvFyE2P
         hANg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=hn8k2A65dilO4W6wC7myYDo4rFD7/Qcux+ME0/hjHjU=;
        b=gvhj0aICHJ8BveE1wwNGdCKAzpdC8yi6JJKefMVLYorP9kt3+v4Ubr6j0QDC84mrEP
         MAViPzo16VrW5uxBZJLfOsr6RaHE++AQ8HR4yyvs4Em08XHxyMNA76TUo5r2OgUi7UiC
         lTULdQDn/bqUcwj5SlUkCaTCn6MewvfLt7YhAsGdcW3YQbbQJ+/kiJPE8dUcrVN8cFhi
         6Ll7bmYAvkObxLSIhErmxbiHJ9dvObFTOoSPyEZ1jaUL6d1146EEdQcasUlfJu2cyYG0
         uf/x3gAywrpiBBWxnKUTtTIam4aKFBVkXMU5KcZ1CgaaHlXa52RBKrwnrWf8Rt6Ky5y+
         Tt8w==
X-Gm-Message-State: APjAAAVX+I48cKflPm07SWfZ/O/06Erdih3ApizWv4PXyNTzJcyJdS8i
        WkWE+0AnNUw9adf9jVZ6Zsk=
X-Google-Smtp-Source: APXvYqwM8EGoOThk10L1KP0rUSHp+FUWBbzIAOcGAxOrXj0zNJYb4fI/VWKR5RburezbclHwRwOr6g==
X-Received: by 2002:a5d:6a90:: with SMTP id s16mr45507879wru.288.1563523135383;
        Fri, 19 Jul 2019 00:58:55 -0700 (PDT)
Received: from localhost (ip-62-24-94-150.net.upcbroadband.cz. [62.24.94.150])
        by smtp.gmail.com with ESMTPSA id g8sm27547100wmf.17.2019.07.19.00.58.54
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 19 Jul 2019 00:58:54 -0700 (PDT)
Date:   Fri, 19 Jul 2019 09:58:53 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        pshelar@ovn.org
Subject: Re: [PATCH net,v4 1/4] net: openvswitch: rename flow_stats to
 sw_flow_stats
Message-ID: <20190719075853.GB2230@nanopsycho>
References: <20190718175931.13529-1-pablo@netfilter.org>
 <20190718175931.13529-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190718175931.13529-2-pablo@netfilter.org>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, Jul 18, 2019 at 07:59:28PM CEST, pablo@netfilter.org wrote:
>There is a flow_stats structure defined in include/net/flow_offload.h
>and a follow up patch adds #include <net/flow_offload.h> to
>net/sch_generic.h.
>
>This breaks compilation since OVS codebase includes net/sock.h which
>pulls in linux/filter.h which includes net/sch_generic.h.
>
>In file included from ./include/net/sch_generic.h:18:0,
>                 from ./include/linux/filter.h:25,
>                 from ./include/net/sock.h:59,
>                 from ./include/linux/tcp.h:19,
>                 from net/openvswitch/datapath.c:24
>
>This definition takes precedence to OVS since it is placed in the
>networking core, so rename flow_stats in OVS to sw_flow_stats since
>this structure is contained in the sw_flow object.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
