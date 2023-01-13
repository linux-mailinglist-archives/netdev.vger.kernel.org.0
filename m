Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9CCD7669271
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 10:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbjAMJKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 04:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241102AbjAMJI2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 04:08:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 698B895B2;
        Fri, 13 Jan 2023 01:06:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92488B820D0;
        Fri, 13 Jan 2023 09:06:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E4C4C433D2;
        Fri, 13 Jan 2023 09:05:55 +0000 (UTC)
Message-ID: <649a45a5-1680-dd71-ed74-df16d4353638@xs4all.nl>
Date:   Fri, 13 Jan 2023 10:05:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 20/22] media: remove sh_vou
Content-Language: en-US
To:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        linux-kernel@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arch@vger.kernel.org,
        dmaengine@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-renesas-soc@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-mtd@lists.infradead.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-rtc@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-fbdev@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-sh@vger.kernel.org
References: <20230113062339.1909087-1-hch@lst.de>
 <20230113062339.1909087-21-hch@lst.de>
 <Y8EPvllOwhODRUiP@pendragon.ideasonboard.com>
From:   Hans Verkuil <hverkuil@xs4all.nl>
In-Reply-To: <Y8EPvllOwhODRUiP@pendragon.ideasonboard.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,NICE_REPLY_A,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/01/2023 09:01, Laurent Pinchart wrote:
> Hi Christoph,
> 
> Thank you for the patch.
> 
> On Fri, Jan 13, 2023 at 07:23:37AM +0100, Christoph Hellwig wrote:
>> Now that arch/sh is removed this driver is dead code.
>>
>> Signed-off-by: Christoph Hellwig <hch@lst.de>
>> ---
>>  drivers/media/platform/renesas/Kconfig  |    9 -
>>  drivers/media/platform/renesas/Makefile |    1 -
>>  drivers/media/platform/renesas/sh_vou.c | 1375 -----------------------
> 
> You can also emove include/media/drv-intf/sh_vou.sh. With that, and the
> corresponding MAINTAINERS entry dropped,
> 
> Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

And with that you can also add my Ack:

Acked-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>

Regards,

	Hans

> 
>>  3 files changed, 1385 deletions(-)
>>  delete mode 100644 drivers/media/platform/renesas/sh_vou.c
> 

