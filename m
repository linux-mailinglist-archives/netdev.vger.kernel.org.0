Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 301A420023E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 08:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729509AbgFSG4V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 02:56:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725778AbgFSG4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 02:56:20 -0400
Received: from mail-ed1-x52e.google.com (mail-ed1-x52e.google.com [IPv6:2a00:1450:4864:20::52e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A214C06174E
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 23:56:20 -0700 (PDT)
Received: by mail-ed1-x52e.google.com with SMTP id x93so6713241ede.9
        for <netdev@vger.kernel.org>; Thu, 18 Jun 2020 23:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xxZOYpHc/7cR5izoAzxqG3phWv6WD6NbgbQVWl706Ig=;
        b=Z2O46mXW8OzoGyhI6V7p2uZ+A/FCD7CUXXDsSGptKK4pV0qRrFlgAMRKFT65KakhL/
         kC1xIqg4K+rE9DRjN8lcD8PpeDZX7Ylpv6g9VNcLHLzCmfJ0mk/Mgn498rWkU1l4a36Q
         qNnCgiXacbnHiAH2YnYTHEUUg8NL+hxL9nUiQLhHQUS4R52kug4xFip1SBe0QIlkKfP4
         txPBnVAnBjPpNhW3HfeXPo8VyUQ+fNIXuoRfIRfBw67s7Mkqdmcw4y8cIvDVZfTBSZf6
         WGTzFs/8peykI0MWAa0pAGCIFezLEaZVmuRApIVXAEIxWtL/CJAy0eDyF2f5xXF4mq5K
         qTrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xxZOYpHc/7cR5izoAzxqG3phWv6WD6NbgbQVWl706Ig=;
        b=eB580XvhHNEznw2dnrfTrShRQ2KogyPB7GpPoc59BOU/OlS3se+d89wg5z32JvlAgM
         5B727ZeHvMKx84/sT048K00eeBbnmG3ilh/PTn+j569QwF4hVZkRiTBVU4+svMhlr+Vo
         mJsetpd7aJHfqvsKTBpXGn63SxBGjbuOA4gKSqpisvDemeqAmrgsF+uAszLfiPoGBLJq
         JzIbtpCWWOoy2DSNyQkORd0n3IfohKbt65YbLPnSbbFjYHsEiseKdQL8aPvb6kVtppcC
         9XaCE6kMWRAtwTflf55EvVLa+wXo1WsZ28L2fXlu/+Zn8LA6lx31lz2r9IifpBs5TbsT
         syng==
X-Gm-Message-State: AOAM530qmoiQ8Y22YRPxT2drObCGiOX2eKHHe61zeDhlVNLCHy/xVfyw
        t9ntJj1T26fRIHUVhjh7mqaqCzGCNrk=
X-Google-Smtp-Source: ABdhPJw3n8SiF6kSblJbVOht4kUrvGtLGW/Tlg8mn7NY2PxfCpyZKIxlTxYKke3gDxtOJmKoJUkboQ==
X-Received: by 2002:a05:6402:2070:: with SMTP id bd16mr1796620edb.35.1592549779295;
        Thu, 18 Jun 2020 23:56:19 -0700 (PDT)
Received: from netronome.com ([2001:982:7ed1:403:9eeb:e8ff:fe0d:5b6a])
        by smtp.gmail.com with ESMTPSA id h9sm3877803edr.65.2020.06.18.23.56.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 23:56:18 -0700 (PDT)
Date:   Fri, 19 Jun 2020 08:56:18 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, Lucas Bates <lucasb@mojatatu.com>,
        David Miller <davem@davemloft.net>,
        Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCHv2 net] tc-testing: update geneve options match in
 tunnel_key unit tests
Message-ID: <20200619065617.GB9312@netronome.com>
References: <20200618083705.449619-1-liuhangbin@gmail.com>
 <20200619032445.664868-1-liuhangbin@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200619032445.664868-1-liuhangbin@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 19, 2020 at 11:24:45AM +0800, Hangbin Liu wrote:
> Since iproute2 commit f72c3ad00f3b ("tc: m_tunnel_key: add options
> support for vxlan"), the geneve opt output use key word "geneve_opts"
> instead of "geneve_opt". To make compatibility for both old and new
> iproute2, let's accept both "geneve_opt" and "geneve_opts".
> 
> Suggested-by: Davide Caratti <dcaratti@redhat.com>
> Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>

Reviewed-by: Simon Horman <simon.horman@netronome.com>
