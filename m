Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855A8196141
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:35:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727910AbgC0WfI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:35:08 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:40140 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727781AbgC0WfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:35:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5759715BB51D8;
        Fri, 27 Mar 2020 15:35:06 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:35:03 -0700 (PDT)
Message-Id: <20200327.153503.880515420927730742.davem@davemloft.net>
To:     vasundhara-v.volam@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH v4 net-next 0/6] bnxt_en: Updates to devlink info_get cb
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
References: <1585301692-25954-1-git-send-email-vasundhara-v.volam@broadcom.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Mar 2020 15:35:06 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Date: Fri, 27 Mar 2020 15:04:50 +0530

> This series adds support for a generic macro to devlink info_get cb.
> Adds support for fw.mgmt.api and board.id info to bnxt_en driver info_get
> cb. Also, updates the devlink-info.rst and bnxt.rst documentation
> accordingly.
> 
> This series adds a patch to fix few macro names that maps to bnxt_en
> firmware versions.
> 
> ---
> v1->v2: Remove ECN dev param, base_mh_addr and serial number info support
> in this series.
> Rename drv.spec macro to fw.api.
> ---
> v2->v3: Remove hw.addr info as it is per netdev but not per device info.
> ---
> v3->v4: Rename "fw.api" to "fw.mgmt.api".
> Also, add a patch that modifies few macro names in info_get command,
> to match the devlink documentation.

Series applied, thank you.
