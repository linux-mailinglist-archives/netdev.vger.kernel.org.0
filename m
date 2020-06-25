Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C73420A8D3
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 01:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407816AbgFYX0p convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 25 Jun 2020 19:26:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390973AbgFYX0m (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 19:26:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A778C08C5C1;
        Thu, 25 Jun 2020 16:26:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 39736154CEC44;
        Thu, 25 Jun 2020 16:26:42 -0700 (PDT)
Date:   Thu, 25 Jun 2020 16:26:41 -0700 (PDT)
Message-Id: <20200625.162641.1460713778895823529.davem@davemloft.net>
To:     rao.shoaib@oracle.com
Cc:     linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        leon@kernel.org, ka-cheong.poon@oracle.com,
        haakon.bugge@oracle.com, somasundaram.krishnasamy@oracle.com
Subject: Re: [PATCH v2] rds: transport module should be auto loaded when
 transport is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625204600.24174-1-rao.shoaib@oracle.com>
References: <20200625204600.24174-1-rao.shoaib@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 16:26:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rao.shoaib@oracle.com
Date: Thu, 25 Jun 2020 13:46:00 -0700

> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> This enhancement auto loads transport module when the transport
> is set via SO_RDS_TRANSPORT socket option.
> 
> Reviewed-by: Ka-Cheong Poon <ka-cheong.poon@oracle.com>
> Reviewed-by: Håkon Bugge <haakon.bugge@oracle.com>
> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
> Signed-off-by: Somasundaram Krishnasamy <somasundaram.krishnasamy@oracle.com>

Applied, thanks.
