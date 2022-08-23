Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D489259CF0C
	for <lists+netdev@lfdr.de>; Tue, 23 Aug 2022 05:03:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239771AbiHWDAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 23:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239474AbiHWDA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 23:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF85F4BD3C
        for <netdev@vger.kernel.org>; Mon, 22 Aug 2022 20:00:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F7276125D
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 03:00:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85392C433C1;
        Tue, 23 Aug 2022 03:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661223627;
        bh=rTnFXgyjoWyf7AAIrY0UfHzVwLzJqVe9TOq2aZ1gc2A=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=YJtmMy/3P8uCL3zf3NuJxW5dtocDdnMIDcG4J39tTS53/nxDeqiI5v4GZMRB++neN
         TEi2cSUA5MpciIV9RmkL+92Ey8la1GT/OKsG/U/5p8hmbABFhDi1zy+zqAS5+6VLQB
         U5G9gPVIRohx0CywOBLUmlMQQHwocpwrEjUlqsdeBK4v61gMAlc252cjOeUiW8aN2G
         W80aeVc5hU66K5hVbxmsWOXQRhNW+EjE0/Pv9A3AlA/bQgcf1IQClZnKbyOVo2Ddpw
         kvXxLqi+Qh5g0/u8qGUmN48kyBLRHiUVYg+Vq5xnkoV2OGdO1ziQk3iTVVGxxFxuBa
         VrMX0+AUlkrmQ==
Date:   Mon, 22 Aug 2022 20:00:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next v2 1/4] net: devlink: extend info_get() version
 put to indicate a flash component
Message-ID: <20220822200026.12bdfbf9@kernel.org>
In-Reply-To: <20220822170247.974743-2-jiri@resnulli.us>
References: <20220822170247.974743-1-jiri@resnulli.us>
        <20220822170247.974743-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 22 Aug 2022 19:02:44 +0200 Jiri Pirko wrote:
> +int devlink_info_version_running_put_ext(struct devlink_info_req *req,
> +					 const char *version_name,
> +					 const char *version_value,
> +					 enum devlink_info_version_type version_type);

Why are we hooking into running, wouldn't stored make more sense?
