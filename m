Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7099D26045C
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 20:16:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729433AbgIGSP5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 14:15:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:35472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728421AbgIGSPy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Sep 2020 14:15:54 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C21020732;
        Mon,  7 Sep 2020 18:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599502553;
        bh=HMfH03YFktrnGLz7Ry3s392p+fH+S8X4kWzPrjgbpkg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GN5qZaqazHD+wnnLvGnY7Ql7WNXe00bPkZfEj04TvlxU74gIxyU8QfuLcT7DKuPb0
         FlHntndMazrilYZA8KUGV7d4kkArPspIbgMNJle3rBSelJVBUsHqSalYlL9j3C1tGN
         PrX4gFYZlOayburJhKjSmt4f2COWcO+/zPXAIqTE=
Date:   Mon, 7 Sep 2020 14:15:52 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kristian Evensen <kristian.evensen@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable <stable@vger.kernel.org>,
        Daniele Palmas <dnlplm@gmail.com>,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Network Development <netdev@vger.kernel.org>,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.14 17/33] net: usb: qmi_wwan: add Telit 0x1050
 composition
Message-ID: <20200907181552.GN8670@sasha-vm>
References: <20191026132110.4026-1-sashal@kernel.org>
 <20191026132110.4026-17-sashal@kernel.org>
 <CAKfDRXjjuW4VM03HeVoeEyG=cULUK8ZXexWu48rfFvJE+DD8_g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKfDRXjjuW4VM03HeVoeEyG=cULUK8ZXexWu48rfFvJE+DD8_g@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 07, 2020 at 11:36:37AM +0200, Kristian Evensen wrote:
>Hi,
>
>On Sat, Oct 26, 2019 at 3:27 PM Sasha Levin <sashal@kernel.org> wrote:
>>
>> From: Daniele Palmas <dnlplm@gmail.com>
>>
>> [ Upstream commit e0ae2c578d3909e60e9448207f5d83f785f1129f ]
>>
>> This patch adds support for Telit FN980 0x1050 composition
>>
>> 0x1050: tty, adb, rmnet, tty, tty, tty, tty
>>
>> Signed-off-by: Daniele Palmas <dnlplm@gmail.com>
>> Acked-by: Bjørn Mork <bjorn@mork.no>
>> Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/net/usb/qmi_wwan.c | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
>> index e406a05e79dcd..57e9166b4bff3 100644
>> --- a/drivers/net/usb/qmi_wwan.c
>> +++ b/drivers/net/usb/qmi_wwan.c
>> @@ -1252,6 +1252,7 @@ static const struct usb_device_id products[] = {
>>         {QMI_FIXED_INTF(0x2357, 0x0201, 4)},    /* TP-LINK HSUPA Modem MA180 */
>>         {QMI_FIXED_INTF(0x2357, 0x9000, 4)},    /* TP-LINK MA260 */
>>         {QMI_QUIRK_SET_DTR(0x1bc7, 0x1040, 2)}, /* Telit LE922A */
>> +       {QMI_QUIRK_SET_DTR(0x1bc7, 0x1050, 2)}, /* Telit FN980 */
>>         {QMI_FIXED_INTF(0x1bc7, 0x1100, 3)},    /* Telit ME910 */
>>         {QMI_FIXED_INTF(0x1bc7, 0x1101, 3)},    /* Telit ME910 dual modem */
>>         {QMI_FIXED_INTF(0x1bc7, 0x1200, 5)},    /* Telit LE920 */
>> --
>> 2.20.1
>>
>
>When testing the FN980 with kernel 4.14, I noticed that the qmi device
>was not there. Checking the git log, I see that this patch was never
>applied. The patch applies fine, so I guess it was just missed
>somewhere. If it could be added to the next 4.14 release, it would be
>much appreciated.

Interesting, yes - I'm not sure why it's missing. I'll queue it up.

-- 
Thanks,
Sasha
