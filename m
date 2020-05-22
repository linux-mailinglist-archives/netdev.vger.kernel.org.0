Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9270F1DDB8B
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 02:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730160AbgEVADl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 20:03:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730068AbgEVADl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 May 2020 20:03:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 855B4C061A0E
        for <netdev@vger.kernel.org>; Thu, 21 May 2020 17:03:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5EE21120ED482;
        Thu, 21 May 2020 17:03:40 -0700 (PDT)
Date:   Thu, 21 May 2020 17:03:39 -0700 (PDT)
Message-Id: <20200521.170339.2108091665389383456.davem@davemloft.net>
To:     idosch@idosch.org
Cc:     netdev@vger.kernel.org, kuba@kernel.org, jiri@mellanox.com,
        danieller@mellanox.com, mlxsw@mellanox.com,
        michael.chan@broadcom.com, jeffrey.t.kirsher@intel.com,
        saeedm@mellanox.com, leon@kernel.org, snelson@pensando.io,
        drivers@pensando.io, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, idosch@mellanox.com
Subject: Re: [PATCH net-next 0/3] devlink: Add port width attribute
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200519134032.1006765-1-idosch@idosch.org>
References: <20200519134032.1006765-1-idosch@idosch.org>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 21 May 2020 17:03:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Honestly, width is completely ambiguous in this situation to me.

Width doesn't mean anything without an accompanying unit of measure
and in this situation it's one lane.
