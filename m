Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D5B265B821
	for <lists+netdev@lfdr.de>; Tue,  3 Jan 2023 00:18:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbjABXSP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Jan 2023 18:18:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230012AbjABXSO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Jan 2023 18:18:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D85063E4
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 15:18:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 393C7B80DCE
        for <netdev@vger.kernel.org>; Mon,  2 Jan 2023 23:18:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE9CC433EF;
        Mon,  2 Jan 2023 23:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672701490;
        bh=3nyArTaz8eUWYtqp/Ciy+qGkAHCP9mv77Gpc2WxTYKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P7l4oaGP8CRFE4bD75TF/677FvmB36WrgX0QGGpZf2OkNMgNHJMr3kTHodFzlu8X5
         KsmRIE+14dsArvWB14iW1B9CJdyhI4zC50Dquq0AgVXGuAZ/MaufCLwyEDwnNm29bp
         qbOjIlmZBobk+2is0Ts7A4FCvU9tl7kI5tmB6af4Y+fetLTKFG+E5OZvISornQ9B3e
         wpAmKw8f0VHfaLU2b7HQ/pLWibSX6nOaNoaAKnWIDy2+UBLLb2C2lBULKu0KEfajpQ
         L0b9reX4RmEiHqhmAie3q6AVx/DVvepqIO0A0e0X7oIlNuhlFUKcIpSwfSwvSLeBkK
         kg4joiSHFow2w==
Date:   Mon, 2 Jan 2023 15:18:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     jacob.e.keller@intel.com, leon@kernel.org, netdev@vger.kernel.org
Subject: Re: [RFC net-next 05/10] devlink: remove the registration guarantee
 of references
Message-ID: <20230102151809.7802d504@kernel.org>
In-Reply-To: <Y7Lq5KbFWjTDGmz0@nanopsycho>
References: <20221217011953.152487-1-kuba@kernel.org>
        <20221217011953.152487-6-kuba@kernel.org>
        <Y7Lq5KbFWjTDGmz0@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2 Jan 2023 15:32:04 +0100 Jiri Pirko wrote:
> >Holding a reference will now only guarantee that the memory
> >of the object is around. Another way of looking at it is that
> >the reference now protects the object not its "registered" status.  
> 
> This would help to understand what you are doing in patch 3. Perphaps it
> would be fine to describe the goal in the cover letter?

Fair point, will do!
