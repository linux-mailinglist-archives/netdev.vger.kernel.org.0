Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E02DB1BCD3E
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 22:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbgD1UPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 16:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726318AbgD1UPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Apr 2020 16:15:02 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25C24C03C1AC;
        Tue, 28 Apr 2020 13:15:02 -0700 (PDT)
Received: from lwn.net (localhost [127.0.0.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 616212D6;
        Tue, 28 Apr 2020 20:15:01 +0000 (UTC)
Date:   Tue, 28 Apr 2020 14:15:00 -0600
From:   Jonathan Corbet <corbet@lwn.net>
To:     David Miller <davem@davemloft.net>
Cc:     mchehab+huawei@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-hams@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        linux-decnet-user@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, bpf@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, lvs-devel@vger.kernel.org
Subject: Re: [PATCH 00/38] net: manually convert files to ReST format - part
 1
Message-ID: <20200428141500.7ff1e82b@lwn.net>
In-Reply-To: <20200428.131143.378850463944291442.davem@davemloft.net>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
        <20200428.131143.378850463944291442.davem@davemloft.net>
Organization: LWN.net
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Apr 2020 13:11:43 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> Jon, do you mind if I merge this via the networking tree?

Not at all, that's what I was expecting you would do.

Thanks,

jon
