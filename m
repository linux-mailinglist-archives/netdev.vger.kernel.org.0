Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3AC63B162
	for <lists+netdev@lfdr.de>; Mon, 28 Nov 2022 19:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbiK1SdD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Nov 2022 13:33:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233471AbiK1Scj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Nov 2022 13:32:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 247652DE
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 10:29:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4BA7B80EFD
        for <netdev@vger.kernel.org>; Mon, 28 Nov 2022 18:29:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38056C433C1;
        Mon, 28 Nov 2022 18:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669660194;
        bh=VnDFhkSQ6g8VX4h55LXVgbyTsofurikWX97igWFSmL8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tcYzJgEfAu/sIMbREHvIPdZtp5eCQIAr8nusmpBWTP4W7OWwbkU3hwhHmfZg8enfo
         4lOeE6r5Iqs4tpsfJm27tx6HY2FTeYNgoK/nAxiw73GqfnafqePVtPm9VRIiFItiLs
         4910M7xaW/U5LMMZiskimXpzou49uPz+3bw7K58ZUobbnHGU1xnui7cmQc2brC+1ej
         3T5+oWIJHDOEUp1chgnigW9iCM5dT3gi+7tuRANMyfd7LJzRlj/YdOkf6exWiICcTR
         +QFotiAbF5c5ymW6OkGbuaB6aZ0KvkQxdkCn/oWv0F8j3lTlpsPgVan52v19B+IAH/
         hkknp3ppipgHA==
Date:   Mon, 28 Nov 2022 10:29:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, mst@redhat.com,
        jasowang@redhat.com, virtualization@lists.linux-foundation.org,
        drivers@pensando.io
Subject: Re: [RFC PATCH net-next 10/19] pds_core: devlink params for
 enabling VIF support
Message-ID: <20221128102953.2a61e246@kernel.org>
In-Reply-To: <20221118225656.48309-11-snelson@pensando.io>
References: <20221118225656.48309-1-snelson@pensando.io>
        <20221118225656.48309-11-snelson@pensando.io>
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

On Fri, 18 Nov 2022 14:56:47 -0800 Shannon Nelson wrote:
> +	DEVLINK_PARAM_DRIVER(PDSC_DEVLINK_PARAM_ID_LM,
> +			     "enable_lm",
> +			     DEVLINK_PARAM_TYPE_BOOL,
> +			     BIT(DEVLINK_PARAM_CMODE_RUNTIME),
> +			     pdsc_dl_enable_get,
> +			     pdsc_dl_enable_set,
> +			     pdsc_dl_enable_validate),

Terrible name, not vendor specific.
