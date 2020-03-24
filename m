Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05078190401
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 04:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgCXD4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 23:56:25 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55856 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727060AbgCXD4Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Mar 2020 23:56:25 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 75D81154F6F1D;
        Mon, 23 Mar 2020 20:56:24 -0700 (PDT)
Date:   Mon, 23 Mar 2020 20:56:23 -0700 (PDT)
Message-Id: <20200323.205623.1265436639422315541.davem@davemloft.net>
To:     olteanv@gmail.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        vivien.didelot@gmail.com
Subject: Re: [PATCH net 0/3] Bugfix, simplification and cleanup in DSA
 tag_8021q
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200320000051.28548-1-olteanv@gmail.com>
References: <20200320000051.28548-1-olteanv@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 23 Mar 2020 20:56:24 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Fri, 20 Mar 2020 02:00:48 +0200

> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series removes the dsa_8021q_remove_header and dsa_8021q_xmit
> functions and replaces them with saner implementations, thereby
> redefining what the tag_8021q module has to offer (at the moment, just
> the VLAN definitions and install/uninstall rules remain).

Two of the three things you list in your Subject line are not appropriate
for "net", that being simplifications and cleanups.

Bug fixes for 'net' are fine, the rest go to 'net-next'.
