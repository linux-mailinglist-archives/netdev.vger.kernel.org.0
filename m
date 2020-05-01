Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11F741C20CA
	for <lists+netdev@lfdr.de>; Sat,  2 May 2020 00:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726473AbgEAWiz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 May 2020 18:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726045AbgEAWiy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 May 2020 18:38:54 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D95CAC061A0C
        for <netdev@vger.kernel.org>; Fri,  1 May 2020 15:38:54 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9073F14F9903A;
        Fri,  1 May 2020 15:38:54 -0700 (PDT)
Date:   Fri, 01 May 2020 15:38:53 -0700 (PDT)
Message-Id: <20200501.153853.168779057910060484.davem@davemloft.net>
To:     irusskikh@marvell.com
Cc:     netdev@vger.kernel.org, mstarovoitov@marvell.com
Subject: Re: [PATCH v2 net-next 00/17] net: atlantic: A2 support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200430080445.1142-1-irusskikh@marvell.com>
References: <20200430080445.1142-1-irusskikh@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 01 May 2020 15:38:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Igor Russkikh <irusskikh@marvell.com>
Date: Thu, 30 Apr 2020 11:04:28 +0300

> This patchset adds support for the new generation of Atlantic NICs.
> 
> Chip generations are mostly compatible register-wise, but there are still
> some differences. Therefore we've made some of first generation (A1) code
> non-static to re-use it where possible.
> 
> Some pieces are A2 specific, in which case we redefine/extend such APIs.
> 
> v2:
>  * removed #pragma pack (2 structures require the packed attribute);
>  * use defines instead of magic numbers where possible;
> 
> v1: https://patchwork.ozlabs.org/cover/1276220/

Series applied.

Please follow up with a patch that makes the new structures use
"__packed" instead of the full expanion.

Thanks.
