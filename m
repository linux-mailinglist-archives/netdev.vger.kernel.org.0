Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65B2353938E
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 17:06:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345344AbiEaPGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 11:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243219AbiEaPGA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 11:06:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4503985A0
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 08:05:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7D646B80FD3
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 15:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B7C3C385A9;
        Tue, 31 May 2022 15:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654009557;
        bh=XEvgE74Obby2edhPz9vT82jWkYSv3e4Tebc+jnVhAJM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=dkxb9CIR59urCv6UL6Khw1X0oPWNFr56w2/KUhgZBdqh24Pui5ay90faKrxgBMLZG
         HGkkabCfs6i66rpMXJEjsvot9sxOk7apoB9HnAxhxtE17zU0CscJ+1xisFANtD/xJS
         u55uFsvWlHGstC+kdM2j5DEovvWlSYWhNHDWA4IULeOI47lyIdUW1/XmfdXQlu+eF/
         wUkseoRLlAH9tErxyDngutEqsLQgOT/amuSBhCNUk4pQB8yo7FkglH8Clp1RRjeoic
         wr815HnDcm/uau3Dhweuu1Z0tYcC+DJo3FzNi+WihFM/VwdSPZYNW7jYBSdTHLtWcv
         n/GZB4rVz2opA==
Date:   Tue, 31 May 2022 08:05:55 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     Ido Schimmel <idosch@idosch.org>, Ido Schimmel <idosch@nvidia.com>,
        netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        jiri@nvidia.com, petrm@nvidia.com, dsahern@gmail.com,
        andrew@lunn.ch, mlxsw@nvidia.com
Subject: Re: [PATCH net-next 00/11] mlxsw: extend line card model by devices
 and info
Message-ID: <20220531080555.29b6ec6b@kernel.org>
In-Reply-To: <YpW/n3Nh8fIYOEe+@nanopsycho>
References: <Yo3KvfgTVTFM/JHL@nanopsycho>
        <20220525085054.70f297ac@kernel.org>
        <Yo9obX5Cppn8GFC4@nanopsycho>
        <20220526103539.60dcb7f0@kernel.org>
        <YpB9cwqcSAMslKLu@nanopsycho>
        <20220527171038.52363749@kernel.org>
        <YpHmrdCmiRagdxvt@nanopsycho>
        <20220528120253.5200f80f@kernel.org>
        <YpM7dWye/i15DBHF@nanopsycho>
        <20220530125408.3a9cb8ed@kernel.org>
        <YpW/n3Nh8fIYOEe+@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 31 May 2022 09:11:27 +0200 Jiri Pirko wrote:
> >Nevermind, I think we can iterate over all the groupings.
> >Since I hope you agreed that component has an established  
> 
> Yeah, component=version. I will send a RFC soon that tights it together.
> 
> >meaning can we use group instead?  
> 
> Group of what? Could you provide me example what you mean?

Group of components. As explained component has an existing meaning,
we can't reuse the term with a different one now.

> >> Sorry, I'm a bit lost. Could you please provide some example about how
> >> you envision it? For me it is a guessing game :/
> >> My guess is you would like to add to the version nest where
> >> DEVLINK_ATTR_INFO_VERSION_NAME resides for example
> >> DEVLINK_ATTR_LINECARD_INDEX?
> >> 
> >> Correct?  
> >
> >Yup.  
> 
> Hmm, in that case, I'm not sure how to do this. As cmd options and       
> outputs should match, we would have:                                     
>                                                           
> devlink dev info                                                         
> lc2.fw 19.2010.1310                                                      
>                                                                          
> here lc2 and fw are concatenated from DEVLINK_ATTR_LINECARD_INDEX and DEVLINK_ATTR_INFO_VERSION_NAME

lc2 is the group name.
                                                     
> Now on devlink dev flash side, when I pass "component lc2.fw", how could 
> the "devlink dev flash" know to divide it to DEVLINK_ATTR_LINECARD_INDEX 
> and FLASH_COMPONENT? Should I parse the cmd line option and figure the
> "lcX." prefix into an attribute?
>                                                        
> Or, we would have to have something like:                                    
> devlink dev flash pci/0000:01:00.0 lc 2 component fw file mellanox/fw-AGB-rel-19_2010_1312-022-EVB.mfa2

Yup, it'll make DaveA happy as well.

> But to be consistent with the output, we would have to change "devlink   
> dev info" to something like:                                             
> pci/0000:01:00.0:                                                        
>   versions:                                                              
>       running:                                                           
>         fw 1.2.3                                                         
>         fw.mgmt 10.20.30                                                 
>         lc 2 fw 19.2010.1310                                             

Yup.
                                                            
> But that would break the existing JSON output, because "running" is an array:
>                 "running": {                                             
>                     "fw": "1.2.3",                                       
>                     "fw.mgmt": "10.20.30"                                
>                 },                                                       

No, the lc versions should be in separate nests. Since they are not
updated when flashing main FW mixing them into existing versions would
break uAPI.

> So probably better to stick to "lcx.y" notation in both devlink dev info
> and flash and split/squash to attributes internally. What do you think?

BTW how do you intend to activate the new FW? Extend the reload command?
