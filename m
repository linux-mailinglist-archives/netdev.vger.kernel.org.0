Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0242048DE05
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 20:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237859AbiAMTKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 14:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237853AbiAMTKN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Jan 2022 14:10:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AE78C061574;
        Thu, 13 Jan 2022 11:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D54161D3F;
        Thu, 13 Jan 2022 19:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AB0CC36AEB;
        Thu, 13 Jan 2022 19:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642101011;
        bh=mDkV0+0LoJMZROFw0QWyf8e4iQci/VWjWhc7T3wuhFw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TYF4Jcc+5i0wp/4N9fUKZvusoy7FwXAYe3FyFjc6lVXFS1LyBneXgkutysIJdUX/x
         H7Y8NWmhfMYcjGBlmDRP3sE3Vml362xTlIqdUWu31d0fDUuhebRR64p/YFye30awSE
         D5Urh6SgVRyFm5jWin6u/Cy6AfGDOrZxW9mtPAkq2HW4mfirb8JvRYzdBOeZmAi5K2
         HKKfdhkx1iIZKhxfCWwwX6P+i9JMkAX+VAAhgxW/RutlPS56OKmm4TOdi4YXiBZ3lF
         GecKdHwllsMfib9jS128+ITYdEVhie4nbM/RbDQfe763J7tSvDn1lnvMzYZC+vpGFo
         7uSSLPnhBk6yQ==
Date:   Thu, 13 Jan 2022 11:10:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wen Gu <guwen@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net,
        linux-s390@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2 0/3] net/smc: Fixes for race in smc link group
 termination
Message-ID: <20220113111010.3d4c5f4c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
References: <1642063002-45688-1-git-send-email-guwen@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 13 Jan 2022 16:36:39 +0800 Wen Gu wrote:
> We encountered some crashes recently and they are caused by the
> race between the access and free of link/link group in abnormal
> smc link group termination. The crashes can be reproduced in
> frequent abnormal link group termination, like setting RNICs up/down.
> 
> This set of patches tries to fix this by extending the life cycle
> of link/link group to ensure that they won't be referred to after
> cleared or freed.

Looks applied, thanks.
