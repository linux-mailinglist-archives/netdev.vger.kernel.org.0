Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DB0644310
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 13:23:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiLFMXL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 07:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233790AbiLFMXK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 07:23:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A9C928E15;
        Tue,  6 Dec 2022 04:23:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BA9BD616E9;
        Tue,  6 Dec 2022 12:23:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93665C433C1;
        Tue,  6 Dec 2022 12:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670329387;
        bh=rc0MuXDCk2pVMyz/1p6QSkujd3jizl3f8KDAag+hfMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GHtqKtf/V7sOexjUfEJ2bIzf5lk+/Ea8LiNgoQ9xvI9zrPm9+FCZXg2bZRycxnIfA
         NKZCO9O8cXj8wO6UXWPl7GJskEn1D/8l6SY9UjkJlKDdawcBI/WZdL8zoyHEi2wLmv
         w3iwY40ApJdw+p1MQtBLVbiX9G3pvc9kG7AEoYks=
Date:   Tue, 6 Dec 2022 13:23:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, stable@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 net  1/2] vmxnet3: correctly report encapsulated LRO
 packet
Message-ID: <Y480KNm16LkG4JX5@kroah.com>
References: <20221205224256.22830-1-doshir@vmware.com>
 <20221205224256.22830-2-doshir@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221205224256.22830-2-doshir@vmware.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Dec 05, 2022 at 02:42:54PM -0800, Ronak Doshi wrote:
> Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support") added support for encapsulation offload. However, the
> pathc did not report correctly the encapsulated packet which is
> LRO'ed by the hypervisor.
> 
> This patch fixes this issue by using correct callback for the LRO'ed
> encapsulated packet.
> 
> Fixes: dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload support")
> Signed-off-by: Ronak Doshi <doshir@vmware.com>
> Acked-by: Guolin Yang <gyang@vmware.com>
> ---
>  drivers/net/vmxnet3/vmxnet3_drv.c | 11 +++++++++--
>  1 file changed, 9 insertions(+), 2 deletions(-)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
