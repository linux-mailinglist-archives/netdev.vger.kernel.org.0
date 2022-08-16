Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B78E0595E5A
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 16:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234330AbiHPO3V (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 10:29:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229875AbiHPO3T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 10:29:19 -0400
X-Greylist: delayed 409 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 16 Aug 2022 07:29:18 PDT
Received: from radex-web.radex.nl (smtp.radex.nl [178.250.146.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3072377562;
        Tue, 16 Aug 2022 07:29:17 -0700 (PDT)
Received: from [192.168.1.35] (cust-178-250-146-69.breedbanddelft.nl [178.250.146.69])
        by radex-web.radex.nl (Postfix) with ESMTPS id 7FB742406A;
        Tue, 16 Aug 2022 16:22:27 +0200 (CEST)
Message-ID: <98c22ea0-ce1d-ab7e-5d87-da85660ab8ec@gmail.com>
Date:   Tue, 16 Aug 2022 16:22:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: smsc95xx driver
Content-Language: en-US
To:     Iryna Semenovych <iryna.semenovych@chargex.de>,
        netdev@vger.kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@collabora.com,
        Steve Glendinning <steve.glendinning@shawell.net>,
        UNGLinuxDriver@microchip.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, stable@kernel.org
References: <CAJU7JFAscYncnRLSNGrs4n22EzkxZBTWW6hQuk2WRGcUPwoXNw@mail.gmail.com>
From:   Ferry Toth <fntoth@gmail.com>
In-Reply-To: <CAJU7JFAscYncnRLSNGrs4n22EzkxZBTWW6hQuk2WRGcUPwoXNw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.7 required=5.0 tests=BAYES_00,DKIM_ADSP_CUSTOM_MED,
        FORGED_GMAIL_RCVD,FREEMAIL_FROM,NICE_REPLY_A,NML_ADSP_CUSTOM_MED,
        SPF_HELO_NONE,SPF_SOFTFAIL,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On 16-08-2022 11:44, Iryna Semenovych wrote:
> Hi folks!
>
> Recently I found the discussion in the archive about smsc95xx driver 
> patch that introduces some other issues:
> https://lore.kernel.org/netdev/93d3bb50040dd4519a65187d3412973831d2d797.camel@collabora.com/
>
> I am struggling with the similar/the same issue that is described in 
> detail here:
> https://github.com/raspberrypi/linux/issues/5116
>
I believe that a number patches have just been backported for usbnet: 
smsc95xx for 5.15 and 5.18 that might resolve your issue.

I did find another crash:

DMA-API: xhci-hcd xhci-hcd.1.auto: cacheline tracking EEXIST, > > > 
overlapping mappings aren't supported But it appears happens in the hub 
code as other hubs then smsc95xx also have that error. This one has not 
yet been resolved.

> Does anybody know if this issue is even related to smsc95xx driver 
> changes or how it can be fixed?
> I would really appreciate any help.
>
> Thanks in advance!
>
> -- 
> *Best regards, *
> *Iryna Semenovych*
> Software Engineer
>
> T:   +49 157 31090173
> M: iryna.semenovych@chargex.de
> W: www.chargex.de <http://www.chargex.de>
>
> ChargeX GmbH
> Landsberger Str. 318a, 80687 München
