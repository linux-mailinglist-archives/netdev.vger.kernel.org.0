Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47341D062F
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 06:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfJIEBp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Oct 2019 00:01:45 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:39691 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725440AbfJIEBp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Oct 2019 00:01:45 -0400
Received: by mail-pf1-f193.google.com with SMTP id v4so707917pff.6
        for <netdev@vger.kernel.org>; Tue, 08 Oct 2019 21:01:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=LQnEVRtaUqRdx8oq4nHL7TuP7CnswhfMj0UbudJCkNo=;
        b=elH8HvTNX73YFmnB2dy01hY2j2bmSz5xAhWehg02ST0i0DmEY52fPhAOVzsGHakA94
         b1FhyrN440t4SYfzDRf1FG24HhmGXBFl43fxRtB+oh8NYyP/nQrvm2NzmBpRAVEtUXbP
         hmA4ib31/2K8MCcdlZ4iFILk23DO1jyJcz4XziEq2lmyjwBV8vD9KUcTmS7wybgRvaH2
         8kWYM+qq3hpsqV7w9qfRn1k9FrsghbSwcRLJCprjs+OKRJpIZfVeZMOccRsiFPgJoKjH
         GxeXKz0p006gobdoqKwWIdrMGyv6UdONE4Jt7PTkd9l8UYiEXroANR8cl/2PpcUr6QZM
         h7mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=LQnEVRtaUqRdx8oq4nHL7TuP7CnswhfMj0UbudJCkNo=;
        b=YqAjMpVM1Cqz/jYA1+40gBx5BLFSJ372kJ2JJQ24K21reO6ztOvXx5b7MkeX0FZlv4
         2AkUbLQW+rlIo/xcJLquMNt8G/NorFvqnSnuuug2uKk91t1huPh5Xpz83vUsplxI1xEj
         cFiE5LDwLhkpYGWTeYuUVYGk6mYGXUausEfTli5950bo+cjQxQNbEeAgtnRxqASv4zyI
         +I5gzPlWJDusJ6s2ESoFKQoLrxubco5nHlbfYBwiaTL4IoNbPaUs3g7yJakYWe0MAafp
         CHTuc6XauGvD25RJU+83+5T05WdfPqRc+QQdr3F5ts5XELvDZm6VPS3BbcprGoAs2kOe
         IRVw==
X-Gm-Message-State: APjAAAUXvLjDX6U/h+q6nKTijbo41GaxwK433qX9yrkSXmsTpVlIS5vL
        NWtoL+65T7WDNpioIed2Ai0OIA==
X-Google-Smtp-Source: APXvYqwuZLt3V1q9u6j2hKZR6SsGo068c0h+BS63ge6a8qYenR1qWOrmO6OPDIlDK5m5u0HufiABbQ==
X-Received: by 2002:a17:90a:ff0f:: with SMTP id ce15mr1710745pjb.14.1570593703973;
        Tue, 08 Oct 2019 21:01:43 -0700 (PDT)
Received: from cakuba.netronome.com (c-73-202-202-92.hsd1.ca.comcast.net. [73.202.202.92])
        by smtp.gmail.com with ESMTPSA id w2sm611444pfn.57.2019.10.08.21.01.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Oct 2019 21:01:43 -0700 (PDT)
Date:   Tue, 8 Oct 2019 21:01:30 -0700
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Madalin Bucur <madalin.bucur@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roy.pledge@nxp.com,
        laurentiu.tudor@nxp.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/20] DPAA fixes
Message-ID: <20191008210130.23f8a123@cakuba.netronome.com>
In-Reply-To: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
References: <1570536641-25104-1-git-send-email-madalin.bucur@nxp.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  8 Oct 2019 15:10:21 +0300, Madalin Bucur wrote:
> Here's a series of fixes and changes for the DPAA 1.x drivers.
> Fixing some boot time dependency issues, removing some dead code,
> changing the buffers used for reception, fixing the DMA devices,
> some cleanups.

Hi Madalin!

The title of this series says "DPAA fixes", are these bug fixes?
If so they should target the net tree ([PATCH net]) and contain
appropriate Fixes tags.

Cleanups should go into the net-next tree ([PATCH net-next]).

Please try to not post more than 15 patches in one series, it clogs 
up the review flow.

For some of those and other best practices please see:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html
https://www.kernel.org/doc/html/latest/process/submitting-patches.html

:)

IMHO there is also no need at all to CC linux-kernel on networking patches..
