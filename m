Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA54A682981
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 10:51:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbjAaJvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 04:51:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229742AbjAaJvK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 04:51:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B90E36A63;
        Tue, 31 Jan 2023 01:51:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7644CB818F2;
        Tue, 31 Jan 2023 09:51:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CBD1C433D2;
        Tue, 31 Jan 2023 09:51:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675158661;
        bh=V8gAh3ri4wZBadm5hNcJIPEQL9xeZUsu2bVuWrrPdSE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jBntliXz2JlXEzBtMZngIXEY04Ph4GdWEHFycVKmU98c0pPXT/7SnSF2uL2oEM3qP
         Yd6dvP01+HYxVc/rlFWBcsxQ7vRrTqvfJq3ZeyF61Q3YOEfFEA6HqThs0/dHU2eKEB
         jP1ZpUdMZPpfsb03RfMTwfiBHjlvo7b8p79/o+fM=
Date:   Tue, 31 Jan 2023 10:50:58 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Neeraj Sanjay Kale <neeraj.sanjaykale@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, marcel@holtmann.org,
        johan.hedberg@gmail.com, luiz.dentz@gmail.com,
        jirislaby@kernel.org, alok.a.tiwari@oracle.com, hdanton@sina.com,
        ilpo.jarvinen@linux.intel.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-serial@vger.kernel.org,
        amitkumar.karwar@nxp.com, rohit.fule@nxp.com, sherry.sun@nxp.com
Subject: Re: [PATCH v2 1/3] serdev: Add method to assert break
Message-ID: <Y9jkgqgE9X7gD+Nl@kroah.com>
References: <20230130180504.2029440-1-neeraj.sanjaykale@nxp.com>
 <20230130180504.2029440-2-neeraj.sanjaykale@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230130180504.2029440-2-neeraj.sanjaykale@nxp.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 30, 2023 at 11:35:02PM +0530, Neeraj Sanjay Kale wrote:
> Adds serdev_device_break_ctl() and an implementation for ttyport.

Please write a complete changelog text, as our documentation asks you
to.  This does not explain anything here :(

thanks,

greg k-h
