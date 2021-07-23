Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412FC3D36FD
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 10:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234481AbhGWIFz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Jul 2021 04:05:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234311AbhGWIFx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Jul 2021 04:05:53 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D2B1C061575;
        Fri, 23 Jul 2021 01:46:26 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id b128so338430wmb.4;
        Fri, 23 Jul 2021 01:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wP58BWHJk0d3nGHHsfR2vMWROBgy2cE47/0AZMdiKNY=;
        b=j9E8c4ZxbPa6p4eyuVWDhqLVgm3wo8FZ3+pGJfW0AIpMmPG/fJUAdX1URuKCMY7XF2
         UcRtcXHGIQQz5OclO41kVBiNVPbTfGqB3pm2sSqJeLVEQcnpANDKuWsvnrAxAiFCAw6N
         lruMUSsiVjox4yvH40vnBaixvHPKRg1osnBLQ9iieO97mm9fUffe/7/N+eoJttomSAkl
         0KQNT8xOEiTprjaUOhhXO2GaD325Jl6uQicgnBI6EB63LCrjHwv4UwUUJw2P3z0U0E8N
         rA4sGBBSjtKhl+HBg7FTqxS5f5MsOtHsyIgD0idmtw6HNjStvfTG4NPRUxumgikYeMyN
         XMjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wP58BWHJk0d3nGHHsfR2vMWROBgy2cE47/0AZMdiKNY=;
        b=nwEIe3K5k48VdE9i4aRXBcCITvEX7JrEfVp80RjCPjrCNfWYrRYifFDY9gYZPkP+aR
         D+4RSzGicHLS/AMIhPY40GUL4laSQ7RR6Yh1OFjaI4M7WTHjGWO8WIxfBTmpkqkWu+Vj
         NKgD94j4FZvmb7yp8oBjv4tLViltsWhVFJXtB0NNVyrI6gyHKUErG+IHmc9xsOr1a44D
         saX03kY0iZx76CWKgj0cZehJ98/EkduSHLHNlhivgKEM+rMS+LB37H2FQ6xqjTl77F+U
         Hv3K3ahuDx8DwGxLIxiVOccbBmsao+R4BbPW349cYKFLaeHTNrYr+IkMakssITgiZbWH
         qSyw==
X-Gm-Message-State: AOAM531cTJVcd34e258aS3OPfOFxCN/EdPSKIq5eTvA6GdVe5MwP5RnV
        rvbet8ODARjvcQiGExncuno=
X-Google-Smtp-Source: ABdhPJx3UO82ie5uoGB0Og4LKefXGXB0MCFpgWtgw1Gwo2zcikynw6LvEKoW8T/LygMjHstyNwkKJA==
X-Received: by 2002:a1c:e90d:: with SMTP id q13mr3362585wmc.163.1627029984837;
        Fri, 23 Jul 2021 01:46:24 -0700 (PDT)
Received: from skbuf ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id o18sm32229095wrx.21.2021.07.23.01.46.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jul 2021 01:46:24 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
X-Google-Original-From: Ioana Ciornei <ciornei.ioana@gmail.com>
Date:   Fri, 23 Jul 2021 11:46:23 +0300
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: Re: [PATCH net-next v2] docs: networking: dpaa2: add documentation
 for the switch driver
Message-ID: <20210723084623.jgc2rkdivzklsakr@skbuf>
References: <20210723084244.950197-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210723084244.950197-1-ciorneiioana@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 23, 2021 at 11:42:44AM +0300, Ioana Ciornei wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> Add a documentation entry for the DPAA2 switch listing its
> requirements, features and some examples to go along them.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---

Sorry, forgot to list the changes made in v2.

Changes in v2:
 - listed the error messages given by the driver when requirements are
   not met
 - removed implementation details
 - expanded the tc filter block example with multiple rules

