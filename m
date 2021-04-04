Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88D40353A29
	for <lists+netdev@lfdr.de>; Mon,  5 Apr 2021 01:45:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhDDXoK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 4 Apr 2021 19:44:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231643AbhDDXoI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 4 Apr 2021 19:44:08 -0400
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF55C061756
        for <netdev@vger.kernel.org>; Sun,  4 Apr 2021 16:44:02 -0700 (PDT)
Received: by mail-pl1-x62d.google.com with SMTP id h8so4849806plt.7
        for <netdev@vger.kernel.org>; Sun, 04 Apr 2021 16:44:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+wa9Ed4rEEf6nZw0uNl2cU76jMIPzLswHXHlLPF2vn4=;
        b=tcRFHoBn0bS89bE0t2ebRcf7KEKLdRcBc9hdqp2Sxn9OJ5zn0mIG/kMpTC6Gr7xk9p
         GVLS76APtOsT5ttgBEvjSzD2mWzPIzqm8IehpnMXKCCz9y4E6uTFdQlNZOiL1fhTvJ3w
         j0QsndSPqAmzSWbkEmX9IDsDwK/uwJ6jX45uXa3ThFi5x1pXfa3+4ZURtWiMSCbNt0/q
         vh+BsJY/DGCtrZTuWxkq4tvFD/mwW6/Oar1ItiRHARrrxgnvk21ufcMiT98ZcD3Yauzv
         cGiCmf5sy+OJbWAKCe/1PV3a3LWrQKraLRXrcW8SD+Y0vFBsFjRsUr6lQDcnAVazrMFe
         +Juw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=+wa9Ed4rEEf6nZw0uNl2cU76jMIPzLswHXHlLPF2vn4=;
        b=q20Wlj+NhMBzU2Z63UvOTpmwoIfQiTUZe9CVKhSQVpobKPhINBZeQXZc75SmrxAvvj
         nlcEtQrzePYy2JZ4rMOCJN3rGoYFEBILcGxzwhJyufWn6pLhxNvY5YG4GLoqocyjEpAL
         U/zY/zUqwOzT/7SCY3ZXqZda+qEr1PBf74aMvGdud7a3ccdNCmJxx8vk5OPtvyyzAyMG
         VnOL0wY3c1FGPZRpztcp5cxjcP+Jbg45zb3ttXHRewuvkAcynfRnJUk8SO+NOyUpFFhl
         09ekYfilRTv0A0OSW6JSlooWtX+JiLhlnbNtGjD9vw6A74NgKxbtgMztxAbOzWymp4pg
         gZNQ==
X-Gm-Message-State: AOAM5313rF1Jryk74YthUmYF2EK+OES+cmAxIm+0SfC1XqO7ljHxacey
        M39HleBH1Qpl/+KaMgBrCws=
X-Google-Smtp-Source: ABdhPJw/EdA5LaL0bYOitfJoOGMIzmnBKQ7vIR4FjSIIEOTK2z/B5UICI1G88swFHxKxz5IaG68OzQ==
X-Received: by 2002:a17:90a:e646:: with SMTP id ep6mr24415001pjb.101.1617579842257;
        Sun, 04 Apr 2021 16:44:02 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id 14sm13001116pgz.48.2021.04.04.16.44.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Apr 2021 16:44:01 -0700 (PDT)
Date:   Sun, 4 Apr 2021 16:43:59 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        drivers@pensando.io, Allen Hubbe <allenbh@pensando.io>
Subject: Re: [PATCH net-next 12/12] ionic: advertise support for hardware
 timestamps
Message-ID: <20210404234359.GE24720@hoboy.vegasvil.org>
References: <20210401175610.44431-1-snelson@pensando.io>
 <20210401175610.44431-13-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210401175610.44431-13-snelson@pensando.io>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 01, 2021 at 10:56:10AM -0700, Shannon Nelson wrote:
> Let the network stack know we've got support for timestamping
> the packets.

Actually, you already advertised the support to user space in Patch 10,
so this present patch should go before that one (or together).

Thanks,
Richard
