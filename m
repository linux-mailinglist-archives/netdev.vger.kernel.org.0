Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC056C6E2E
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 17:56:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjCWQ4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 12:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230009AbjCWQ43 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 12:56:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090FEB5;
        Thu, 23 Mar 2023 09:56:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 976676280C;
        Thu, 23 Mar 2023 16:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B038EC433D2;
        Thu, 23 Mar 2023 16:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679590588;
        bh=vFt7EFogmrQM1SMz/gAuhI/oayXvCCfjYZFkWTluvxM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qDyrq0OdtVaxpdwIPj2xWPKYb1AcLqgxg7aowOoxZzN32lgnJaFhZkURo+7A3d7Il
         IzYzZKqFk033Kn04/fyrCk++A7q9/e3hBOR1F1pWEYAJYiEGeYXFlWZWSd3NEcWvcH
         3qIaoInFHGJUluLB46AsCb+4Kbz50l9D/tYdkod7j8PwA4qBJLDJKlqSFmoqeRH0JI
         h8dw6gGbSgHBosc+1yty1SNaS1zuYUE+SnAmB5nlMtZjTgRR9RmgyQCwlMKdmqPv2U
         JhLbi15gfOK4SzwPjgNSAqV6Jw+4ufxQBg2+6Z+k0clMsMFBHpNxgbkaLzsWYg1Wth
         SZBqgGKFxXBvg==
Date:   Thu, 23 Mar 2023 09:56:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Min Li <lnimi@hotmail.com>
Cc:     richardcochran@gmail.com, lee@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Min Li <min.li.xe@renesas.com>
Subject: Re: [PATCH mfd-n 1/2] ptp: clockmatrix: support 32-bit address
 space
Message-ID: <20230323095626.14d6d4da@kernel.org>
In-Reply-To: <MW5PR03MB69324DE0DEA03E3C62C57447A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
References: <MW5PR03MB69324DE0DEA03E3C62C57447A0879@MW5PR03MB6932.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Mar 2023 12:15:17 -0400 Min Li wrote:
> -		err = idtcm_write(idtcm, 0, HW_Q8_CTRL_SPARE,
> +		err = idtcm_write(idtcm, HW_Q8_CTRL_SPARE, 0,
>  				  &temp, sizeof(temp));

The flipping of the arguments should also be a separate patch.
