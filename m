Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E40868E579
	for <lists+netdev@lfdr.de>; Wed,  8 Feb 2023 02:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230188AbjBHBcM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 20:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBHBcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 20:32:07 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 697E618B2C;
        Tue,  7 Feb 2023 17:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=jo71tlA2eEZPdxKjgTvLhMtzKyjxK2QlLMd+t0w/e3Q=; b=ay2mX2FLZ3Pvx6L5UJcyeffPih
        Z2FzC7RnqKsgae3U/fJ+2MREDfNnYcX+7/DIUMs8G3h8JY9UkvYd4HWnOOk7Is6BNTJaTYAZxe1vf
        l8LfWY1qS4pm/xpZ6w6Q4zuQ/rSlOUnCWslbQWOSRIy7DLC8xbsQgRlz+/9U8gmSYKYFTGHng3Won
        9zYe4KLDgG2h5xOK/JslAPD/TMcDxUIDr8Uh+bYJm6gP5/ICWPz84oG5SIr1LjuTibzDMj3s3eZNT
        vAuQJO05IAMM1Vxg5h6AY1cFu3fy6HRqxOeCQZZ0SMxWcVxafZAqAdGTnLRRAF2dInznQN6ckvsDV
        zMkQoO9Q==;
Received: from [2601:1c2:980:9ec0::df2f]
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPZJD-00Dmp1-1J; Wed, 08 Feb 2023 01:31:39 +0000
Message-ID: <0e26bf17-864e-eb22-0d07-5b91af4fde92@infradead.org>
Date:   Tue, 7 Feb 2023 17:31:37 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: remove arch/sh
To:     John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Christoph Hellwig <hch@lst.de>
Cc:     Yoshinori Sato <ysato@users.sourceforge.jp>,
        Rich Felker <dalias@libc.org>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
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
 <11e2e0a8-eabe-2d8c-d612-9cdd4bcc3648@physik.fu-berlin.de>
 <20230116071306.GA15848@lst.de>
 <40dc1bc1-d9cd-d9be-188e-5167ebae235c@physik.fu-berlin.de>
 <20230203071423.GA24833@lst.de>
 <60ed320c8f5286e8dbbf71be29b760339fd25069.camel@physik.fu-berlin.de>
Content-Language: en-US
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <60ed320c8f5286e8dbbf71be29b760339fd25069.camel@physik.fu-berlin.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/7/23 01:06, John Paul Adrian Glaubitz wrote:
> Hello Christoph!
> 
> On Fri, 2023-02-03 at 08:14 +0100, Christoph Hellwig wrote:
>> On Mon, Jan 16, 2023 at 09:52:10AM +0100, John Paul Adrian Glaubitz wrote:
>>> We have had a discussion between multiple people invested in the SuperH port and
>>> I have decided to volunteer as a co-maintainer of the port to support Rich Felker
>>> when he isn't available.
>>
>> So, this still isn't reflected in MAINTAINERS in linux-next.  When
>> do you plan to take over?  What platforms will remain supported and
>> what can we start dropping due to being unused and unmaintained?
> 
> I'm getting everything ready now with Geert's help and I have a probably dumb
> question regarding the MAINTAINERS file change: Shall I just add myself as an
> additional maintainer first or shall I also drop Yoshinori Sato?
> 
> Also, is it desirable to add a "T:" entry for the kernel tree?

Yes, definitely.

thanks.
-- 
~Randy
