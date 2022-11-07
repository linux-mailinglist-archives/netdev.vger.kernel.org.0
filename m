Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5C7861FB46
	for <lists+netdev@lfdr.de>; Mon,  7 Nov 2022 18:26:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232708AbiKGR0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Nov 2022 12:26:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKGR02 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Nov 2022 12:26:28 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B75E24087;
        Mon,  7 Nov 2022 09:26:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1CBE8CE177A;
        Mon,  7 Nov 2022 17:26:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025BCC433C1;
        Mon,  7 Nov 2022 17:26:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667841984;
        bh=le3qQP+UzKjEIMtvMV/+L94RSLXOKmLB+SLp0eqM5Uc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MWY+VZknRF67YlgxJHvjlOTkdl4CzHalTPwQP1qMCIy+jcWPPwFdx+zD3Ge9AGXsF
         jpxnKJ5T8FyieLuNvT60tVqG1CwPBVC8ZRmC8aCnfS85EAGZytxpMjUZJLoJL9ByPw
         CyaVHiD4JIji05wTbri6fvQLNtmZ7B9E2maRd8hZ+7FQ135DGGaku/3m9bVcqso6Yv
         avb1TocFJJwP/M4a29VPHc1ucuRfwAyzB33BATQFq8+4vwmODpA8H/r/B4I+dtHdbV
         /4YHZVQscpB20D11LKqTeCeEbIygpark6/uW5CoxpLprotfWfKSZ9SclJY/kW06jop
         GpbRoZxACHw6Q==
Date:   Mon, 7 Nov 2022 19:26:19 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Ajit Khaparde <ajit.khaparde@broadcom.com>,
        andrew.gospodarek@broadcom.com, davem@davemloft.net,
        edumazet@google.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, michael.chan@broadcom.com,
        netdev@vger.kernel.org, pabeni@redhat.com,
        selvin.xavier@broadcom.com
Subject: Re: [PATCH v3 0/6] Add Auxiliary driver support
Message-ID: <Y2k/u10MbMGnAg3s@unreal>
References: <CACZ4nhtmE9Dh9z_O9-A934+q0_8yHEyj+V-DcEsuEWFbPH6BGg@mail.gmail.com>
 <20221104162733.73345-1-ajit.khaparde@broadcom.com>
 <Y2inmdbpoRm2VbuE@unreal>
 <20221107080605.35ef5622@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107080605.35ef5622@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 07, 2022 at 08:06:05AM -0800, Jakub Kicinski wrote:
> On Mon, 7 Nov 2022 08:37:13 +0200 Leon Romanovsky wrote:
> > Please send this series as standalone one and not as a reply
> > to previous discussion. Reply-to messes review flow, especially
> > for series.
> > 
> > Jakub, I'll review it once Ajit will send it properly.
> 
> IIUC we wait for you or Jason to review any of the RoCE bifurcation
> patches before considering them for inclusion.

Thanks
