Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E948952F6F6
	for <lists+netdev@lfdr.de>; Sat, 21 May 2022 02:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236542AbiEUAk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 20:40:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235683AbiEUAkZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 20:40:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66AF91ACF8A;
        Fri, 20 May 2022 17:40:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2059BB82EC9;
        Sat, 21 May 2022 00:40:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F13C385A9;
        Sat, 21 May 2022 00:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653093621;
        bh=AwUUattJFktBCd0thsSFibnjEd2p0pvJMpaz9bsVqqg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FzN53rYxnyyibD/aD7cowwt1FF6u9Yt8LNY86BXAL6+Nqb4XrQtuulyzpbN0+cLcE
         MsP++2KFlUo5COpVhDELK8PdwVmwslzBwwFtC14kPUntHZRSMop+t1/GZ86wKRPLfm
         ikrZQaUupuUYVKpwheD2v9dmvHFC01QgGGieow2MTiE3vTxtdSkjpIw0bVk82K1Zk5
         0ZWGcHn2HukQ2qRnwTXOF5U17dkdZOuFLAJjy8nX/mqHVNfus/HjPcgHoRXLBAlh/a
         c9apJFJm0V0phDatvX4ygaGoJQh5qy0CFk+FxUq1Tmb8/T+0ZUc2hwwFCH361Sh7/K
         zYg2V+rAtl03w==
Date:   Fri, 20 May 2022 17:40:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Roopa Prabhu <roopa@nvidia.com>
Cc:     Alaa Mohamed <eng.alaamohamedsoliman.am@gmail.com>,
        netdev@vger.kernel.org, outreachy@lists.linux.dev,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2] net: vxlan: Fix kernel coding style
Message-ID: <20220520174020.3cffce01@kernel.org>
In-Reply-To: <7dbf218e-1a9a-13a4-6b6f-0e23899fb1cb@nvidia.com>
References: <20220520003614.6073-1-eng.alaamohamedsoliman.am@gmail.com>
        <7dbf218e-1a9a-13a4-6b6f-0e23899fb1cb@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 May 2022 22:06:53 -0700 Roopa Prabhu wrote:
> > @@ -1138,7 +1138,7 @@ static int vxlan_fdb_parse(struct nlattr *tb[], struct vxlan_dev *vxlan,
> >   	if (tb[NDA_NH_ID] && (tb[NDA_DST] || tb[NDA_VNI] || tb[NDA_IFINDEX] ||
> >   	    tb[NDA_PORT])) {
> >   			NL_SET_ERR_MSG(extack,
> > -						  "DST, VNI, ifindex and port are mutually exclusive with NH_ID");
> > +					"DST, VNI, ifindex and port are mutually exclusive with NH_ID");  
> it looks still off by a space.
> 
> >   			return -EINVAL;
> >   		}  
> 
> 
> this closing brace should line up with the if

Let me just fix this myself when applying... There were 3 separate
postings of v2, and they weren't even identical :(
