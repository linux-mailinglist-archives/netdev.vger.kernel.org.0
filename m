Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02DAC68E8E3
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 08:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230478AbjBHHZf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 02:25:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjBHHZe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 02:25:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ACAE8A70;
        Tue,  7 Feb 2023 23:25:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A9E161470;
        Wed,  8 Feb 2023 07:25:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11836C433D2;
        Wed,  8 Feb 2023 07:25:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675841132;
        bh=/pSu4sN1FOv54WLcqhlgwWyk3CWqrwNXv+NvvH1SSSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bPRs97iVL2YaNbkC74wvG5kVNqHaEu+2ZlpAjS57oELyn+v0GkPw3yMtDWzH02QUu
         o/suP98dFUzGNuugOYonY1N2fCsnr80xxam0dkOq1oV/e5k/L5vX5SAbAwsUeZNqWL
         2wC8M/rYlWWo1qWR5Ce0cG6w7WCBa1ft1j7PHEZY=
Date:   Wed, 8 Feb 2023 08:25:29 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ronak Doshi <doshir@vmware.com>, netdev@vger.kernel.org,
        stable@vger.kernel.org,
        VMware PV-Drivers Reviewers <pv-drivers@vmware.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net ] vmxnet3: move rss code block under eop descriptor
Message-ID: <Y+NOaUHBQGxrYuf2@kroah.com>
References: <20230207192849.2732-1-doshir@vmware.com>
 <20230207221221.52de5c9a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207221221.52de5c9a@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 07, 2023 at 10:12:21PM -0800, Jakub Kicinski wrote:
> On Tue, 7 Feb 2023 11:28:49 -0800 Ronak Doshi wrote:
> > Commit b3973bb40041 ("vmxnet3: set correct hash type based on
> > rss information") added hashType information into skb. However,
> > rssType field is populated for eop descriptor.
> > 
> > This patch moves the RSS codeblock under eop descritor.
> 
> Does it mean it always fails, often fails or occasionally fails 
> to provide the right hash?
> 
> Please add a Fixes tag so that the patch is automatically pulled 
> into the stable releases.

Fixes: is not the way to do this, you need a cc: stable in the
signed-off-by area please as the documentation has stated for 16+ years :)

thanks,

greg k-h
