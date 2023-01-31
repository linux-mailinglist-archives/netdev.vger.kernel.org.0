Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314FA6823B2
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:17:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229815AbjAaFR4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:17:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjAaFRz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:17:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0B330D0;
        Mon, 30 Jan 2023 21:17:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6A9A36140C;
        Tue, 31 Jan 2023 05:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27574C433D2;
        Tue, 31 Jan 2023 05:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675142272;
        bh=r1QHAE5CMl8j0BmAlptuDNAWDYIcrrh/o2sPtM6Hjy0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R/mf3WwpaV5fsu3TWYLp1Q7l9wmQIvSUP24s1OjzHzw2swhBCMqHQ6DjW89eTTJW9
         Xz2sNGG2lXALXIIGf31/sza9eCol6tjosPjVaFJ9x0lGOrn4IqKUawpfNsOcdxfIuA
         0434uycuN89kzLeT1DOg05GMKNn9Yb8WHtc8uaUY=
Date:   Tue, 31 Jan 2023 06:17:49 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Natalia Petrova <n.petrova@fintech.ru>
Cc:     stable@vger.kernel.org,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lvc-project@linuxtesting.org
Subject: Re: [PATCH v2] i40e: Add checking for null for nlmsg_find_attr()
Message-ID: <Y9ikffXU/qV1DV7f@kroah.com>
References: <20230125141328.8479-1-n.petrova@fintech.ru>
 <20230130221106.19267-1-n.petrova@fintech.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130221106.19267-1-n.petrova@fintech.ru>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 01:11:06AM +0300, Natalia Petrova wrote:
> The result of nlmsg_find_attr() 'br_spec' is dereferenced in
> nla_for_each_nested(), but it can take null value in nla_find() function,
> which will result in an error.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 51616018dd1b ("i40e: Add support for getlink, setlink ndo ops")
> Signed-off-by: Natalia Petrova <n.petrova@fintech.ru>
> Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> ---
> v2: The remark about the error code by Simon Horman <simon.horman@corigine.com> 
> was taken into account; return value -ENOENT was changed to -EINVAL.
>  drivers/net/ethernet/intel/i40e/i40e_main.c | 2 ++
>  1 file changed, 2 insertions(+)
> 

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
