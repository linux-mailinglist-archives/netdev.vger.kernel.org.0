Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B584021173D
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 02:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726814AbgGBAfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 20:35:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726093AbgGBAfa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 20:35:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3774CC08C5C1;
        Wed,  1 Jul 2020 17:35:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A713314D45696;
        Wed,  1 Jul 2020 17:35:29 -0700 (PDT)
Date:   Wed, 01 Jul 2020 17:35:28 -0700 (PDT)
Message-Id: <20200701.173528.2292418258068703456.davem@davemloft.net>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        ka-cheong.poon@oracle.com, david.edmondson@oracle.com
Subject: Re: [PATCH v1] rds: If one path needs re-connection, check all and
 re-connect
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200701192338.11695-1-rao.shoaib@oracle.com>
References: <20200701192338.11695-1-rao.shoaib@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 Jul 2020 17:35:29 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rao.shoaib@oracle.com
Date: Wed,  1 Jul 2020 12:23:38 -0700

> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> In testing with mprds enabled, Oracle Cluster nodes after reboot were
> not able to communicate with others nodes and so failed to rejoin
> the cluster. Peers with lower IP address initiated connection but the
> node could not respond as it choose a different path and could not
> initiate a connection as it had a higher IP address.
> 
> With this patch, when a node sends out a packet and the selected path
> is down, all other paths are also checked and any down paths are
> re-connected.
> 
> Reviewed-by: Ka-cheong Poon <ka-cheong.poon@oracle.com>
> Reviewed-by: David Edmondson <david.edmondson@oracle.com>
> Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>

Applied.
