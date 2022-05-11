Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4403524131
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:46:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349467AbiEKXqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:46:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349478AbiEKXqD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:46:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 039CE2EA39;
        Wed, 11 May 2022 16:46:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F4228610A5;
        Wed, 11 May 2022 23:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B714C340EE;
        Wed, 11 May 2022 23:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652312760;
        bh=/Ta0f+2gymdJ8FVVhEzKJWIQ4s8cxQl8WFbNerXlXJg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MfwlTo9C9uwFMvIDvZ+bCrqICRFrr9Hgb/0jKa52oksbqiuMnqQZiiEQaagL394CJ
         yDVNMpGbekVdxvi5VB6HSfF3/hdsgMrJtSm/0soWS7v8YEAk4TT2JgKNrNkw/OTGir
         v9OcrlI8iV4tAEtSY+eVTfLaY8yVtfzB3u9dSb6VNT+cLWZ6FVNPoJA72x3Ea0IWmi
         tmyarR3OYAiFTmx8cE5i5juk2LeAVw/wV3sxgV85j4laTd1KXvupsOEgxqQmbHEgcP
         paE8BHxnQdlSqQ8DYKLbWjvxYcFR6MnXzuA0AJK4csRm15b1aCCfz8fcsRY2RiNDHq
         dTKmU1wG36PBw==
Date:   Wed, 11 May 2022 16:45:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ober <dober6023@gmail.com>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, hayeswang@realtek.com, aaron.ma@canonical.com,
        mpearson@lenovo.com, dober@lenovo.com
Subject: Re: [PATCH] Additions to the list of devices that can be used for
 Lenovo Pass-thru feature
Message-ID: <20220511164555.732bd777@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20220511093826.245118-1-dober6023@gmail.com>
References: <20220511093826.245118-1-dober6023@gmail.com>
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

On Wed, 11 May 2022 05:38:26 -0400 David Ober wrote:
>  #define DEVICE_ID_THINKPAD_THUNDERBOLT3_DOCK_GEN2	0x3082
> +#define DEVICE_ID_THINKPAD_THUNDERBOLT4_DOCK_GEN1	0x8153
> +#define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN3		0x3062
> +#define DEVICE_ID_THINKPAD_USB_C_DONGLE		0x720c
>  #define DEVICE_ID_THINKPAD_USB_C_DOCK_GEN2		0xa387

Keep these sorted in some logical way please, USB_C_DOCK_GEN3 should
probably be after USB_C_DOCK_GEN2?
