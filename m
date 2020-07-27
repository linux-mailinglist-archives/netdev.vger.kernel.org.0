Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293F722FE20
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 01:44:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726311AbgG0XoO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 19:44:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726091AbgG0XoN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 19:44:13 -0400
Received: from mail-pf1-x442.google.com (mail-pf1-x442.google.com [IPv6:2607:f8b0:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B182EC061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:44:13 -0700 (PDT)
Received: by mail-pf1-x442.google.com with SMTP id r11so2048557pfl.11
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 16:44:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QyVytWvP5KLtIn2y4677Q6IOpWt+cBbP3NK8S1zonJU=;
        b=KE0gHhReqDjneTqq4kndfyuukkFvnqNX2c6Li4jxwd861+FgZlN1YcIPF4dF8rNMX9
         wtiRQ8c58DNZSkrGxq14Yg+J0PaXI9o6OV05uMmXF7c0flkBVPV4tV9i7UL28XvpMESk
         29xbhL/Qkh6HnyEXgdf2ZoxP3opVDcOQGWfWWSN/Gpdil7EBKbe4+vqYjdmr1a0/ph/V
         3cTu0Gv53rTV5kYF0HUqbDuO/LPfxds6sW770o2W3UDssaiEAe7G+A0xVyDDGvo7/eDW
         0pV3KL3d/VbYrTYYJVLF0uZ0QJ/BvQLrasfYTQ9abxJOxUVvd35rY2bSWtVsG4TWhDn2
         8LgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QyVytWvP5KLtIn2y4677Q6IOpWt+cBbP3NK8S1zonJU=;
        b=EQZywiH2pheYCA3rfV/6rYFLGWP7Ki2Ruowapac4R2GLyTyaDn0Jt0coblp8YaVuda
         odHZUgMCKqCnvWG4hkY8G1Cngr9ygzhHHCVJ7PWTeoh+wX4u3gMyBjxXQk30fEJ27l8w
         wHu5mteEnXhjIkOmxzQtiLLjmVWxiponQ8HBusWonSLJMKt9riKoydizLLRVojFuxIyC
         nHYCH/fkDG1hl5EPj83bYfnqZuqxQXnXBbqEHhqyf/IOt0Jdm66wwVy+9Gnr0iridJ7t
         3iy0e3MkYFCO2Ixltf4T0CJejVpbU+rY0zZZEIPgZ0A72WwBJa/RP9XIz/5H36oU7YeY
         ZLrw==
X-Gm-Message-State: AOAM531XruiV+dlHQpNaZKGlf6fVhZ6ZjtnHq42FZiYnY2S8fCVnSeeP
        BKERevU0H3Ca1PyR3gxolTqjZQ9zj11xCw==
X-Google-Smtp-Source: ABdhPJwN57HV3KrZ4P/g9pHiXJjketyi2oepuyavLCEnIvUimjMRNzqUFVxkuL5DdlIemVfb/eNTJQ==
X-Received: by 2002:a05:6a00:10:: with SMTP id h16mr21996907pfk.214.1595893453243;
        Mon, 27 Jul 2020 16:44:13 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id q83sm5730223pfc.31.2020.07.27.16.44.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 16:44:12 -0700 (PDT)
Date:   Mon, 27 Jul 2020 16:44:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     netdev@vger.kernel.org, mptcp@lists.01.org
Subject: Re: [PATCH iproute2] mptcp: show all endpoints when no ID is
 specified
Message-ID: <20200727164404.05fc033f@hermes.lan>
In-Reply-To: <20200724121718.2180511-1-matthieu.baerts@tessares.net>
References: <20200724121718.2180511-1-matthieu.baerts@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Jul 2020 14:17:18 +0200
Matthieu Baerts <matthieu.baerts@tessares.net> wrote:

> According to 'ip mptcp help', 'endpoint show' can accept no argument:
> 
>   ip mptcp endpoint show [ id ID ]
> 
> It makes sense to print all endpoints when no filter is used.
> 
> So here if the following command is used, all endpoints are printed:
> 
>   ip mptcp endpoint show
> 
> Same as:
> 
>   ip mptcp endpoint
> 
> Fixes: 7e0767cd ("add support for mptcp netlink interface")
> Signed-off-by: Matthieu Baerts <matthieu.baerts@tessares.net>

Applied thanks
